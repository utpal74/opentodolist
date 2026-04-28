import QtQuick
import QtQuick.Controls.Basic as Basic

import net.rpdev.OpenTodoList.Utils as Utils

import net.rpdev.OpenTodoList.Style as C

Basic.TextField {
    selectByMouse: Utils.AppSettings.selectTextByMouse
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    echoMode: TextInput.Password
    inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
    rightPadding: leftPadding + echoModeToggle.width

    Symbol {
        id: echoModeToggle

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        symbol: {
            switch (parent.echoMode) {
            case TextInput.Password:
                return C.Icons.mdiVisibility
            default:
                return C.Icons.mdiVisibilityOff
            }
        }
        onClicked: {
            if (parent.echoMode === TextInput.Password) {
                parent.echoMode = TextInput.Normal
            } else {
                parent.echoMode = TextInput.Password
            }
        }
    }
}
