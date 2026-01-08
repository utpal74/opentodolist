import QtQuick 2.10
import QtQuick.Layouts 1.1

import OpenTodoList 1.0 as OTL

import OpenTodoList.Components as Components
import OpenTodoList.Style as C
import OpenTodoList.Utils
import OpenTodoList.Windows

ListView {
    id: root

    property Component headerComponent: null
    property Component footerComponent: null

    property C.Symbol headerIcon: headerItem ? headerItem.headerIcon : null
    property C.Symbol headerIcon2: headerItem ? headerItem.headerIcon2 : null

    property OTL.Library library: null
    property OTL.LibraryItem parentItem: null

    // A function which looks up the library for an item in the list.
    // The default is a function which returns the value of the set library. However, for
    // lists with items from several libraries, this can be set to a function which looks up the
    // library for a particular item.
    property var libraryLookupFunction: function (item, library) {
        return library
    }

    property string symbol: C.Icons.mdiAdd
    property string symbolFont: C.Fonts.iconFont
    property bool headerItemVisible: true
    property bool colorSwatchesVisible: false

    property string symbol2
    property string symbolFont2: C.Fonts.iconFont
    property bool headerItem2Visible: false

    property string title
    property bool allowCreatingNewItems: false
    property string newItemPlaceholderText
    property bool allowReordering: true
    property bool allowSettingDueDate: false
    property var hideDueToLabelForSectionsFunction: null
    property bool showParentItemInformation: false

    property var itemsModel: null

    signal headerButtonClicked
    signal headerButton2Clicked
    signal todoClicked(var todo)
    signal createNewItem(string title, var args)


    /*
     * WA for https://gitlab.com/rpdev/opentodolist/-/issues/391
     * Background: When the list view is empty, changing the header size will somehow
     * reset the overall scroll. To prevent this, we use a dedicated property to hold the real
     * model. Only if it contains at least one item, we will use it. Otherwise, we inject a
     * placeholder model (and delegate) which ensures the view is never really
     * empty.
     *
     * This WA could be removed as soon as https://bugreports.qt.io/browse/QTBUG-89957
     * is fixed.
     */
    model: {
        if (itemsModel.count === 0) {
            return 1
        } else {
            return itemsModel
        }
    }

    header: C.Pane {
        property alias headerIcon: headerIcon
        property alias headerIcon2: headerIcon2
        property alias item: headerComponentLoader.item

        width: parent.width
        height: column.contentHeight

        Column {
            id: column

            width: parent.width

            Loader {
                id: headerComponentLoader
                width: parent.width
                sourceComponent: root.headerComponent
            }

            RowLayout {
                width: parent.width

                Components.Heading {
                    id: headerLabel

                    level: 2
                    Layout.fillWidth: true
                    font.bold: true
                    text: root.title
                }

                Item {
                    visible: !headerIcon2.visible
                    width: headerIcon2.width
                    height: headerIcon2.height
                }

                C.Symbol {
                    id: headerIcon2

                    symbol: root.symbol2
                    onClicked: root.headerButton2Clicked()
                    visible: root.headerItem2Visible
                }

                Item {
                    visible: !headerIcon.visible
                    width: headerIcon.width
                    height: headerIcon.height
                }

                C.Symbol {
                    id: headerIcon

                    symbol: root.symbol
                    onClicked: root.headerButtonClicked()
                    visible: root.headerItemVisible
                }
            }

            DateSelectionDialog {
                id: dateDialog
                onAccepted: newItemRow.dueDate = selectedDate
            }

            GridLayout {
                id: newItemRow

                property var dueDate: new Date("")

                columns: 4
                visible: root.allowCreatingNewItems
                width: parent.width

                Item {
                    width: newItemButton.width
                    height: newItemButton.height
                    Layout.row: 0
                    Layout.column: 0
                }

                C.TextField {
                    id: newItemTitelEdit
                    Layout.fillWidth: true
                    Layout.row: 0
                    Layout.column: 1
                    onAccepted: newItemButton.clicked()
                    placeholderText: root.newItemPlaceholderText
                }

                C.Symbol {
                    symbol: C.Icons.mdiCalendarToday
                    visible: root.allowSettingDueDate
                    Layout.row: 0
                    Layout.column: 2
                    onClicked: {
                        dateDialog.selectedDate = newItemRow.dueDate
                        dateDialog.open()
                    }
                }

                C.Symbol {
                    id: newItemButton
                    symbol: C.Icons.mdiAdd
                    enabled: newItemTitelEdit.displayText !== ""
                    Layout.column: 3
                    Layout.row: 0
                    onClicked: {
                        var title = newItemTitelEdit.displayText
                        if (title !== "") {
                            var args = {}
                            if (DateUtils.validDate(newItemRow.dueDate)) {
                                args.dueTo = newItemRow.dueDate
                                newItemRow.dueDate = new Date("")
                            }
                            root.createNewItem(newItemTitelEdit.displayText,
                                               args)
                            newItemTitelEdit.clear()
                            refocusNewItemEditTimer.restart()
                        }
                    }

                    Timer {
                        id: refocusNewItemEditTimer
                        interval: 1000
                        repeat: false
                        onTriggered: {
                            newItemTitelEdit.forceActiveFocus()
                        }
                    }
                }
            }

            C.Label {
                text: {
                    if (DateUtils.validDate(newItemRow.dueDate)) {
                        return qsTr("Due on: %1").arg(
                                    newItemRow.dueDate.toLocaleDateString())
                    } else {
                        return ""
                    }
                }
                visible: DateUtils.validDate(newItemRow.dueDate)
                Layout.row: 1
                Layout.column: 1
                Layout.columnSpan: 2
                Layout.fillWidth: true
            }

            C.Symbol {
                symbol: C.Icons.mdiClose
                onClicked: newItemRow.dueDate = new Date("")
                visible: DateUtils.validDate(newItemRow.dueDate)
                Layout.row: 1
                Layout.column: 3
            }
        }
    }

    footer: C.Pane {
        width: parent.width
        height: footerColumn.contentHeight

        Column {
            id: footerColumn
            width: parent.width

            Loader {
                width: parent.width
                sourceComponent: root.footerComponent
            }
        }
    }

    delegate: model === 1 ? placeholderDelegate : itemDelegate

    Component {
        id: placeholderDelegate

        Components.Empty {}
    }

    Component {
        id: itemDelegate

        TodosWidgetDelegate {
            id: swipeDelegate

            property int updateCounter: 0

            showParentItemInformation: root.showParentItemInformation
            model: root.model
            item: object
            parentItem: root.parentItem
            library: root.libraryLookupFunction(object, root.library)
            leftColorSwatch.visible: colorSwatchesVisible
            leftColorSwatch.color: library.color
            allowReordering: root.allowReordering
            hideDueDate: typeof (root.hideDueToLabelForSectionsFunction)
                         === "function" ? root.hideDueToLabelForSectionsFunction(
                                              ListView.section) : false
            drawSeperator: {
                let result = updateCounter || true
                // Force re-evaluation of binding
                if (index === root.model.rowCount() - 1) {
                    // Dont draw separator for last item
                    result = false
                } else if (root.section.property !== "") {
                    // Check if this is the last item in the current section.
                    // Don't draw a separator for it in this case
                    let nextItemSection = root.model.data(
                            root.model.index(index + 1, 0),
                            root.model.roleFromName(root.section.property))
                    if (ListView.section !== nextItemSection) {
                        result = false
                    }
                }
                return result
            }

            onItemPressedAndHold: showContextMenu({
                                                      "x": width,
                                                      "y": 0
                                                  })
            onItemClicked: {
                root.todoClicked(item)
            }

            Connections {
                target: root.model

                function onModelReset() {
                    swipeDelegate.updateCounter++
                }

                function onRowsInserted(parent, first, last) {
                    swipeDelegate.updateCounter++
                }

                function onRowsRemoved(parent, first, last) {
                    swipeDelegate.updateCounter++
                }
            }

            function showContextMenu(mouse) {
                itemActionMenu.actions = swipeDelegate.itemActions
                itemActionMenu.parent = swipeDelegate
                itemActionMenu.popup(mouse.x, mouse.y)
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: mouse => showContextMenu(mouse)
            }
        }
    }

    Components.ItemActionMenu {
        id: itemActionMenu
    }
}
