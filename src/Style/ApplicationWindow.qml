import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.ApplicationWindow {
    id: appWindow

    font.family: Fonts.regularFont
    palette: ColorTheme.selectedPalette
    flags: {
        let f = Qt.Window | Qt.ExpandedClientAreaHint;
        if (Qt.platform.os === "ios" || Qt.platform.os === "android") {
            f = f | Qt.NoTitleBarBackgroundHint;
        }
        return f;
    }

    Basic.Overlay.overlay.palette: appWindow.palette
}
