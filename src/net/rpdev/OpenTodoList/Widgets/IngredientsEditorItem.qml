import QtQuick
import QtQuick.Layouts

import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as U
import net.rpdev.OpenTodoList.Windows as W

MouseArea {
    id: ingredientsEditorItem

    required property int amount
    //property Column container: parent as Column
    property bool held: false
    required property var index
    required property var modelData
    required property string name
    required property bool isHeading
    property OTL.Recipe recipe
    required property string unit

    signal dropped(index: int)

    function finishDrag() {
        if (!held) {
            return;
        }

        // Calculate the new index based on the drag position
        let delegateTopLeft = itemDelegate.mapToGlobal(0, 0);
        var newIndex = -1;

        let index = -1;
        for (let i in parent.children) {
            let child = parent.children[i];
            if (!(child instanceof IngredientsEditorItem)) {
                continue;
            }
            ++index;
            let childTopLeft = child.mapToGlobal(0, 0);
            let delegateMid = delegateTopLeft.y + itemDelegate.height / 2;
            if (delegateMid < (childTopLeft.y + child.height) && (delegateMid > childTopLeft.y)) {
                newIndex = index;
                break;
            }
        }
        if (newIndex !== -1 && newIndex !== ingredientsEditorItem.index) {
            let ingredient = ingredientsEditorItem.recipe.ingredients[ingredientsEditorItem.index];
            // Note: If the new index is smaller than the old one, the following moves the
            // item before the item we dropped on. Contrary, if the new index is bigger,
            // due to we don't adjust the new index after removing the item, it will be moved
            // after the item we dropped on. This is one would most likely expect.
            ingredientsEditorItem.recipe.ingredients.splice(ingredientsEditorItem.index, 1);
            ingredientsEditorItem.recipe.ingredients.splice(newIndex, 0, ingredient);
        }
        held = false;
    }

    acceptedButtons: U.AppSettings.desktopMode ? Qt.LeftButton : Qt.NoButton
    drag.axis: Drag.YAxis
    drag.filterChildren: U.AppSettings.desktopMode
    drag.target: U.AppSettings.desktopMode && held ? itemDelegate : undefined
    height: itemDelegate.height
    width: parent.width

    onPressAndHold: if (U.AppSettings.desktopMode) {
        held = true
    }
    onReleased: finishDrag()

    C.ItemDelegateSeparator {
        visible: ingredientsEditorItem.index > 0 && !ingredientsEditorItem.isHeading && !ingredientsEditorItem.recipe.ingredients[ingredientsEditorItem.index - 1].isHeading
    }

    C.ItemDelegate {
        id: itemDelegate

        anchors.top: ingredientsEditorItem.held ? undefined : parent.top
        leftPadding: ingredientsEditorItem.isHeading ? 0 : U.AppSettings.smallSpace
        width: parent.width

        RowLayout {
            anchors.fill: parent
            spacing: U.AppSettings.smallSpace

            Item {
                Layout.preferredWidth: itemDelegate.leftPadding
            }

            C.Label {
                id: nameLabel

                Layout.fillWidth: true
                text: {
                    if (ingredientsEditorItem.amount > 0 && !ingredientsEditorItem.isHeading) {
                        return ingredientsEditorItem.amount + " " + ingredientsEditorItem.unit + " " + ingredientsEditorItem.name;
                    } else {
                        return ingredientsEditorItem.name;
                    }
                }
                font.bold: ingredientsEditorItem.isHeading

                Binding {
                    target: nameLabel
                    property: "font.family"
                    value: C.Fonts.titleFont
                    when: ingredientsEditorItem.isHeading
                }

            }

            C.Symbol {
                symbol: C.Icons.mdiDragHandle
                visible: !U.AppSettings.desktopMode

                MouseArea {
                    anchors.fill: parent
                    drag.axis: Drag.YAxis
                    drag.target: ingredientsEditorItem.held ? itemDelegate : undefined
                    preventStealing: true

                    onPressed: ingredientsEditorItem.held = true
                    onReleased: ingredientsEditorItem.finishDrag()
                    onCanceled: ingredientsEditorItem.held = false
                }
            }

            C.Symbol {
                symbol: C.Icons.mdiMoreVert

                menu: C.Menu {
                    modal: true

                    C.MenuItem {
                        text: qsTr("Edit")

                        onTriggered: {
                            editExistingIngredientDialog.editIngredient(ingredientsEditorItem.modelData);
                        }

                        W.IngredientEditorDialog {
                            id: editExistingIngredientDialog

                            onIngredientEdited: {
                                ingredientsEditorItem.recipe.ingredients[ingredientsEditorItem.index] = ingredient;
                            }
                        }
                    }

                    C.MenuItem {
                        text: qsTr("Delete")

                        onTriggered: {
                            deleteIngredientDialog.visible = true;
                        }

                        W.MessageDialog {
                            id: deleteIngredientDialog

                            buttons: W.MessageDialog.Yes | W.MessageDialog.No
                            text: qsTr("Are you sure you want to delete this ingredient?")
                            title: qsTr("Delete Ingredient")

                            onAccepted: {
                                ingredientsEditorItem.recipe.ingredients.splice(ingredientsEditorItem.index, 1);
                            }
                        }
                    }
                }
            }
        }
    }
}
