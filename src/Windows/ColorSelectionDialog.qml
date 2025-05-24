import QtQuick 2.9

import OpenTodoList.Components
import OpenTodoList.Style as C
import OpenTodoList.Utils

import OpenTodoList 1.0 as OTL

CenteredDialog {
    id: dialog

    property var selectedColor

    width: idealDialogWidth
    height: idealDialogHeight
    standardButtons: C.Dialog.Ok | C.Dialog.Cancel | C.Dialog.Reset
    onReset: dialog.selectedColor = undefined

    header: C.ToolBar {
        background: Rectangle {
            color: dialog.selectedColor || "transparent"
            height: 10
        }
    }

    ListView {
        id: listView
        width: dialog.availableWidth
        height: dialog.availableHeight
        clip: true
        C.ScrollIndicator.vertical: C.ScrollIndicator {}
        model: OTL.Colors.loadColors()
        delegate: C.CheckDelegate {
            id: control
            text: modelData.name
            checked: dialog.selectedColor === modelData.color
            width: listView.width
            background: Rectangle {
                color: modelData.color
            }
            contentItem: C.Label {
                text: control.text
                color: C.ColorTheme.textColorForBackgroundColor(modelData.color)
            }
            onClicked: dialog.selectedColor = modelData.color
        }
    }
}
