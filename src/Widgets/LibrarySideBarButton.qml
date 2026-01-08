import QtQuick 2.9
import QtQuick.Layouts 1.3

import OpenTodoList.Components
import OpenTodoList.Style as C
import OpenTodoList.Utils as Utils

C.ItemDelegate {
    id: root

    property alias symbol: sym.symbol
    property int indent: 0
    property bool bold: false
    property alias symbolIsClickable: sym.enabled
    property alias rightSymbol: symRight.text
    property alias rightSymbolIsClickable: symRight.enabled
    property alias rightSymbolIsVisible: symRight.visible
    property alias symbolToolButton: sym
    property alias leftColorSwatch: leftColorSwatch

    signal symbolClicked
    signal rightSymbolClicked

    symbol: action?.symbol ?? ""

    width: parent.width
    padding: 6
    contentItem: RowLayout {

        Item {
            width: leftColorSwatch.width
            height: parent.height
        }

        Item {
            height: 1
            width: root.indent * Utils.AppSettings.mediumSpace
        }

        C.Symbol {
            id: sym
            Layout.minimumWidth: root.height / 2
            Layout.alignment: Qt.AlignHCenter
            enabled: false
            onClicked: root.symbolClicked()
        }

        C.Label {
            id: label

            elide: Text.ElideRight
            Layout.fillWidth: true
            text: root.text
            wrapMode: Text.NoWrap
        }

        C.Symbol {
            id: symRight
            Layout.minimumWidth: root.height / 2
            Layout.alignment: Qt.AlignHCenter
            enabled: false
            onClicked: root.rightSymbolClicked()
            visible: false
        }
    }

    Rectangle {
        id: leftColorSwatch

        height: root.height
        width: Utils.AppSettings.smallSpace
        color: "transparent"
    }
}
