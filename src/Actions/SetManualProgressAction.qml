import QtQuick 2.0
import "../Components" as Components
import "../Utils" as Utils
import OpenTodoList.Style as C

Components.ItemAction {
    symbol: C.Icons.mdiTrackChanges
    text: qsTr("Set Progress")
    onTriggered: item.progress = 0
    enabled: item && item.progress < 0
}
