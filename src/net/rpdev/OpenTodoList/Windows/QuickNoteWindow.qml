import QtQuick 2.10
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtCore

import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as Utils

import net.rpdev.OpenTodoList as OTL

AppWindow {
    id: root

    signal openMainWindow

    title: qsTr("Quick Notes")
    width: 400
    height: 600

    onVisibleChanged: if (visible) {
                          noteText.forceActiveFocus()
                      }

    C.Page {

        anchors.fill: parent
        padding: Utils.AppSettings.smallSpace

        header: C.ToolBar {
            padding: Utils.AppSettings.smallSpace
            RowLayout {
                anchors.fill: parent

                C.Label {
                    text: qsTr("Quick Notes Editor")
                    Layout.fillWidth: true
                    elide: "ElideRight"
                    wrapMode: Text.NoWrap
                }

                C.Symbol {
                    symbol: C.Icons.mdiLaunch
                    onClicked: root.openMainWindow()
                    C.ToolTip.text: qsTr("Open the main window")
                }
            }
        }

        GridLayout {
            anchors.fill: parent
            columns: 2

            C.TextField {
                id: noteTitle

                placeholderText: qsTr("Quick Note Title")
                Layout.fillWidth: true
                Layout.columnSpan: 2
            }

            C.ScrollView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.columnSpan: 2

                C.TextArea {
                    id: noteText

                    placeholderText: qsTr("Type your notes here...")
                }
            }

            C.ComboBox {
                id: librarySelector

                Layout.fillWidth: true
                model: OTL.LibrariesModel {
                    cache: OTL.Application.cache
                }
                textRole: "name"
                valueRole: "library"
                onCurrentValueChanged: {
                    if (currentValue !== null) {
                        settings.lastLibraryUid = currentValue.uid
                    }
                }
                onCountChanged: {
                    if (settings.lastLibraryUid) {
                        for (var i = 0; i < count; ++i) {
                            let lib = model.get(i)
                            if (lib.uid === settings.lastLibraryUid) {
                                currentIndex = i
                                return
                            }
                        }
                    }
                }
            }

            C.Button {
                id: saveButton

                function getCreateArgs(defaultTitlePrefix) {
                    let title = noteTitle.text
                    if (title === "") {
                        title = defaultTitlePrefix + " - " + (new Date()).toLocaleString()
                    }
                    ;
                    return {
                        "title": title,
                        "notes": noteText.text
                    }
                }

                function clear() {
                    noteTitle.clear()
                    noteText.clear()
                }

                text: qsTr("Save")
                enabled: !!librarySelector.currentValue && noteText.text !== ""
                onClicked: createNoteAction.trigger()
                onPressAndHold: contextMenu.popup()
                hoverEnabled: true
                C.ToolTip.text: qsTr(
                                    "Save the entered notes to the selected library. "
                                    + "Press and hold the button to get more options for saving.")

                C.Menu {
                    id: contextMenu

                    modal: true

                    C.MenuItem {
                        action: createNoteAction
                    }
                    C.MenuItem {
                        action: createTodoListAction
                    }
                }
            }
        }
    }

    C.Action {
        id: createNoteAction
        text: qsTr("Save as Note")
        enabled: saveButton.enabled
        onTriggered: {
            OTL.Application.addNote(librarySelector.currentValue,
                                    saveButton.getCreateArgs(qsTr(
                                                                 "Quick Note")))
            saveButton.clear()
        }
        shortcut: StandardKey.Save
    }

    C.Action {
        id: createTodoListAction
        text: qsTr("Save as Todo List")
        onTriggered: {
            OTL.Application.addTodoList(librarySelector.currentValue,
                                        saveButton.getCreateArgs(
                                            qsTr("Quick Todo List")))
            saveButton.clear()
        }
    }

    C.Action {
        shortcut: StandardKey.Close
        onTriggered: root.hide()
    }

    C.Action {
        shortcut: StandardKey.Quit
        onTriggered: Qt.quit()
    }

    OTL.SyntaxHighlighter {
        document: noteText.textDocument
        theme: C.ColorTheme.isDarkColorScheme ? OTL.SyntaxHighlighter.Dark : OTL.SyntaxHighlighter.Light
    }

    Settings {
        id: settings

        category: "QuickNotesEditor"

        property alias noteTitle: noteTitle.text
        property alias noteText: noteText.text
        property var lastLibraryUid
        property alias width: root.width
        property alias height: root.height
    }
}
