import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.orn 1.0

ListItem {
    readonly property bool _userComment: OrnClient.userId === model.userId
    readonly property bool _authorComment: model.userId === page.userId
    // Need for hint mode
    readonly property alias replyToLabel: replyToLabel

    function _setSinceCreated() {
        var created = model.created
        if (_hintMode) {
            createdLabel.text = created
            return
        }
        var mins = Math.round((new Date() / 1000 - created) / 60.0)
        if (mins < 1) {
            //% "Just now"
            createdLabel.text = qsTrId("orn-just-now")
            return
        }
        var hours = Math.round(mins / 60.0)
        if (hours < 1) {
            //% "%n minute(s) ago"
            createdLabel.text = qsTrId("orn-mins-ago", mins).arg(mins)
            return
        }
        var days = Math.round(hours / 24.0)
        if (days < 1) {
            //% "%n hour(s) ago"
            createdLabel.text = qsTrId("orn-hours-ago", hours).arg(hours)
        } else if (days == 1) {
            //% "Yesterday"
            createdLabel.text = qsTrId("orn-yesterday")
        } else {
            createdLabel.text = new Date(created * 1000).toLocaleDateString(_locale, Locale.LongFormat)
        }
    }

    contentHeight: content.height + Theme.paddingMedium * 2
    menu: OrnClient.authorised ? contextMenu : null
    highlighted: OrnClient.authorised && down
    _showPress: highlighted

    Connections {
        target: createdUpdateTimer
        onTriggered: _setSinceCreated()
    }

    ContextMenu {
        id: contextMenu

        MenuItem {
            //: Menu item to reply for a comment - should be a verb
            //% "Reply"
            text: qsTrId("orn-reply")
            onClicked: commentField.item.reply(model.commentId, model.userName, model.text)
        }

        MenuItem {
            //% "Edit"
            text: qsTrId("orn-edit")
            visible: _userComment
            onClicked: commentField.item.edit(model.commentId, model.text)
        }

//        MenuItem {
//            //% "Delete"
//            text: qsTrId("orn-delete")
//            visible: _userComment || OrnClient.userId === userId
//            //% "Deleting"
//            onClicked: remorseAction(qsTrId("orn-deleting"), function() {
//                OrnClient.deleteComment(comment.commentId)
//                commentsModel.removeRow(index, 1)
//            })
//        }
    }

    Column {
        id: content
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
        }
        spacing: Theme.paddingMedium

        Item {
            width: parent.width
            height: Math.max(userImage.height, contentHeader.height)

            Image {
                id: userImage
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                fillMode: Image.PreserveAspectFit
                source: model.userIconSource ? model.userIconSource :
                                               "image://theme/icon-m-person?" + Theme.highlightColor
            }

            Column {
                id: contentHeader
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: userImage.right
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                }

                Label {
                    width: parent.width
                    color: highlighted ? Theme.highlightColor :
                                         _userComment ? Theme.primaryColor : Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    text: (_userComment ? "<img src='image://theme/icon-s-edit'> " :
                                          _authorComment ? "<img src='image://theme/icon-s-developer'> " : "") +
                          model.userName
                }

                Label {
                    id: createdLabel
                    width: parent.width
                    color: highlighted ? Theme.highlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: Text.WordWrap

                    Component.onCompleted: _setSinceCreated()
                }

                Label {
                    id: replyToLabel
                    width: parent.width
                    color: highlighted ? Theme.highlightColor : Theme.primaryColor
                    visible: model.parentId !== 0
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: Text.WordWrap
                    //: Active label to navigate to the original comment - should be a noun
                    //% "Reply to %0"
                    text: visible ? qsTrId("orn-reply-to").arg(model.parentUserName) : ""

                    MouseArea {
                        anchors.fill: parent
                        onClicked: moveAnimation.moveTo(commentsList.model.findItemRow(model.parentId))
                    }
                }
            }
        }

        Label {
            width: parent.width
            color: Theme.highlightColor
            linkColor: Theme.primaryColor
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            text: model.text
                .replace(/<a([^>]*)>([^<]+)<\/a>/g,
                         '<a$1><font color="%0">$2</font></a>'.arg(Theme.primaryColor))
                .replace(/<pre>([^<]+)<\/pre>/g,
                        '<p style="color:%0;font-family:monospace;font-size:%1px;">$1</p>'
                            .arg(Theme.secondaryColor).arg(Theme.fontSizeTiny))
            onLinkActivated: {
                var match = link.match(/https:\/\/openrepos\.net\/.*#comment-(\d*)/)
                if (match) {
                    var pos = commentsModel.findItemRow(match[1])
                    if (pos !== -1) {
                        moveAnimation.moveTo(pos)
                        return
                    }
                }
                openLink(link)
            }
        }
    }
}
