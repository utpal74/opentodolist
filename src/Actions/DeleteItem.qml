import QtQuick 2.0
import OpenTodoList.Components as Components
import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiDelete
    text: qsTr("Delete")
    onTriggered: itemUtils.deleteItem(item)
}
