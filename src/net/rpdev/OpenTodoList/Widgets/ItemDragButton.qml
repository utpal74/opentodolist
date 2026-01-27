import QtQuick 2.9
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Widgets as Widgets
import net.rpdev.OpenTodoList as OTL

C.Symbol {
    id: moveButton

    readonly property alias dragTile: dragTile
    readonly property alias dragging: dragTile.dragging

    required property OTL.LibraryItem item
    required property var model
    required property var listViewItem

    symbol: C.Icons.mdiDragHandle

    opacity: {
        if (dragTile.dragging) {
            return 1.0
        }
        if (listViewItem.allowReordering) {
            switch (Qt.platform.os) {
            case "ios":
            case "android":
                return 1.0
            default:
                return listViewItem.hovered ? 1.0 : 0.0
            }
        } else {
            return 0.0
        }
    }
    enabled: opacity > 0.1

    ItemDragTile {
        id: dragTile
        anchors.fill: parent
        item: moveButton.item
        model: moveButton.model
    }
}
