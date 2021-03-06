import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.orn 1.0
import "../components"

Page {
    allowedOrientations: defaultAllowedOrientations

    Connections {
        target: networkManager
        onStateChanged: {
            if (categoriesList.count === 0 &&
                networkManager.online) {
                categoriesModel.reset()
            }
        }
    }

    SilicaListView {
        id: categoriesList
        anchors.fill: parent

        header: PageHeader {
            //% "Categories"
            title: qsTrId("orn-categories")
        }

        model: OrnCategoriesModel {
            id: categoriesModel
        }

        delegate: MoreButton {
            height: Theme.itemSizeExtraSmall
            text: model.name
            depth: model.depth
            textAlignment: Text.AlignLeft

            onClicked: pageStack.push(Qt.resolvedUrl("CategoryPage.qml"), {
                                          categoryId: model.categoryId,
                                          categoryName: model.name
                                      })
        }

        VerticalScrollDecorator { }

        BusyIndicator {
            size: BusyIndicatorSize.Large
            anchors.centerIn: parent
            running: !viewPlaceholder.text &&
                     categoriesList.count === 0
        }

        ViewPlaceholder {
            id: viewPlaceholder
            enabled: text
            text: networkManager.online ? "" : qsTrId("orn-network-idle")
        }
    }
}
