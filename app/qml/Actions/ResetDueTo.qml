import QtQuick 2.0
import "../Components" as Components
import "../Utils" as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiCalendarToday
    text: qsTr("Reset Due To")
    onTriggered: item.dueTo = new Date("")
    enabled: item && item.dueTo !== undefined
}
