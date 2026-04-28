import QtQuick 2.10
import QtQuick.Layouts 1.1
import QtCore

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Dialogs as Dialogs
import net.rpdev.OpenTodoList.Menues
import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Widgets
import net.rpdev.OpenTodoList.Windows
import net.rpdev.OpenTodoList.Utils
import net.rpdev.OpenTodoList.Style as C

C.Page {
    id: page

    property OTL.Library library: null
    property int syncProgress: {
        let result = -1;
        if (library) {
            result = OTL.Application.syncProgress[library.directory];
            if (result === undefined) {
                result = -1;
            }
        }
        return result;
    }
    property bool syncRunning: {
        return library && OTL.Application.directoriesWithRunningSync.indexOf(library.directory) >= 0;
    }
    property string tag: ""
    property bool untaggedOnly: false

    signal closePage
    signal openPage(var component, var properties)

    function backup() {
        library.backup();
    }

    function copyLinkToPage() {
        let url = shareUtils.createDeepLink(page.library);
        OTL.Application.copyToClipboard(url.toString());
    }

    function deleteItem() {
        deleteLibraryDialog.deleteLibrary(library);
    }

    function find() {
        filterBar.edit.forceActiveFocus();
    }

    function newImage() {
        openImageDialog.open();
    }

    function newNote() {
        newNoteBar.edit.forceActiveFocus();
        newNoteBar.edit.text = "";
    }

    function newTodoList() {
        newTodoListBar.edit.forceActiveFocus();
        newTodoListBar.edit.text = "";
    }

    function newRecipe() {
        newRecipeBar.edit.forceActiveFocus();
        newRecipeBar.edit.text = "";
    }

    function renameItem() {
        renameLibraryDialog.renameLibrary(library);
    }

    function selectColor() {
        colorDialog.selectedColor = page.library.color;
        colorDialog.open();
    }

    function sort() {
        sortByMenu.popup();
    }

    clip: true
    restorePage: function (data) {
        let uid = data.library;
        if (uid) {
            d.restoreLibraryUid = OTL.Application.uuidFromString(uid);
            d.loadLibraryTransactionId = OTL.Application.loadLibrary(d.restoreLibraryUid);
        }
        let tag = data.tag;
        if (tag) {
            page.tag = tag;
        }
        page.untaggedOnly = !!data.untaggedOnly;
    }
    restoreUrl: Qt.resolvedUrl("./LibraryPage.qml")
    savePage: function () {
        let result = {};
        if (page.library) {
            result.library = OTL.Application.uuidToString(page.library.uid);
        }
        if (page.tag !== "") {
            result.tag = page.tag;
        }
        result.untaggedOnly = page.untaggedOnly;
        return result;
    }
    title: library?.name ?? ""

    Settings {
        id: settings

        property string sortBy: "weight"

        category: "LibraryPage"
    }

    QtObject {
        id: d

        property var loadLibraryTransactionId
        property var restoreLibraryUid

        function createNote(library, edit, tags) {
            var properties = {
                "title": edit.displayText,
                "tags": tags
            };
            var result = OTL.Application.addNote(library, properties);
            edit.text = "";
            edit.focus = false;
            return result;
        }

        function createTodoList(library, edit, tags) {
            var properties = {
                "title": edit.displayText,
                "tags": tags
            };

            var result = OTL.Application.addTodoList(library, properties);
            edit.text = "";
            edit.focus = false;
            return result;
        }

        function createRecipe(library, edit, tags) {
            var properties = {
                "title": edit.displayText,
                "tags": tags
            };

            var result = OTL.Application.addRecipe(library, properties);
            edit.text = "";
            edit.focus = false;
            return result;
        }

        function numberOfColumns(page) {
            let charWidth = Math.max(AppSettings.effectiveFontMetrics.averageCharacterWidth, 5);
            var minWidth = charWidth * AppSettings.libraryItemWidthScaleFactor;
            var result = page.width / minWidth;
            result = Math.ceil(result);
            result = Math.max(result, 1);
            return result;
        }

        function openItem(item) {
            page.C.StackView.view.push(Qt.resolvedUrl("./" + item.itemType + "Page.qml"), {
                "item": OTL.Application.cloneItem(item),
                "library": page.library
            });
        }

        function sizeOfColumns(page, correction) {
            if (correction === undefined) {
                correction = 0;
            }
            return (page.width - correction) / numberOfColumns(page);
        }
    }

    OTL.ShareUtils {
        id: shareUtils

    }

    RenameLibraryDialog {
        id: renameLibraryDialog

    }

    DeleteLibraryDialog {
        id: deleteLibraryDialog

    }

    DeleteItemDialog {
        id: deleteItemDialog

    }

    RenameItemDialog {
        id: renameItemDialog

    }

    C.Menu {
        id: itemContextMenu

        property var color: item ? item.color : OTL.TopLevelItem.White
        property OTL.TopLevelItem item: null

        modal: true

        C.ButtonGroup {
            id: colorButtons

        }

        C.MenuItem {
            C.ButtonGroup.group: colorButtons
            checkable: true
            checked: itemContextMenu.color === OTL.TopLevelItem.Red
            text: qsTr("Red")

            onTriggered: itemContextMenu.item.color = OTL.TopLevelItem.Red
        }

        C.MenuItem {
            C.ButtonGroup.group: colorButtons
            checkable: true
            checked: itemContextMenu.color === OTL.TopLevelItem.Green
            text: qsTr("Green")

            onTriggered: itemContextMenu.item.color = OTL.TopLevelItem.Green
        }

        C.MenuItem {
            C.ButtonGroup.group: colorButtons
            checkable: true
            checked: itemContextMenu.color === OTL.TopLevelItem.Blue
            text: qsTr("Blue")

            onTriggered: itemContextMenu.item.color = OTL.TopLevelItem.Blue
        }

        C.MenuItem {
            C.ButtonGroup.group: colorButtons
            checkable: true
            checked: itemContextMenu.color === OTL.TopLevelItem.Yellow
            text: qsTr("Yellow")

            onTriggered: itemContextMenu.item.color = OTL.TopLevelItem.Yellow
        }

        C.MenuItem {
            C.ButtonGroup.group: colorButtons
            checkable: true
            checked: itemContextMenu.color === OTL.TopLevelItem.Orange
            text: qsTr("Orange")

            onTriggered: itemContextMenu.item.color = OTL.TopLevelItem.Orange
        }

        C.MenuItem {
            C.ButtonGroup.group: colorButtons
            checkable: true
            checked: itemContextMenu.color === OTL.TopLevelItem.Lilac
            text: qsTr("Lilac")

            onTriggered: itemContextMenu.item.color = OTL.TopLevelItem.Lilac
        }

        C.MenuItem {
            C.ButtonGroup.group: colorButtons
            checkable: true
            checked: itemContextMenu.color === OTL.TopLevelItem.White
            text: qsTr("White")

            onTriggered: itemContextMenu.item.color = OTL.TopLevelItem.White
        }

        C.MenuSeparator {
        }

        C.MenuItem {
            text: qsTr("Rename")

            onTriggered: renameItemDialog.renameItem(itemContextMenu.item)
        }

        C.MenuItem {
            text: qsTr("Copy")

            onTriggered: C.ApplicationWindow.window.itemUtils.copyTopLevelItem(itemContextMenu.item)
        }

        C.MenuItem {
            text: qsTr("Delete")

            onTriggered: deleteItemDialog.deleteItem(itemContextMenu.item)
        }
    }

    Dialogs.FileDialog {
        id: openImageDialog

        currentFolder: {
            let photosLocation = OTL.Application.getPhotoLibraryLocation();
            return photosLocation;
        }
        nameFilters: ["Image Files (*.png *.bmp *.jpg *.jpeg *.gif)"]
        title: qsTr("Select Image")

        onAccepted: {
            var filename = OTL.Application.urlToLocalFile(selectedFile);
            var tags = [];
            if (page.tag !== "") {
                tags = [page.tag];
            }
            var properties = {
                "title": OTL.Application.basename(filename),
                "imageUrl": selectedFile,
                "tags": tags
            };

            var image = OTL.Application.addImage(library, properties);
            itemCreatedNotification.show(image);
        }
    }

    ColorSelectionDialog {
        id: colorDialog

        onAccepted: if (selectedColor) {
            page.library.color = selectedColor;
        } else {
            page.library.resetColor();
        }
    }

    OTL.ItemsModel {
        id: itemsModel

        /**
         * @brief The role to sort by.
         *
         * This is a helper property, which is required in order to
         * get notified when the sort role changes (this is not the case
         * with the default sortRole property of QSortFilterProxyModel).
         */
        readonly property int effectiveSortRole: {
            switch (settings.sortBy) {
            case "dueTo":
                return OTL.ItemsModel.EffectiveDueToRole;
            case "title":
                return OTL.ItemsModel.TitleRole;
            case "createdAt":
                return OTL.ItemsModel.CreatedAtRole;
            case "updatedAt":
                return OTL.ItemsModel.EffectiveUpdatedAtRole;

            // By default, order manually:
            default:
                return OTL.ItemsModel.WeightRole;
            }
        }

        sortRole: effectiveSortRole
        cache: page.library ? OTL.Application.cache : null
        parentItem: page.library?.uid ?? ""
        searchString: filterBar.text
        tag: page.tag
        untaggedOnly: page.untaggedOnly
    }

    TextInputBar {
        id: newNoteBar

        placeholderText: qsTr("Note Title")

        onAccepted: {
            var tags = [];
            if (page.tag !== "") {
                tags = [page.tag];
            }
            var note = d.createNote(library, newNoteBar.edit, tags);
            itemCreatedNotification.show(note);
        }
    }

    TextInputBar {
        id: newTodoListBar

        placeholderText: qsTr("Todo List Title")

        onAccepted: {
            var tags = [];
            if (page.tag !== "") {
                tags = [page.tag];
            }
            var todoList = d.createTodoList(library, newTodoListBar.edit, tags);
            itemCreatedNotification.show(todoList);
        }
    }

    TextInputBar {
        id: newRecipeBar

        placeholderText: qsTr("Recipe Title")

        onAccepted: {
            var tags = [];
            if (page.tag !== "") {
                tags = [page.tag];
            }
            var recipe = d.createRecipe(library, newRecipeBar.edit, tags);
            itemCreatedNotification.show(recipe);
        }
    }

    TextInputBar {
        id: filterBar

        closeOnButtonClick: true
        placeholderText: qsTr("Search term 1, search term 2, ...")
        showWhenNonEmpty: true
        symbol: C.Icons.mdiClose
    }

    C.ScrollView {
        id: scrollView

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            top: filterBar.bottom
        }

        GridView {
            id: grid

            cellHeight: cellWidth / 3 * 2
            cellWidth: d.sizeOfColumns(scrollView)
            flow: GridView.LeftToRight
            model: itemsModel
            width: scrollView.width

            delegate: Loader {
                id: gridItem

                GridView.delayRemove: item ? item.GridView.delayRemove : false
                asynchronous: true
                height: grid.cellHeight
                source: Qt.resolvedUrl("../Widgets/" + object.itemType + "Item.qml")
                width: grid.cellWidth

                onLoaded: {
                    item.allowReordering = Qt.binding(function () {
                        return itemsModel.effectiveSortRole === OTL.ItemsModel.WeightRole;
                    });
                    item.libraryItem = Qt.binding(function () {
                        return object;
                    });
                    item.library = page.library;
                    item.model = itemsModel;
                    item.onClicked.connect(function (mouse) {
                        switch (mouse.button) {
                        case Qt.LeftButton:
                            d.openItem(object);
                            break;
                        case Qt.RightButton:
                            itemContextMenu.item = object;
                            itemContextMenu.parent = gridItem;
                            itemContextMenu.x = mouse.x;
                            itemContextMenu.y = mouse.y;
                            itemContextMenu.open();
                            break;
                        default:
                            break;
                        }
                    });
                }
            }
        }
    }

    PullToRefreshOverlay {
        anchors.fill: scrollView
        flickable: grid
        refreshEnabled: page.library?.hasSynchronizer ?? false

        onRefresh: OTL.Application.syncLibrary(page.library)
    }

    AutoScrollOverlay {
        anchors.fill: parent
        flickable: grid
    }

    BackgroundLabel {
        text: Markdown.generateStylesheet(palette, true) + qsTr("Nothing here yet! Start by adding a " + "<a href='#note'>note</a>, " + "<a href='#todolist'>todo list</a> or " + "<a href='#image'>image</a>.")
        visible: itemsModel.count === 0

        onLinkActivated: {
            switch (link) {
            case "#note":
                page.newNote();
                break;
            case "#todolist":
                page.newTodoList();
                break;
            case "#image":
                page.newImage();
                break;
            default:
                break;
            }
        }
    }

    NewTopLevelItemButton {
        onNewImage: page.newImage()
        onNewNote: page.newNote()
        onNewTodoList: page.newTodoList()
        onNewRecipe: page.newRecipe()
    }

    SyncErrorNotificationBar {
        readonly property var syncErrors: {
            if (page.library) {
                return OTL.Application.syncErrors[page.library.directory] || [];
            } else {
                return [];
            }
        }

        library: page.library

        onShowErrors: page.openPage(syncErrorPage, {
            "errors": syncErrors
        })
    }

    Component {
        id: syncErrorPage

        SyncErrorViewPage {
        }
    }

    ItemCreatedNotification {
        id: itemCreatedNotification

        onOpen: d.openItem(item)
    }

    C.Menu {
        id: sortByMenu

        modal: true
        title: qsTr("Sort By")

        C.MenuItem {
            checkable: true
            checked: itemsModel.effectiveSortRole === OTL.ItemsModel.WeightRole
            text: qsTr("Manually")

            onTriggered: settings.sortBy = "weight"
        }

        C.MenuItem {
            checkable: true
            checked: itemsModel.effectiveSortRole === OTL.ItemsModel.TitleRole
            text: qsTr("Title")

            onTriggered: settings.sortBy = "title"
        }

        C.MenuItem {
            checkable: true
            checked: itemsModel.effectiveSortRole === OTL.ItemsModel.EffectiveDueToRole
            text: qsTr("Due To")

            onTriggered: settings.sortBy = "dueTo"
        }

        C.MenuItem {
            checkable: true
            checked: itemsModel.effectiveSortRole === OTL.ItemsModel.CreatedAtRole
            text: qsTr("Created At")

            onTriggered: settings.sortBy = "createdAt"
        }

        C.MenuItem {
            checkable: true
            checked: itemsModel.effectiveSortRole === OTL.ItemsModel.EffectiveUpdatedAtRole
            text: qsTr("Updated At")

            onTriggered: settings.sortBy = "updatedAt"
        }
    }

    Connections {
        function onLibraryLoaded(uid, data, transactionId) {
            if (uid === d.restoreLibraryUid && transactionId === d.loadLibraryTransactionId) {
                page.library = OTL.Application.libraryFromData(data);
            }
        }

        target: page.library ? null : OTL.Application
    }

    Connections {
        function onBackupAvailable(backupFile) {
            shareUtils.showFileInFolder(backupFile);
        }

        target: page.library
    }
}
