import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.ToolButton {
    id: button

    property string symbol
    property Menu menu: null
    property var textColor: null

    onClicked: if (menu) {
                   menu.open()
               }

    QtObject {
        id: d

        readonly property color backgroundColor: {
            if (button.flat) {
                return button.palette.window
            } else if (button.highlighted) {
                if (button.down || button.checked) {
                    return Qt.darker(button.palette.accent)
                } else {
                    return button.palette.accent
                }
            } else if (button.checked || button.down) {
                return button.palette.mid
            } else {
                return button.palette.button
            }
        }

        readonly property color foregroundColor: {
            if (button.textColor !== null) {
                return Qt.darker(button.textColor, 1.0)
            } else {
                return ColorTheme.textColorForBackgroundColor(backgroundColor)
            }
        }
    }

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 40
        radius: height
        opacity: button.flat ? 0.0 : 1.0

        color: d.backgroundColor
    }
    contentItem: Item {
        implicitWidth: row.childrenRect.width
        implicitHeight: row.childrenRect.height

        Row {
            id: row

            spacing: button.spacing
            layoutDirection: button.mirrored ? Qt.RightToLeft : Qt.LeftToRight
            anchors.centerIn: parent

            Label {
                font.family: Fonts.iconFont
                font.pointSize: button.font.pointSize * 1.7
                text: button.symbol
                color: d.foregroundColor
                anchors.verticalCenter: parent.verticalCenter
                visible: button.symbol !== ""
            }

            Label {
                text: button.text
                color: d.foregroundColor
                anchors.verticalCenter: parent.verticalCenter
                visible: button.text !== ""
            }
        }
    }
    ToolTip.visible: StyleSettings.useDesktopMode && hovered
                     && ToolTip.text !== ""
}
