import QtQuick 2.0
import QtQuick.Layouts 1.1

import OpenTodoList 1.0 as OTL

import OpenTodoList.Components
import OpenTodoList.Style as C
import OpenTodoList.Utils

MouseArea {
    id: item

    property OTL.Library library: null
    property OTL.Note libraryItem: OTL.Note {}
    property var model
    property bool allowReordering: true
    property ItemDragTile dragTile

    readonly property bool hovered: containsMouse

    hoverEnabled: true
    GridView.delayRemove: moveButton.dragging
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button === Qt.LeftButton) {
                item.clicked()
            }
        }
        onReleased: item.released(mouse)
    }

    ItemPane {
        id: pane

        anchors.fill: parent
        anchors.margins: AppSettings.smallSpace
        item: item.libraryItem
        padding: 0

        ItemPane {
            id: title

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            height: titleLabel.height + padding * 2
            item: item.libraryItem
            shade: midShade
            clip: true
            hoverEnabled: true

            C.Label {
                id: titleLabel
                text: Markdown.markdownToPlainText(item.libraryItem.title)
                textFormat: Text.PlainText
                wrapMode: Text.NoWrap
                minimumPointSize: 6
                elide: Text.ElideRight
                width: parent.width - moveButton.width
                fontSizeMode: Text.HorizontalFit
                color: title.textColor

                C.ToolTip {
                    text: titleLabel.truncated ? text : ""
                }
            }
        }

        ItemPane {
            id: contentPane

            anchors {
                left: parent.left
                right: parent.right
                top: title.bottom
                bottom: parent.bottom
            }
            item: item.libraryItem

            C.Label {
                id: dueToLabel
                text: {
                    let dueTo = item.libraryItem.effectiveDueTo
                    if (DateUtils.validDate(dueTo)) {
                        return qsTr("Due on %1").arg(DateUtils.format(dueTo))
                    }
                    return ""
                }
                visible: text !== ""
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                opacity: 0.5
                color: contentPane.textColor
            }

            C.Label {
                anchors.fill: parent
                anchors.topMargin: {
                    if (dueToLabel.visible) {
                        dueToLabel.height + AppSettings.smallSpace
                    } else {
                        return 0
                    }
                }
                text: Markdown.markdownToHtml(item.libraryItem.notes, palette,
                                              contentPane.textColor)
                textFormat: Text.RichText
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                clip: true
                color: contentPane.textColor
            }
        }

        MouseArea {
            anchors.fill: parent

            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: mouse => item.clicked(mouse)
        }

        ItemDragButton {
            id: moveButton

            item: item.libraryItem
            model: item.model
            listViewItem: item
            anchors.verticalCenter: title.verticalCenter
            anchors.right: title.right
            textColor: title.textColor
        }
    }

    C.DropShadow {
        target: pane
    }
    ReorderableListViewOverlay {
        id: reorderOverlay
        anchors.fill: parent
        model: item.model
        layout: Qt.Horizontal
        item: libraryItem
        dragTile: moveButton.dragTile
    }
}
