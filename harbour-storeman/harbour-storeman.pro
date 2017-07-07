TARGET = harbour-storeman

VERSION = $$system("echo $(awk -F ':' '/Version/ {print $2}' rpm/$${TARGET}.yaml)")
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

CONFIG += \
    sailfishapp \
    sailfishapp_i18n \
    sailfishapp_i18n_idbased
CONFIG(release, debug|release): DEFINES += QT_NO_DEBUG_OUTPUT

LIBS += -lornplugin -L$$OUT_PWD/../ornplugin
PRE_TARGETDEPS += $$OUT_PWD/../ornplugin/libornplugin.a
INCLUDEPATH += ../ornplugin/src

PKGCONFIG += packagekit-qt5

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

SOURCES += \
    src/harbour-storeman.cpp \
    src/networkaccessmanagerfactory.cpp

HEADERS += \
    src/networkaccessmanagerfactory.h

OTHER_FILES += qml/harbour-storeman.qml \
    qml/cover/CoverPage.qml \
    qml/pages/RecentAppsPage.qml \
    qml/pages/ApplicationPage.qml \
    qml/pages/RepositoriesPage.qml \
    qml/pages/ScreenshotPage.qml \
    qml/pages/ChangelogPage.qml \
    qml/pages/UserPage.qml \
    qml/pages/CommentsPage.qml \
    qml/pages/SearchPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/TranslationsPage.qml \
    qml/pages/DevelopmentPage.qml \
    qml/components/AppListDelegate.qml \
    qml/components/RatingBox.qml \
    qml/components/IconLabel.qml \
    qml/components/FancyPageHeader.qml \
    qml/components/PackageInformation.qml \
    qml/components/AppInformation.qml \
    qml/components/AppInfoLabel.qml \
    qml/components/ScreenshotsBox.qml \
    qml/components/MoreButton.qml \
    qml/components/ApplicationPageMenu.qml \
    qml/components/RefreshMenuItem.qml \
    qml/components/ParticipantsDelegate.qml \
    qml/models/DevelopersModel.qml \
    qml/models/TranslatorsModel.qml \
    rpm/harbour-storeman.changes \
    rpm/harbour-storeman.spec \
    rpm/harbour-storeman.yaml \
    translations/*.ts \
    translations/update_translations.py \
    harbour-storeman.desktop \
    icons/harbour-storeman.svg \
    .gitignore

RESOURCES += \
    harbour-storeman.qrc

TRANSLATIONS += \
    translations/harbour-storeman.ts \
    translations/harbour-storeman-nl.ts \
    translations/harbour-storeman-pl.ts \
    translations/harbour-storeman-ru.ts \
    translations/harbour-storeman-sv.ts

TRANSLATION_SOURCES += $$PWD/../ornplugin/src

polkit.files = rpm/50-harbour-storeman-packagekit.pkla
polkit.path = $$INSTALL_ROOT/var/lib/polkit-1/localauthority/50-local.d

INSTALLS += polkit