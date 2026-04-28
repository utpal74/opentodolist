import QtQuick
import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

Components.ItemAction {
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiEvent
    text: qsTr("Select Due Date")
    onTriggered: itemUtils.selectDueToDate(item)
    enabled: complexItem && complexItem.dueTo !== undefined
}
