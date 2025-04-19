import QtQuick 2.0
import QtQuick.Layouts 1.1

import OpenTodoList 1.0 as OTL
import OpenTodoList.Style as C

import "../Components" as Components
import "../Utils"

MouseArea {
    id: item

    property OTL.Library library: null
    property OTL.ImageItem libraryItem: OTL.ImageItem {}
    property var model
    property bool allowReordering: true

    readonly property bool hovered: containsMouse

    hoverEnabled: true
    GridView.delayRemove: moveButton.dragging
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    ItemPane {
        id: pane

        anchors.fill: parent
        anchors.margins: AppSettings.smallSpace
        item: item.libraryItem

        Image {
            source: item.libraryItem.imageUrl
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
    }

    C.DropShadow {
        target: pane
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => item.clicked(mouse)
    }

    ReorderableListViewOverlay {
        id: reorderOverlay
        anchors.fill: parent
        model: item.model
        layout: Qt.Horizontal
        item: libraryItem
        dragTile: moveButton.dragTile
    }

    ItemDragButton {
        id: moveButton

        item: item.libraryItem
        model: item.model
        listViewItem: item
        anchors {
            right: parent.right
            top: parent.top
            margins: AppSettings.smallSpace
        }
        textColor: pane.textColor
    }
}
