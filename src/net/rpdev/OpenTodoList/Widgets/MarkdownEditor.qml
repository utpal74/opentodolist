import QtQuick 2.5

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components as Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils

C.Page {
    id: editor

    property alias text: textArea.text
    property alias textArea: textArea
    property OTL.ComplexItem item

    ScrollView {
        anchors.fill: parent

        C.TextArea {
            id: textArea

            width: parent.width
            height: implicitHeight

            font.family: C.Fonts.monoFont
            item: editor.item
        }
    }

    OTL.SyntaxHighlighter {
        document: textArea.textDocument
        theme: C.ColorTheme.isDarkColorScheme ? OTL.SyntaxHighlighter.Dark : OTL.SyntaxHighlighter.Light
    }
}
