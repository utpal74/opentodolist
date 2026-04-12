import QtQuick 2.5
import QtQuick.Layouts 1.0

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Windows
import net.rpdev.OpenTodoList.Widgets
import net.rpdev.OpenTodoList.Utils
import net.rpdev.OpenTodoList.Menues
import net.rpdev.OpenTodoList.Actions as Actions
import net.rpdev.OpenTodoList.Style as C

ItemPage {
    id: page

    property var goBack: {
        if (itemNotesEditor.editing) {
            return () => itemNotesEditor.finishEditing();
        }
    }
    property OTL.Recipe item: OTL.Recipe {
    }
    property var library: null

    signal closePage
    signal openPage(var component, var properties)

    function addTag() {
        tagsEditor.addTag();
    }

    function attach() {
        attachments.attach();
    }

    /*
      Attaches the list of files to the todo list.
     */
    function attachFiles(fileUrls) {
        attachments.attachFiles(fileUrls);
    }

    function copyItem() {
        copyTopLevelItemAction.trigger();
    }

    function copyLinkToPage() {
        let url = shareUtils.createDeepLink(page.item);
        OTL.Application.copyToClipboard(url.toString());
    }

    function deleteItem() {
        confirmDeleteDialog.deleteItem(item);
    }

    function editYield() {
        editYieldDialog.editYield(item);
    }

    function openInNewWindow() {
        openStackViewWindow(restoreUrl, {
            "item": OTL.Application.cloneItem(page.item),
            "library": OTL.Application.cloneLibrary(page.library)
        });
    }

    function renameItem() {
        renameItemDialog.renameItem(item);
    }

    function setDueDate() {
        dueDateSelectionDialog.selectedDate = item.dueTo;
        dueDateSelectionDialog.open();
    }

    restorePage: function (state) {
        d.restoreLibraryUid = OTL.Application.uuidFromString(state.library);
        d.restoreRecipeUid = OTL.Application.uuidFromString(state.recipe);
        d.loadLibraryTransactionId = OTL.Application.loadLibrary(d.restoreLibraryUid);
        d.loadRecipeTransactionId = OTL.Application.loadItem(d.restoreRecipeUid);
    }
    restoreUrl: Qt.resolvedUrl("./RecipePage.qml")
    savePage: function () {
        return {
            "library": OTL.Application.uuidToString(page.library.uid),
            "recipe": OTL.Application.uuidToString(page.item.uid)
        };
    }
    title: Markdown.markdownToPlainText(item.title)
    topLevelItem: item

    QtObject {
        id: d

        property var loadLibraryTransactionId
        property var loadRecipeTransactionId
        property var restoreLibraryUid
        property var restoreRecipeUid
    }

    DeleteItemDialog {
        id: confirmDeleteDialog

        onAccepted: page.closePage()
    }

    DeleteItemDialog {
        id: confirmDeletePageDialog

    }

    DateSelectionDialog {
        id: dueDateSelectionDialog

        onAccepted: page.item.dueTo = selectedDate
    }

    RenameItemDialog {
        id: renameItemDialog

    }

    EditYieldDialog {
        id: editYieldDialog

    }

    ItemScrollView {
        id: scrollView

        C.ScrollBar.vertical.interactive: true
        C.ScrollBar.vertical.policy: itemNotesEditor.editing ? C.ScrollBar.AlwaysOn : C.ScrollBar.AsNeeded
        anchors.fill: parent
        item: page.item
        padding: AppSettings.mediumSpace

        Flickable {
            id: flickable

            contentHeight: column.height
            contentWidth: column.width
            height: scrollView.availableHeight
            width: scrollView.availableWidth

            Column {
                id: column

                spacing: AppSettings.largeSpace
                width: scrollView.availableWidth

                ItemPageHeader {
                    item: page.item
                }

                Item {
                    height: childrenRect.height
                    width: parent.width

                    RowLayout {
                        spacing: AppSettings.mediumSpace
                        width: parent.width

                        Heading {
                            level: 2
                            text: qsTr("Yield:")
                        }

                        Heading {
                            Layout.fillWidth: true
                            level: 2
                            text: page.item.yieldCount > 0 ? page.item.yieldCount + " " + page.item.yieldUnit : qsTr("Not specified")
                        }

                        C.Symbol {
                            symbol: C.Icons.mdiEdit

                            onClicked: editYieldDialog.editYield(page.item)
                        }
                    }
                }

                TagsEditor {
                    id: tagsEditor

                    item: page.item
                    library: page.library
                    width: parent.width
                }

                ItemDueDateEditor {
                    id: itemDueDateEditor

                    item: page.item
                    width: parent.width
                }

                ItemNotesEditor {
                    id: itemNotesEditor

                    item: page.item
                    width: parent.width
                }

                IngredientsEditor {
                    id: ingredientsEditor

                    item: page.item
                }

                UtilitiesEditor {
                    id: utilitiesEditor

                    item: page.item
                }

                StepsEditor {
                    id: stepsEditor

                    item: page.item
                }

                Attachments {
                    id: attachments

                    item: page.item
                    width: parent.width
                }
            }
        }
    }

    PullToRefreshOverlay {
        anchors.fill: scrollView
        flickable: flickable
        refreshEnabled: page.library?.hasSynchronizer ?? false

        onRefresh: OTL.Application.syncLibrary(page.library)
    }

    Actions.CopyTopLevelItem {
        id: copyTopLevelItemAction

        item: page.item
        itemUtils: page.C.ApplicationWindow.window?.itemUtils ?? null
    }

    Connections {
        function onItemLoaded(uid, data, parents, library, transactionId) {
            if (uid === d.restoreRecipeUid && transactionId === d.loadRecipeTransactionId) {
                page.item = OTL.Application.itemFromData(data);
            }
        }

        function onLibraryLoaded(uid, data, transactionId) {
            if (uid === d.restoreLibraryUid && transactionId === d.loadLibraryTransactionId) {
                page.library = OTL.Application.libraryFromData(data);
            }
        }

        target: OTL.Application
    }

    OTL.ShareUtils {
        id: shareUtils
    }
}
