import OpenTodoList.Components as Components
import OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiTrackChanges
    text: qsTr("Set Progress")
    onTriggered: todoItem.progress = 0
    enabled: todoItem && todoItem.progress < 0
}
