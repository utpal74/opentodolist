import OpenTodoList.Components as Components
import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarToday
    text: qsTr("Set Due Today")
    onTriggered: complexItem.dueTo = Utils.DateUtils.today()
    enabled: complexItem && complexItem.dueTo !== undefined
}
