import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarViewWeek
    text: qsTr("Set Due This Week")
    onTriggered: complexItem.dueTo = Utils.DateUtils.endOfThisWeek()
    enabled: complexItem && complexItem.dueTo !== undefined
}
