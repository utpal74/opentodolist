import QtQuick 2.0
import QtQuick.Layouts

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as Utils

CenteredDialog {
    id: dialog

    property OTL.Recipe recipe

    function editYield(recipe) {
        dialog.recipe = recipe;
        yieldCountEdit.value = recipe.yieldCount;
        yieldUnitEdit.editText = recipe.yieldUnit;
        dialog.open();
        yieldCountEdit.forceActiveFocus();
    }

    standardButtons: C.Dialog.Ok | C.Dialog.Cancel
    title: qsTr("Edit Yield")
    width: idealDialogWidth

    onAccepted: {
        if (yieldCountEdit.value !== undefined) {
            recipe.yieldCount = yieldCountEdit.value;
        } else {
            recipe.yieldCount = 0;
        }
        recipe.yieldUnit = yieldUnitEdit.editText;
    }

    RowLayout {
        spacing: Utils.AppSettings.mediumSpace
        width: parent.width

        C.SpinBox {
            id: yieldCountEdit
            editable: true
            from: 1
            to: 1000000
            Layout.fillWidth: true
        }

        C.ComboBox {
            id: yieldUnitEdit
            model: ["", qsTr("servings"), qsTr("pieces")]
            editable: true
            Layout.fillWidth: true
        }
    }
}
