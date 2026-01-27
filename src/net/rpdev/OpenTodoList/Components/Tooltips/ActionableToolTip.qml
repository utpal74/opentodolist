import QtQuick
import QtQuick.Layouts
import net.rpdev.OpenTodoList.Style as C

C.ToolTip {
    id: toolTip

    property alias label: label
    property alias buttons: buttons

    delay: 100
    timeout: 10000
    height: 2 * buttons.implicitHeight
    width: Math.min(d.maximumTooltipWidth,
                    label.implicitWidth + buttons.implicitWidth + spacing)
    x: (parent.width - width) / 2
    y: parent.height - height * 1.5
    visible: false

    contentItem: GridLayout {

        height: toolTip.availableHeight
        width: toolTip.availableWidth
        columns: buttons.width > d.maximumTooltipWidth * 0.5 ? 1 : 2

        C.Label {
            id: label

            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: tooltip.text
            elide: Qt.ElideMiddle
            Layout.fillWidth: true
            Layout.maximumHeight: buttons.implicitHeight
        }

        C.DialogButtonBox {
            id: buttons

            Layout.alignment: Qt.AlignRight

            background: Item {}
        }
    }

    QtObject {
        id: d

        readonly property int maximumTooltipWidth: Math.min(
                                                       tooltip.parent.width * 0.9,
                                                       600)
    }
}
