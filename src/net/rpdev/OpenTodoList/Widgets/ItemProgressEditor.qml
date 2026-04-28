import QtQuick 2.9
import QtQuick.Layouts 1.3

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils
import net.rpdev.OpenTodoList.Windows

RowLayout {
    id: root

    property OTL.Todo item: null

    QtObject {
        id: d

        property bool isProgressSet: root.item.progress >= 0
    }

    C.Symbol {
        symbol: C.Icons.mdiFactCheck
        font.family: C.Fonts.iconFont
    }

    C.Slider {
        id: slider
        from: 0
        to: 100
        value: root.item.progress
        stepSize: 1
        live: false
        onValueChanged: if (d.isProgressSet) {
                            root.item.progress = value
                        }
        Layout.fillWidth: true
    }

    C.Symbol {
        symbol: C.Icons.mdiDelete
        font.family: C.Fonts.iconFont
        onClicked: {
            slider.value = -1
            root.item.progress = -1
        }
        visible: d.isProgressSet
    }
}
