import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarToday
    text: qsTr("Reset Due To")
    onTriggered: complexItem.dueTo = new Date("")
    enabled: complexItem && complexItem.dueTo !== undefined
}
