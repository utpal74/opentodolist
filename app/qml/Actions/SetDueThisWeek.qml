import QtQuick 2.0
import "../Components" as Components
import "../Utils" as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarViewWeek
    text: qsTr("Set Due Next Week")
    onTriggered: item.dueTo = Utils.DateUtils.endOfNextWeek()
    enabled: item && item.dueTo !== undefined
}
