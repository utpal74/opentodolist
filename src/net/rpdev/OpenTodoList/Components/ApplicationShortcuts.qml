import QtQuick
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Pages as Pages

import net.rpdev.OpenTodoList as OTL

Item {
    id: shortcuts

    property bool isSecondaryWindow: false

    property C.StackView stackView
    property C.ApplicationWindow window

    property C.Action aboutApp: C.Action {
        id: aboutApp
        text: qsTr("About")
        shortcut: StandardKey.HelpContents
        symbol: C.Icons.mdiInfo
        enabled: !isSecondaryWindow
        onTriggered: shortcuts.stackView.clearAndOpenPage(Qt.resolvedUrl(
                                                    "../Pages/AboutPage.qml"))
    }

    property C.Action aboutQt: C.Action {
        text: qsTr("About Qt")
        symbol: C.Icons.mdiInfo
        enabled: !isSecondaryWindow && Qt.platform.os !== "ios"
                 && Qt.platform.os !== "android"
        onTriggered: OTL.Application.aboutQt()
    }

    property C.Action accounts: C.Action {
        text: qsTr("Accounts")
        enabled: !isSecondaryWindow
        symbol: C.Icons.mdiAccountCircle
        onTriggered: stackView.clearAndOpenPage(
                         Qt.resolvedUrl("../Pages/AccountsPage.qml"))
    }

    property C.Action addTag: C.Action {
        text: qsTr("Add Tag")
        shortcut: "Ctrl+Shift+T"
        symbol: C.Icons.mdiLabel
        enabled: typeof (stackView?.currentItem?.addTag) === "function"
        onTriggered: stackView.currentItem.addTag()
    }

    property C.Action attachFile: C.Action {
        text: qsTr("Attach File")
        shortcut: "Ctrl+Shift+A"
        symbol: C.Icons.mdiAttachment
        enabled: typeof (stackView?.currentItem?.attach) === "function"
        onTriggered: stackView.currentItem.attach()
    }

    property C.Action backup: C.Action {
        text: qsTr("Backup")
        symbol: C.Icons.mdiArchive
        enabled: typeof (stackView?.currentItem?.backup) === "function"
        onTriggered: stackView.currentItem.backup()
    }

    property C.Action close: C.Action {
        text: qsTr("Close")
        shortcut: StandardKey.Close
        enabled: Qt.platform.os !== "android" && Qt.platform.os !== "ios"
        onTriggered: window.close()
    }

    property C.Action copy: C.Action {
        text: qsTr("Copy")
        shortcut: "Ctrl+Shift+C"
        symbol: C.Icons.mdiContentCopy
        enabled: typeof (stackView?.currentItem?.copyItem) === "function"
        onTriggered: stackView.currentItem.copyItem()
    }

    property C.Action copyDeepLink: C.Action {
        text: qsTr("Copy Link To Page")
        shortcut: "Ctrl+Shift+K"
        symbol: C.Icons.mdiContentCopy
        enabled: typeof (stackView?.currentItem?.copyLinkToPage) === "function"
        onTriggered: stackView.currentItem.copyLinkToPage()
    }

    property C.Action createSampleLibrary: C.Action {
        text: qsTr("Create Sample Library")
        onTriggered: {
            var lib = OTL.Application.addLocalLibrary("My Library")

            var note = OTL.Application.addNote(lib, {
                                                   "title": "A note",
                                                   "notes": ["* This is a note.", "* Notes are used to store text.", "* Text can be **styled** as well (using Markdown 😎)", "* On top, additional pages can be added, which actually makes them *notebooks* 😉"].join(
                                                       "\n"),
                                                   "color": OTL.TopLevelItem.Yellow
                                               })
            OTL.Application.addNotePage(lib, note, {
                                            "title": "A second page",
                                            "notes": "This is another *page* added to the same notebook."
                                        })

            var todoList = OTL.Application.addTodoList(lib, {
                                                           "title": "A todo list",
                                                           "notes": ["* A todo list contains todos.", "* Additionally, notes can be set on them, too.", "* If needed, todos can be further divided by adding tasks to them."].join(
                                                               "\n"),
                                                           "color": OTL.TopLevelItem.Green
                                                       })

            OTL.Application.addTodo(lib, todoList, {
                                        "title": "A todo",
                                        "notes": "A simple todo with some notes added to it."
                                    })
            let todoWithTasks = OTL.Application.addTodo(lib, todoList, {
                                                            "title": "A todo with tasks",
                                                            "notes": "This todo contains additional tasks - this can be used to further break down what needs to be done for a single item in a todo list."
                                                        })
            OTL.Application.addTask(lib, todoWithTasks, {
                                        "title": "A task"
                                    })
            OTL.Application.addTask(lib, todoWithTasks, {
                                        "title": "Another task"
                                    })
            OTL.Application.addTask(lib, todoWithTasks, {
                                        "title": "A task which is already done",
                                        "done": true
                                    })

            let recipe = OTL.Application.addRecipe(lib, {
                    "title": "Chocolate Brownies",
                    "notes": "This is a super easy recipe for delicious chocolate brownies. It is so easy, you don't even need to write down the instructions - just add the ingredients and you are good to go! 😉",
                    "yieldCount": 1,
                    "yieldUnit": "pan of brownies",
                    "color": OTL.TopLevelItem.Red
                },
                [
                    OTL.Application.createRecipeIngredient("Butter", "g", 100),
                    OTL.Application.createRecipeIngredient("Bitter Chocolate", "g", 100),
                    OTL.Application.createRecipeIngredient("Eggs", "", 4),
                    OTL.Application.createRecipeIngredient("Sugar", "g", 200),
                    OTL.Application.createRecipeIngredient("Flour", "g", 100)
                ],
                [
                    "Mixing Bowl",
                    "Hand Mixer",
                    "Oven"
                ],
                [
                    OTL.Application.createRecipeStep("Preheat the oven to 180-200°C."),
                    OTL.Application.createRecipeStep("Melt the butter and chocolate together - either in a microwave or in a water bath on the stove."),
                    OTL.Application.createRecipeStep("Add the egg, sugar and flour and mix everything together until you have a smooth batter."),
                    OTL.Application.createRecipeStep("Pour the batter into a suitable baking dish and bake for about 20-30 minutes - the exact time depends on your oven and how gooey you like your brownies 😉. Just check after 20 minutes and then every few minutes until they are done.")
                ]
            )

            var image = OTL.Application.addImage(lib, {
                                                     "title": "An image",
                                                     "image": ":/qt/qml/net/rpdev/OpenTodoList/sample.png",
                                                     "notes": ["* This is an image", "* Images wrap a single image which is prominently shown within a library.", "* As with other top level items, you can add arbitrary notes to them 😉"].join(
                                                         "\n"),
                                                     "color": OTL.TopLevelItem.Lilac
                                                 })

            var noteWithLinks = OTL.Application.addNote(lib, {
                                                            "title": "Links",
                                                            "notes": ["It is possible to use links within items:", "* Links can point to any external resource, e.g. to the [app's home page](https://opentodolist.rpdev.net).", "* However, they also can point to internal *things*, like [the library we are in right now](%1), a [todo list](%2) or a [note](%3). You can get links to items by opening them and using the page controls.".arg(
                                                                    shareUtils.createDeepLink(
                                                                        lib)).arg(
                                                                    shareUtils.createDeepLink(
                                                                        todoList)).arg(
                                                                    shareUtils.createDeepLink(
                                                                        note))].join(
                                                                "\n"),
                                                            "color": OTL.TopLevelItem.Orange
                                                        })
            var colorNote = OTL.Application.addNote(lib, {
                                                        "title": "Item colors",
                                                        "notes": ["Items can be colored:", "* Select from a preset of colors to highlight items.", "* Items without a specific color follow the app's color scheme and blend more easily with the background."].join(
                                                            "\n")
                                                    })
        }
    }

    property C.Action deleteItem: C.Action {
        text: qsTr("Delete")
        shortcut: StandardKey.Delete
        symbol: C.Icons.mdiDelete
        enabled: typeof (stackView?.currentItem?.deleteItem) === "function"
        onTriggered: stackView.currentItem.deleteItem()
    }

    property C.Action deleteCompletedItems: C.Action {
        text: qsTr("Delete Completed Items")
        shortcut: "Ctrl+Shift+Del"
        symbol: C.Icons.mdiRemoveDone
        enabled: typeof (stackView?.currentItem?.deleteCompletedItems) === "function"
        onTriggered: stackView.currentItem.deleteCompletedItems()
    }

    property C.Action dueDate: C.Action {
        text: qsTr("Due Date")
        shortcut: "Ctrl+Shift+D"
        symbol: C.Icons.mdiCalendarToday
        enabled: typeof (stackView?.currentItem?.setDueDate) === "function"
        onTriggered: stackView.currentItem.setDueDate()
    }

    property C.Action find: C.Action {
        text: qsTr("Find")
        shortcut: StandardKey.Find
        enabled: typeof (stackView?.currentItem?.find) === "function"
        onTriggered: stackView?.currentItem?.find()
    }

    property C.Action goBack: C.Action {
        text: qsTr("Back")
        shortcut: StandardKey.Back
        enabled: Qt.platform.os !== "android" && Qt.platform.os !== "ios"
        onTriggered: {
            if (stackView?.canGoBack) {
                stackView.goBack()
            } else {
                // We are at the top of the stack. If the window is in fullscreen mode, go to
                // "default" mode (which should usually be "windowed" on most systems).
                if (window.visibility === Window.FullScreen) {
                    window.visibility = Window.AutomaticVisibility
                }
            }
        }
    }

    property C.Action leftSidebar: C.Action {
        text: qsTr("Left Sidebar")
        shortcut: "Ctrl+0"
        symbol: C.Icons.mdiMenu
    }

    property C.Action markAllItemsAsDone: C.Action {
        text: qsTr("Mark all items as done")
        enabled: !!stackView?.topmostTodo || !!stackView?.topmostTodoList
        onTriggered: {
            if (stackView.topmostTodo) {
                OTL.Application.markAllItemsAsDone(stackView.topmostTodo)
            } else if (stackView.topmostTodoList) {
                OTL.Application.markAllItemsAsDone(stackView.topmostTodoList)
            }
        }
    }

    property C.Action markAllItemsAsUndone: C.Action {
        text: qsTr("Mark all items as undone")
        enabled: !!stackView?.topmostTodo || !!stackView?.topmostTodoList
        onTriggered: {
            if (stackView.topmostTodo) {
                OTL.Application.markAllItemsAsUndone(stackView.topmostTodo)
            } else if (stackView.topmostTodoList) {
                OTL.Application.markAllItemsAsUndone(stackView.topmostTodoList)
            }
        }
    }

    property C.Action move: C.Action {
        text: qsTr("Move")
        shortcut: "Ctrl+Shift+M"
        symbol: C.Icons.mdiCut
        enabled: typeof (stackView?.currentItem?.moveItem) === "function"
        onTriggered: stackView.currentItem.moveItem()
    }

    property C.Action newLibrary: C.Action {
        text: qsTr("New Library")
        shortcut: "Ctrl+Shift+N"
        enabled: !isSecondaryWindow
        symbol: C.Icons.mdiAdd
        onTriggered: stackView.clearAndOpenPage(newLibraryPage)
    }

    property C.Action open: C.Action {
        text: qsTr("Open Created Item")
        shortcut: StandardKey.Open
        enabled: !!window?.itemCreatedNotification
        onTriggered: window.itemCreatedNotification.trigger()
    }

    property C.Action openInNewWindow: C.Action {
        text: qsTr("Open In New Window")
        shortcut: StandardKey.AddTab
        enabled: !isSecondaryWindow && Application.supportsMultipleWindows
                 && typeof (stackView?.currentItem?.openInNewWindow) === "function"
        onTriggered: stackView.currentItem.openInNewWindow()
    }

    property C.Action openLibraryFolder: C.Action {
        text: qsTr("Open Library Folder")
        enabled: !!stackView.topmostLibrary && shareUtils.canOpenFolders
        onTriggered: shareUtils.openFolder(stackView.topmostLibrary.directory)
    }

    property C.Action quit: C.Action {
        text: qsTr("Quit")
        shortcut: [StandardKey.Quit]
        onTriggered: Qt.quit()
    }

    property C.Action rename: C.Action {
        text: qsTr("Rename")
        shortcut: "Ctrl+Shift+R"
        symbol: C.Icons.mdiEdit
        enabled: typeof (stackView?.currentItem?.renameItem) === "function"
        onTriggered: stackView.currentItem.renameItem()
    }

    property C.Action editYield: C.Action {
        text: qsTr("Edit Yield")
        shortcut: "Ctrl+Shift+R"
        symbol: C.Icons.mdiEdit
        enabled: typeof (stackView?.currentItem?.editYield) === "function"
        onTriggered: stackView.currentItem.editYield()
    }

    property C.Action settings: C.Action {
        text: qsTr("Preferences")
        enabled: !isSecondaryWindow
        shortcut: "Ctrl+,"
        symbol: C.Icons.mdiSettings
        onTriggered: {
            if (!stackView) {
                return
            }

            for (var i = 0; i < stackView.depth; ++i) {
                let page = stackView.get(i)
                if (page instanceof Pages.SettingsPage) {
                    stackView.pop(page)
                    return
                }
            }
            stackView.push(Qt.resolvedUrl("../Pages/SettingsPage.qml"))
        }
    }

    property C.Action scrollToTop: C.Action {
        text: qsTr("Scroll to Top")
        shortcut: "Home"
        enabled: typeof (stackView?.currentItem?.scrollToTop) === "function"
        onTriggered: stackView?.currentItem?.scrollToTop()
    }

    property C.Action scrollToBottom: C.Action {
        text: qsTr("Scroll to Bottom")
        shortcut: "End"
        enabled: typeof (stackView?.currentItem?.scrollToBottom) === "function"
        onTriggered: stackView?.currentItem?.scrollToBottom()
    }

    property C.Action setColor: C.Action {
        text: qsTr("Set Color")
        symbol: C.Icons.mdiPalette
        enabled: !!stackView?.topmostPageWithSelectColorFunction
        onTriggered: stackView.topmostPageWithSelectColorFunction.selectColor()
    }

    property C.Action setProgress: C.Action {
        text: qsTr("Set Progress")
        symbol: C.Icons.mdiPublishedWithChanges
        enabled: typeof (stackView?.currentItem?.setProgress) === "function"
        onTriggered: stackView?.currentItem?.setProgress()
    }

    property C.Action sort: C.Action {
        text: qsTr("Sort")
        shortcut: "Ctrl+Shift+S"
        symbol: C.Icons.mdiSort
        enabled: typeof (stackView?.currentItem?.sort) === "function"
        onTriggered: stackView?.currentItem?.sort()
    }

    property C.Action sync: C.Action {
        text: qsTr("Sync Now")
        shortcut: StandardKey.Refresh
        symbol: C.Icons.mdiSync
        onTriggered: {
            if (stackView?.topmostLibrary) {
                OTL.Application.syncLibrary(stackView.topmostLibrary)
            } else {
                OTL.Application.syncAllLibraries()
            }
        }
    }

    property C.Action syncLog: C.Action {
        text: qsTr("Sync Log")
        enabled: !!stackView?.topmostLibrary
                 && !(stackView?.currentItem instanceof Pages.LogViewPage)
        onTriggered: stackView.push(Qt.resolvedUrl("../Pages/LogViewPage.qml"),
                                    {
                                        "log": stackView.topmostLibrary.syncLog(
                                                   )
                                    })
    }

    property C.Action translateTheApp: C.Action {
        text: qsTr("Translate The App...")
        enabled: !isSecondaryWindow
        symbol: C.Icons.mdiTranslate
        onTriggered: shareUtils.openLink(
                         "https://poeditor.com/join/project/ztvOymGNxn")
    }

    signal newLibraryCreated(var library)

    Shortcut {
        sequences: ["Esc", "Back"]
        onActivated: shortcuts.goBack.triggered()
    }

    OTL.ShareUtils {
        id: shareUtils
    }

    Component {
        id: newLibraryPage

        Pages.NewLibraryPage {
            onLibraryCreated: library => {
                                  if (library) {
                                      newLibraryCreated(library)
                                  }
                              }
        }
    }
}
