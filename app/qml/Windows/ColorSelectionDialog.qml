import QtQuick 2.9

import "../Components"
import OpenTodoList.Style as C
import "../Utils"

import OpenTodoList 1.0 as OTL

CenteredDialog {
    id: dialog

    property var selectedColor

    implicitWidth: C.ApplicationWindow.contentItem.width * 0.9
    implicitHeight: C.ApplicationWindow.contentItem.height * 0.9
    standardButtons: C.Dialog.Ok | C.Dialog.Cancel | C.Dialog.Reset
    onReset: dialog.selectedColor = undefined

    header: C.ToolBar {
        background: Rectangle {
            color: dialog.selectedColor || "transparent"
            height: 10
        }
    }

    Flickable {
        id: flickable
        width: dialog.availableWidth
        height: dialog.availableHeight
        clip: true
        contentHeight: colorFlow.height + 50

        C.ScrollIndicator.vertical: C.ScrollIndicator {}

        Flow {
            id: colorFlow

            width: flickable.width
            spacing: AppSettings.mediumSpace

            Repeater {
                model: OTL.Colors.loadColors()
                delegate: C.Button {
                    // palette.button: modelData.color
                    //palette.buttonText: C.ColorTheme.textColorForBackgroundColor(
                    //                        palette.button)
                    font.bold: dialog.selectedColor === modelData.color

                    text: modelData.name
                    onClicked: dialog.selectedColor = modelData.color
                }
            }
        }
    }
}
