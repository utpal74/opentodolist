import QtQuick
import QtQuick.Layouts
import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Utils as U
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Windows as W

Column {
    id: utilitiesEditor

    required property OTL.Recipe item
    property OTL.Recipe recipeItem: item

    width: parent.width

    RowLayout {
        spacing: U.AppSettings.mediumSpace
        width: parent.width

        Components.Heading {
            Layout.fillWidth: true
            level: 2
            text: qsTr("Utilities")
        }

        C.Symbol {
            symbol: C.Icons.mdiAdd

            onClicked: editNewUtilityDialog.editUtility("")
        }

        W.UtilityEditorDialog {
            id: editNewUtilityDialog

            onUtilityEdited: {
                utilitiesEditor.item.utilities.push(utility);
            }
        }
    }

    Repeater {
        id: utilitiesRepeater

        model: utilitiesEditor.item.utilities
        delegate: UtilitiesEditorItem {
            recipe: (parent as UtilitiesEditor).item
        }
    }
}
