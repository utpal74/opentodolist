import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarToday
    text: qsTr("Set Due Today")
    onTriggered: complexItem.dueTo = Utils.DateUtils.today()
    enabled: complexItem && complexItem.dueTo !== undefined
}
