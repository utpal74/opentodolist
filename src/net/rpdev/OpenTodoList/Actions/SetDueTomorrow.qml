import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarToday
    text: qsTr("Set Due Tomorrow")
    onTriggered: complexItem.dueTo = Utils.DateUtils.tomorrow()
    enabled: complexItem && complexItem.dueTo !== undefined
}
