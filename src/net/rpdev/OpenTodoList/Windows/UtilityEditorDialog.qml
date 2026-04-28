import QtQuick
import QtQuick.Layouts
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as U

CenteredDialog {
    id: utilityEditorDialog

    property var ingredient

    signal utilityEdited(var utility)

    function editUtility(utility) {
        nameEdit.text = utility;
        utilityEditorDialog.open();
        nameEdit.forceActiveFocus();
    }

    standardButtons: C.Dialog.Ok | C.Dialog.Cancel
    title: qsTr("Edit Utility")
    width: idealDialogWidth

    Component.onCompleted: {
        let acceptButton = utilityEditorDialog.standardButton(C.Dialog.Ok);
        acceptButton.enabled = Qt.binding(function () {
            return nameEdit.displayText !== "";
        });
    }
    onAccepted: {
        utilityEdited(nameEdit.displayText);
    }

    RowLayout {
        spacing: U.AppSettings.mediumSpace
        width: parent.width

        C.TextField {
            id: nameEdit

            Layout.fillWidth: true
            placeholderText: qsTr("Name")
        }
    }
}