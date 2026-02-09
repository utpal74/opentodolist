import QtQuick
import QtQuick.Controls.Basic as Basic
import net.rpdev.OpenTodoList.Style as C

Basic.ToolBar {
    id: toolBar
    palette: C.ColorTheme.getButtonPalette(C.ColorTheme.selectedPalette, parent)
}
