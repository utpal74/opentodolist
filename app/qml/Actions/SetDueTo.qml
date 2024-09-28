import QtQuick 2.0
import "../Components" as Components
import "../Utils" as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiEvent
    text: qsTr("Select Due Date")
    onTriggered: itemUtils.selectDueToDate(item)
    enabled: item && item.dueTo !== undefined
}
