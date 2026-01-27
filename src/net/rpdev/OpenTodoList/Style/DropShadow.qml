import QtQuick
import QtQuick.Effects

MultiEffect {
    property var target

    source: target
    anchors.fill: target
    shadowBlur: 0.5
    shadowEnabled: true
    shadowColor: palette.shadow
    shadowVerticalOffset: 1
    shadowHorizontalOffset: 1
}
