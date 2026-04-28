import QtQuick
import QtQuick.Layouts

import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as U
import net.rpdev.OpenTodoList.Windows as W
import net.rpdev.OpenTodoList.Widgets as Widgets

MouseArea {
    id: stepsEditorItem

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
            if (!(child instanceof StepsEditorItem)) {
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
        if (newIndex !== -1 && newIndex !== stepsEditorItem.index) {
            let step = stepsEditorItem.recipe.steps[stepsEditorItem.index];
            // Note: If the new index is smaller than the old one, the following moves the
            // item before the item we dropped on. Contrary, if the new index is bigger,
            // due to we don't adjust the new index after removing the item, it will be moved
            // after the item we dropped on. This is one would most likely expect.
            stepsEditorItem.recipe.steps.splice(stepsEditorItem.index, 1);
            stepsEditorItem.recipe.steps.splice(newIndex, 0, step);
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
        visible: stepsEditorItem.index > 0
    }

    C.ItemDelegate {
        id: itemDelegate

        width: parent.width
        height: contentRow.height + topPadding + bottomPadding + U.AppSettings.largeSpace
        anchors.top: stepsEditorItem.held ? undefined : parent.top
        leftPadding: U.AppSettings.smallSpace

        RowLayout {
            id: contentRow

            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            spacing: U.AppSettings.smallSpace

            Item {
                implicitWidth: itemDelegate.leftPadding
                implicitHeight: 1
            }

            Widgets.MarkdownViewer {
                Layout.fillWidth: true
                markdownText: stepsEditorItem.modelData.description
                item: stepsEditorItem.recipe
            }

            C.Symbol {
                symbol: C.Icons.mdiDragHandle
                visible: !U.AppSettings.desktopMode

                MouseArea {
                    anchors.fill: parent
                    drag.axis: Drag.YAxis
                    drag.target: stepsEditorItem.held ? itemDelegate : undefined
                    preventStealing: true

                    onPressed: stepsEditorItem.held = true
                    onReleased: stepsEditorItem.finishDrag()
                    onCanceled: stepsEditorItem.held = false
                }
            }

            C.Symbol {
                symbol: C.Icons.mdiMoreVert

                menu: C.Menu {
                    modal: true

                    C.MenuItem {
                        text: qsTr("Edit")

                        onTriggered: {
                            editExistingMarkdownDialog.item = stepsEditorItem.recipe;
                            editExistingMarkdownDialog.text = stepsEditorItem.modelData.description
                            editExistingMarkdownDialog.visible = true;
                        }

                        W.MarkdownEditorDialog {
                            id: editExistingMarkdownDialog

                            onAccepted: {
                                stepsEditorItem.recipe.steps[stepsEditorItem.index].description = editExistingMarkdownDialog.text;
                            }
                        }
                    }

                    C.MenuItem {
                        text: qsTr("Delete")

                        onTriggered: {
                            deleteStepDialog.visible = true;
                        }

                        W.MessageDialog {
                            id: deleteStepDialog

                            buttons: W.MessageDialog.Yes | W.MessageDialog.No
                            text: qsTr("Are you sure you want to delete this step?")
                            title: qsTr("Delete Step")

                            onAccepted: {
                                stepsEditorItem.recipe.steps.splice(stepsEditorItem.index, 1);
                            }
                        }
                    }
                }
            }
        }
    }
}
