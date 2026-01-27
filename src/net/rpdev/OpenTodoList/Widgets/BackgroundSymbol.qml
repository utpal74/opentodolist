import QtQuick 2.9

import net.rpdev.OpenTodoList.Style as C

C.Label {
    id: root

    property alias symbol: root.text

    anchors.fill: parent
    font.pixelSize: Math.min(width, height) * 0.8
    font.family: C.Fonts.iconFont
    opacity: 0.1
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
}
