import QtQuick
import QtQuick.Layouts
import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Utils as U
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Windows as W

Column {
    id: ingredientsEditor

    required property OTL.Recipe item
    property OTL.Recipe recipeItem: item

    width: parent.width

    RowLayout {
        spacing: U.AppSettings.mediumSpace
        width: parent.width

        Components.Heading {
            Layout.fillWidth: true
            level: 2
            text: qsTr("Ingredients")
        }

        C.Symbol {
            symbol: C.Icons.mdiAdd

            onClicked: editNewIngredientDialog.editIngredient(ingredientsEditor.item.createIngredient())
        }

        W.IngredientEditorDialog {
            id: editNewIngredientDialog

            onIngredientEdited: {
                ingredientsEditor.item.ingredients.push(ingredient);
            }
        }
    }

    DelegateModel {
        id: ingredientsDelegateModel
        model: ingredientsEditor.item.ingredients
        delegate: IngredientsEditorItem {
            recipe: (parent as IngredientsEditor).item
        }
    }

    Repeater {
        id: ingredientsRepeater

        model: ingredientsEditor.item.ingredients
        delegate: IngredientsEditorItem {
            recipe: (parent as IngredientsEditor).item
        }
    }
}
