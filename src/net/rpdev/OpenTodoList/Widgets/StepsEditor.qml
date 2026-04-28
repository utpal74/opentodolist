import QtQuick
import QtQuick.Layouts
import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Utils as U
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Windows as W

Column {
    id: stepsEditor

    required property OTL.Recipe item
    property OTL.Recipe recipeItem: item

    width: parent.width

    RowLayout {
        spacing: U.AppSettings.mediumSpace
        width: parent.width

        Components.Heading {
            Layout.fillWidth: true
            level: 2
            text: qsTr("Steps")
        }

        C.Symbol {
            symbol: C.Icons.mdiAdd

            onClicked: {
                editNewStepDialog.item = stepsEditor.item;
                editNewStepDialog.text = "";
                editNewStepDialog.visible = true;
            }
        }

        W.MarkdownEditorDialog {
            id: editNewStepDialog

            onAccepted: {
                let step = stepsEditor.item.createStep();
                step.description = editNewStepDialog.text;
                stepsEditor.item.steps.push(step);
            }
        }
    }

    Repeater {
        id: stepsRepeater

        model: stepsEditor.item.steps
        delegate: StepsEditorItem {
            recipe: (parent as StepsEditor).item
        }
    }
}
