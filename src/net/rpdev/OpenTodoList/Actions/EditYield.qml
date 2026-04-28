import QtQuick 2.0
import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

Components.ItemAction {
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiDriveFileRenameOutline
    text: qsTr("Edit Yield")
    onTriggered: itemUtils.editYield(item)
}
