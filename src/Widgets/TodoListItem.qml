import QtQuick 2.0
import QtQuick.Layouts 1.1

import OpenTodoList 1.0 as OTL

import "../Components"
import OpenTodoList.Style as C
import "../Utils"

MouseArea {
    id: item

    property OTL.Library library: null
    property OTL.TodoList libraryItem: OTL.TodoList {}
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
                width: title.availableWidth - moveButton.width
                fontSizeMode: Text.HorizontalFit
                color: title.textColor

                C.ToolTip.text: titleLabel.truncated ? title.text : ""
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
                opacity: 0.5
                color: contentPane.textColor
            }

            ListView {
                id: openTodosList

                y: {
                    if (dueToLabel.visible) {
                        dueToLabel.height + AppSettings.smallSpace
                    } else {
                        return 0
                    }
                }
                width: parent.width
                height: parent.height - y
                spacing: AppSettings.smallSpace
                interactive: false
                clip: true
                model: OTL.ItemsSortFilterModel {
                    sortRole: item.C.ApplicationWindow.window?.itemUtils.todosSortRoleFromString(
                                  AppSettings.todoListPageSettings.sortTodosBy)
                              ?? OTL.ItemsModel.TitleRole
                    sourceModel: OTL.ItemsModel {
                        cache: OTL.Application.cache
                        parentItem: item.libraryItem.uid
                        onlyUndone: true
                    }
                }
                delegate: RowLayout {
                    width: openTodosList.width
                    C.Label {
                        font.family: C.Fonts.iconFont
                        text: C.Icons.mdiCircle
                        color: contentPane.textColor
                    }
                    C.Label {
                        text: Markdown.markdownToHtml(object.title, palette,
                                                      contentPane.textColor)
                        textFormat: Text.RichText
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        wrapMode: Text.NoWrap
                        color: contentPane.textColor
                    }
                }
            }

            C.Label {
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("✔ No open todos - everything done")
                visible: openTodosList.count === 0
                opacity: 0.5
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
