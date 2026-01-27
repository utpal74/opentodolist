import QtQuick 2.0
import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

Components.ItemAction {
    property OTL.Library library: null
    property OTL.TodoList todoList: null
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiUpgrade
    text: qsTr("Promote")
    onTriggered: itemUtils.promoteTask(item, todoList, library)
}
