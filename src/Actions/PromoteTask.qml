import QtQuick 2.0
import OpenTodoList 1.0 as OTL
import OpenTodoList.Components as Components
import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    property OTL.Library library: null
    property OTL.TodoList todoList: null
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiUpgrade
    text: qsTr("Promote")
    onTriggered: itemUtils.promoteTask(item, todoList, library)
}
