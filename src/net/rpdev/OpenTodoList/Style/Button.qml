import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.Button {
    ToolTip.visible: StyleSettings.useDesktopMode && hovered
                     && ToolTip.text !== ""
}
