import QtQuick 2.5

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils

C.TextArea {
    id: textEdit

    property string markdownText

    readOnly: true
    textFormat: Text.RichText
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    C.ToolTip.text: hoveredLink
    text: Markdown.markdownToHtml(markdownText, palette)

    onLinkActivated: link => {
                            shareUtils.openLink(link)
                        }

    onReleased: mouse => {
                    if (mouse.button === Qt.RightButton) {
                        notesContextMenu.popup()
                    }
                }

    OTL.ShareUtils {
        id: shareUtils
    }

    C.Menu {
        id: notesContextMenu

        modal: true

        C.MenuItem {
            text: qsTr("Copy")
            onTriggered: OTL.Application.copyToClipboard(textEdit.markdownText)
            enabled: textEdit.selectedText === ""
        }

        C.MenuItem {
            text: qsTr("Copy Formatted Text")
            onTriggered: {
                if (textEdit.selectedText === "") {
                    OTL.Application.copyHtmlToClipboard(
                                Markdown.markdownToHtml(textEdit.markdownText, palette))
                } else {
                    OTL.Application.copyToClipboard(
                                textEdit.getFormattedText(
                                    textEdit.selectionStart,
                                    textEdit.selectionEnd))
                }
            }
        }

        C.MenuItem {
            text: qsTr("Copy Plain Text")
            onTriggered: {
                if (textEdit.selectedText === "") {
                    OTL.Application.copyToClipboard(
                                Markdown.markdownToPlainText(
                                    textEdit.markdownText))
                } else {
                    OTL.Application.copyToClipboard(
                                textEdit.selectedText)
                }
            }
        }
    }
}
