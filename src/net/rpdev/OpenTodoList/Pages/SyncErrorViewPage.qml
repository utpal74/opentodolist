import QtQuick 2.9
import QtQuick.Layouts 1.3

import net.rpdev.OpenTodoList

import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as Utils

C.Page {
    id: page

    property alias errors: view.model

    ListView {
        id: view

        anchors.fill: parent
        C.ScrollBar.vertical: C.ScrollBar {}

        delegate: RowLayout {
            width: view.width
            spacing: Utils.AppSettings.smallSpace
            C.Symbol {
                symbol: C.Icons.mdiReportProblem
            }
            C.Label {
                Layout.fillWidth: true
                text: modelData
            }
        }
    }
}
