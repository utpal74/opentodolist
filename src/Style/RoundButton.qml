import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.RoundButton {
    id: button

    property alias symbol: button.text

    font.family: Fonts.iconFont
    font.pixelSize: height / 2
    width: 56
    height: width
}
