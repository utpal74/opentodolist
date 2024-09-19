import QtQuick 2.15
import QtQuick.Layouts 1.0

import "../../Controls" as C
import OpenTodoList 1.0 as OTL
import "../../Utils" as Utils

ActionableToolTip {
    id: tooltip

    property OTL.ComplexItem item: null

    text: qsTr("Everything in %1 done! Do you want to mark it as well as done?").arg(
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

    Connections {
        target: tooltip.item

        function onNumDoneTodosChanged() {
            console.log("!!")
            let item = tooltip.item
            console.log(item, item?.numTodos, item?.numDoneTodos,
                        item?.canBeMarkedAsDone())
            if (item.numTodos === item.numDoneTodos
                    && item.canBeMarkedAsDone()) {
                console.log("!!!")
                tooltip.visible = true
            }
        }
    }
}
