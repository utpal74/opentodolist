import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.ToolBar {
    Component.onCompleted: palette.text = Qt.binding(function() {
        return ColorTheme.textColorForBackgroundColor(palette.button);
    })
}
