import QtQuick 2.0

import OpenTodoList.Style as C
import OpenTodoList.Components as Components

C.Menu {
    property alias actions: repeater.model

    modal: true

    Repeater {
        id: repeater

        delegate: C.MenuItem {
            action: modelData
            visible: enabled
            height: visible ? implicitHeight : 0
        }
    }
}
