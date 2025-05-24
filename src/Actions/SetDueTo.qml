import QtQuick
import OpenTodoList.Components as Components
import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiEvent
    text: qsTr("Select Due Date")
    onTriggered: itemUtils.selectDueToDate(item)
    enabled: complexItem && complexItem.dueTo !== undefined
}
