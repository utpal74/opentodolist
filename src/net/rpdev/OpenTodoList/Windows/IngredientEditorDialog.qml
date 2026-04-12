import QtQuick
import QtQuick.Layouts
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as U

CenteredDialog {
    id: ingredientEditorDialog

    property var ingredient

    signal ingredientEdited(var ingredient)

    function editIngredient(ingredient) {
        ingredientEditorDialog.ingredient = ingredient;
        nameEdit.text = ingredient.name;
        amountEdit.text = ingredient.amount;
        unitEdit.text = ingredient.unit;
        isHeadingEdit.checked = ingredient.isHeading;
        ingredientEditorDialog.open();
        nameEdit.forceActiveFocus();
    }

    standardButtons: C.Dialog.Ok | C.Dialog.Cancel
    title: qsTr("Edit Ingredient")
    width: idealDialogWidth

    Component.onCompleted: {
        let acceptButton = ingredientEditorDialog.standardButton(C.Dialog.Ok);
        acceptButton.enabled = Qt.binding(function () {
            return nameEdit.displayText !== "" && (amountEdit.acceptableInput || amountEdit.text === "" || isHeadingEdit.checked);
        });
    }
    onAccepted: {
        ingredient.name = nameEdit.displayText;
        if (amountEdit.displayText === "") {
            ingredient.amount = 0;
        } else {
            ingredient.amount = parseFloat(amountEdit.displayText);
        }
        ingredient.amount = amountEdit.text;
        ingredient.unit = unitEdit.text;
        ingredient.isHeading = isHeadingEdit.checked;
        ingredientEdited(ingredient);
    }

    Flow {
        spacing: U.AppSettings.mediumSpace
        width: parent.width

        C.TextField {
            id: amountEdit

            placeholderText: qsTr("Amount")
            enabled: !isHeadingEdit.checked
            validator: DoubleValidator {
                notation: DoubleValidator.StandardNotation
            }
        }

        C.TextField {
            id: unitEdit

            placeholderText: qsTr("Unit")
            enabled: !isHeadingEdit.checked
        }

        C.TextField {
            id: nameEdit

            Layout.fillWidth: true
            placeholderText: qsTr("Name")
        }

        C.Switch {
            id: isHeadingEdit

            text: qsTr("Is Heading")
            Layout.columnSpan: 3
        }
    }
}