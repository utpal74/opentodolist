import QtQuick
import QtQuick.Layouts

import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as U
import net.rpdev.OpenTodoList.Windows as W

MouseArea {
    id: utilitiesEditorItem

    property bool held: false
    required property var index
    required property var modelData
    property OTL.Recipe recipe

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
            if (!(child instanceof UtilitiesEditorItem)) {
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
        if (newIndex !== -1 && newIndex !== utilitiesEditorItem.index) {
            let utility = utilitiesEditorItem.recipe.utilities[utilitiesEditorItem.index];
            // Note: If the new index is smaller than the old one, the following moves the
            // item before the item we dropped on. Contrary, if the new index is bigger,
            // due to we don't adjust the new index after removing the item, it will be moved
            // after the item we dropped on. This is one would most likely expect.
            utilitiesEditorItem.recipe.utilities.splice(utilitiesEditorItem.index, 1);
            utilitiesEditorItem.recipe.utilities.splice(newIndex, 0, utility);
        }
        held = false
    }

    acceptedButtons: U.AppSettings.desktopMode ? Qt.LeftButton : Qt.NoButton
    drag.axis: Drag.YAxis
    drag.target: U.AppSettings.desktopMode && held ? itemDelegate : undefined
    height: itemDelegate.height
    width: parent.width
    drag.filterChildren: U.AppSettings.desktopMode

    onPressAndHold: if (U.AppSettings.desktopMode) {
        held = true
    }
    onReleased: finishDrag()

    C.ItemDelegateSeparator {
        visible: utilitiesEditorItem.index > 0
    }

    C.ItemDelegate {
        id: itemDelegate

        width: parent.width
        anchors.top: utilitiesEditorItem.held ? undefined : parent.top
        leftPadding: U.AppSettings.smallSpace

        RowLayout {
            anchors.fill: parent
            spacing: U.AppSettings.smallSpace

            Item {
                width: itemDelegate.leftPadding
                height: 1
            }

            C.Label {
                Layout.fillWidth: true
                text: utilitiesEditorItem.modelData
            }

            C.Symbol {
                symbol: C.Icons.mdiDragHandle
                visible: !U.AppSettings.desktopMode

                MouseArea {
                    anchors.fill: parent
                    drag.axis: Drag.YAxis
                    drag.target: utilitiesEditorItem.held ? itemDelegate : undefined
                    preventStealing: true

                    onPressed: utilitiesEditorItem.held = true
                    onReleased: utilitiesEditorItem.finishDrag()
                    onCanceled: utilitiesEditorItem.held = false
                }
            }

            C.Symbol {
                symbol: C.Icons.mdiMoreVert

                menu: C.Menu {
                    modal: true

                    C.MenuItem {
                        text: qsTr("Edit")

                        onTriggered: {
                            editExistingUtilityDialog.editUtility(utilitiesEditorItem.modelData);
                        }

                        W.UtilityEditorDialog {
                            id: editExistingUtilityDialog

                            onUtilityEdited: {
                                utilitiesEditorItem.recipe.utilities[utilitiesEditorItem.index] = utility;
                            }
                        }
                    }

                    C.MenuItem {
                        text: qsTr("Delete")

                        onTriggered: {
                            deleteUtilityDialog.visible = true;
                        }

                        W.MessageDialog {
                            id: deleteUtilityDialog

                            buttons: W.MessageDialog.Yes | W.MessageDialog.No
                            text: qsTr("Are you sure you want to delete this utility?")
                            title: qsTr("Delete Utility")

                            onAccepted: {
                                utilitiesEditorItem.recipe.utilities.splice(utilitiesEditorItem.index, 1);
                            }
                        }
                    }
                }
            }
        }
    }
}
