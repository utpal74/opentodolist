import OpenTodoList.Components as Components
import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarViewWeek
    text: qsTr("Set Due Next Week")
    onTriggered: complexItem.dueTo = Utils.DateUtils.endOfNextWeek()
    enabled: complexItem && complexItem.dueTo !== undefined
}
