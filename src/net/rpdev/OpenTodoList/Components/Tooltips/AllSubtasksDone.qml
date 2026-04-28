import QtQuick 2.15
import QtQuick.Layouts 1.0

import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Utils as Utils

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
            let item = tooltip.item
            if (item.numTodos === item.numDoneTodos
                    && item.canBeMarkedAsDone()) {
                tooltip.visible = true
            }
        }
    }
}
