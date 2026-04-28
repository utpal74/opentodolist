import QtQuick 2.0
import QtQuick.Layouts

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Widgets as W

CenteredDialog {
    id: dialog

    property alias text: markdownEditor.text
    property OTL.ComplexItem item

    standardButtons: C.Dialog.Ok | C.Dialog.Cancel
    title: qsTr("Edit Notes")
    width: idealDialogWidth
    height: idealDialogHeight - Utils.AppSettings.virtualKeyboardHeight

    onVisibleChanged: {
        if (visible) {
            markdownEditor.textArea.forceActiveFocus()
        }
    }

    W.MarkdownEditor {
        id: markdownEditor
        anchors.fill: parent
        item: dialog.item
    }
}
