import QtQuick
import net.rpdev.OpenTodoList.Utils as U

Rectangle {
    anchors.left: parent.left
    anchors.leftMargin: U.AppSettings.mediumSpace
    anchors.right: parent.right
    anchors.rightMargin: U.AppSettings.mediumSpace
    anchors.top: parent.top
    height: 1
    opacity: visible > 0 ? 0.2 : 0
    color: palette.text
}
