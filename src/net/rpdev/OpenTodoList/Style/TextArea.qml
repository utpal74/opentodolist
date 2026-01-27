import QtQuick
import QtQuick.Controls.Basic as Basic

import net.rpdev.OpenTodoList.Utils as Utils

Basic.TextArea {
    selectByMouse: Utils.AppSettings.selectTextByMouse
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
}
