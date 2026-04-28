import QtQuick
import QtQuick.Controls.Basic as Basic

import net.rpdev.OpenTodoList.Utils as Utils

Basic.TextField {
    selectByMouse: Utils.AppSettings.selectTextByMouse
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
}
