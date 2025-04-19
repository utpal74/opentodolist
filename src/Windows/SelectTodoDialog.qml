import QtQuick 2.0
import QtQuick.Layouts 1.0

import OpenTodoList 1.0 as OTL

import "../Components"
import OpenTodoList.Style as C
import "."

CenteredDialog {
    id: root

    property OTL.Library library: null
    readonly property alias selectedTodo: comboBox.currentValue
    property var excludeTodos: []

    function clear() {
        todoListBox.currentIndex = -1
        comboBox.currentIndex = -1
    }

    title: qsTr("Select Todo")
    modal: true
    width: idealDialogWidth

    footer: C.DialogButtonBox {
        id: buttons

        standardButtons: C.DialogButtonBox.Ok | C.DialogButtonBox.Cancel
        Component.onCompleted: d.okButton = buttons.standardButton(
                                   C.DialogButtonBox.Ok)
    }

    QtObject {
        id: d

        property var okButton: null
    }

    Column {
        C.Label {
            text: qsTr("Todo List:")
        }

        C.ComboBox {
            id: todoListBox

            editable: false
            textRole: "title"
            valueRole: "object"
            width: root.availableWidth
            model: OTL.ItemsSortFilterModel {
                id: todoListsModel
                sortRole: OTL.ItemsModel.TitleRole
                sourceModel: OTL.ItemsModel {
                    cache: OTL.Application.cache
                    itemType: "TodoList"
                    parentItem: root.library?.uid ?? ""
                }
            }
        }

        C.Label {
            text: qsTr("Todo:")
        }

        C.ComboBox {
            id: comboBox

            editable: false
            textRole: "title"
            valueRole: "object"
            width: root.availableWidth
            model: OTL.ItemsSortFilterModel {
                id: model
                sortRole: OTL.ItemsModel.TitleRole
                sourceModel: OTL.ItemsModel {
                    cache: OTL.Application.cache
                    itemType: "Todo"
                    itemsToExclude: root.excludeTodos
                    parentItem: todoListBox.currentValue?.uid ?? ""
                }
            }
        }
    }

    Binding {
        target: d.okButton
        property: "enabled"
        value: comboBox.currentIndex >= 0
    }
}
