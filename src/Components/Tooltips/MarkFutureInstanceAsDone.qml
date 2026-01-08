import QtQuick 2.15
import QtQuick.Layouts 1.0

import OpenTodoList.Style as C
import OpenTodoList 1.0 as OTL
import OpenTodoList.Utils as Utils

ActionableToolTip {
    id: tooltip

    property OTL.ComplexItem item: null

    text: qsTr("%1 is scheduled for the future - do you want to mark that future instance as done?").arg(
              "<strong>" + Utils.Markdown.markdownToPlainText(
                  tooltip.item?.title) + "</strong>")
    buttons.contentChildren: [
        C.Button {
            id: yesButton

            text: qsTr("Mark as Done")
            highlighted: true
            onClicked: () => {
                tooltip.item.markCurrentOccurrenceAsDone()
                tooltip.hide()
            }
        },
        C.Button {
            id: noButton
            text: qsTr("Keep Open")
            onClicked: () => tooltip.hide()
        }
    ]
}
