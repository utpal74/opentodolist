import QtQuick 2.0
import QtQuick 2.0 as Quick
import QtQuick.Layouts 1.1

import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Style as C

import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Utils

MouseArea {
    id: item

    property OTL.Library library: null
    property OTL.Image libraryItem: OTL.Image {}
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

        Quick.Image {
            source: item.libraryItem.imageUrl
            anchors.fill: parent
            fillMode: Quick.Image.PreserveAspectFit
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
