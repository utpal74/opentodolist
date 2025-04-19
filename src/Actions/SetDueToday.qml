import QtQuick 2.0
import "../Components" as Components
import "../Utils" as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarToday
    text: qsTr("Set Due Today")
    onTriggered: item.dueTo = Utils.DateUtils.today()
    enabled: item && item.dueTo !== undefined
}
