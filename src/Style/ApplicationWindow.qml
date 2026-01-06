import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.ApplicationWindow {
    id: appWindow

    font.family: Fonts.regularFont
    palette: ColorTheme.selectedPalette
    flags: Qt.Window | Qt.ExpandedClientAreaHint | Qt.NoTitleBarBackgroundHint

    Basic.Overlay.overlay.palette: appWindow.palette
}
