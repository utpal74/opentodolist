import QtQuick
import QtQuick.Controls.Basic as Basic

import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Utils as Utils

Basic.TextArea {
    id: textArea

    property OTL.ComplexItem item

    function handlePaste() {
        let urls = OTL.Application.urlsFromClipboard();
        if (urls.length > 0) {
            let linesToInsert = [];
            for (let i = 0; i < urls.length; ++i) {
                let url = urls[i];
                let attachmentResult = textArea.item.attachFile(url);
                if (attachmentResult.valid) {
                    if (attachmentResult.isImage) {
                        linesToInsert.push("![" + attachmentResult.originalFileName + "](" + attachmentResult.attachmentFileName + ")");
                    } else {
                        linesToInsert.push("[" + attachmentResult.originalFileName + "](" + attachmentResult.attachmentFileName + ")");
                    }
                } else {
                    linesToInsert.push("[" + url.toString() + "](" + url.toString() + ")");
                }
            }
            textArea.insert(textArea.cursorPosition, "\n" + linesToInsert.join("\n") + "\n");
        } else {
            textArea.paste();
        }
    }

    selectByMouse: Utils.AppSettings.selectTextByMouse
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere

    Keys.onPressed: event => {
        if (textArea.item && (event.key === Qt.Key_V) && (event.modifiers & Qt.ControlModifier)) {
            event.accepted = true; // Prevent default behavior
            handlePaste();
        }
    }

    Binding {
        target: textArea
        property: "baseUrl"
        value: textArea.item?.baseUrl
        when: textArea.item
    }
}
