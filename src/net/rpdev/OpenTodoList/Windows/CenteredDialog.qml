import QtQuick 2.10

import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as U

C.Dialog {
    id: dialog

    readonly property int idealDialogWidth: Math.min(
                                                Qt.application.font.pixelSize * 80,
                                                parent.width - Qt.application.font.pixelSize * 5)

    readonly property int idealDialogHeight: Math.min(
                                                 Qt.application.font.pixelSize * 60,
                                                 parent.height - Qt.application.font.pixelSize * 5)

    parent: C.ApplicationWindow.contentItem
    x: (parent.width - width) / 2
    y: Math.max(
           (parent.height - height - U.AppSettings.virtualKeyboardHeight) / 2,
           0)
    modal: true
}
