import QtQuick
import QtQuick.Controls.Basic as Basic

import "../../Utils" as Utils

Basic.TextArea {
    selectByMouse: Utils.AppSettings.selectTextByMouse
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
}
