import QtQuick 2.9
import QtQuick.Layouts 1.3

import OpenTodoList 1.0

import "../Components"
import OpenTodoList.Style as C
import "../Utils" as Utils

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
