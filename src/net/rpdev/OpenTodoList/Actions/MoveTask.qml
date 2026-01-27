import QtQuick 2.0
import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

Components.ItemAction {
    property OTL.Library library: null
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiContentCut
    text: qsTr("Move")
    onTriggered: itemUtils.moveTask(item, library)
}
