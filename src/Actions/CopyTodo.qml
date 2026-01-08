import QtQuick 2.0
import OpenTodoList 1.0 as OTL
import OpenTodoList.Components as Components
import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    property OTL.Library library: null
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiContentCopy
    text: qsTr("Copy")
    onTriggered: itemUtils.copyTodo(item)
}
