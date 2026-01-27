import QtQuick 2.9
import QtQuick.Layouts 1.3

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Style as C

C.Pane {
    id: root

    readonly property var syncErrors: {
        if (library) {
            return OTL.Application.syncErrors[library.directory] || []
        } else {
            return []
        }
    }

    property bool shown: syncErrors.length > 0
    property OTL.Library library: null

    signal showErrors

    // palette.window: palette.accent
    // palette.text: C.ColorTheme.textColorForBackgroundColor(palette.window)
    anchors {
        left: parent.left
        right: parent.right
    }
    y: shown ? parent.height - height : parent.height

    RowLayout {
        id: layout
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
        }

        C.Label {
            text: qsTr("There were errors when synchronizing the library. "
                       + "Please ensure that the library settings are up to date.")
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
        C.Button {
            text: qsTr("Ignore")
            onClicked: OTL.Application.clearSyncErrors(root.library)
        }
        C.Button {
            text: qsTr("View")
            onClicked: root.showErrors()
        }
    }
}
