import QtQuick 2.0
import OpenTodoList 1.0 as OTL
import "../Components" as Components
import "../Utils" as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    property OTL.Library library: null
    required property Utils.ItemUtils itemUtils

    symbol: C.Icons.mdiContentCut
    text: qsTr("Move")
    onTriggered: itemUtils.moveTodo(item, library)
}
