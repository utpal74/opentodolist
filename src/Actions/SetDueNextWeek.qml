import OpenTodoList.Components as Components
import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarViewWeek
    text: qsTr("Set Due This Week")
    onTriggered: complexItem.dueTo = Utils.DateUtils.endOfThisWeek()
    enabled: complexItem && complexItem.dueTo !== undefined
}
