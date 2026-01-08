import QtQuick 2.10

import OpenTodoList.Style as C
import OpenTodoList.Utils as Utils

C.RoundButton {
    id: newItemButton

    signal newItem

    anchors {
        right: parent.right
        bottom: parent.bottom
        margins: Utils.AppSettings.mediumSpace
    }
    symbol: C.Icons.mdiAdd
    onClicked: newItemButton.newItem()
}
