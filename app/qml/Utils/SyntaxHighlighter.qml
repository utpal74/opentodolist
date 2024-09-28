pragma Singleton

import QtQuick 2.0
import OpenTodoList 1.0 as OTL
import OpenTodoList.Style as C

OTL.SyntaxHighlighter {
    theme: C.ColorTheme.isDarkColorScheme ? OTL.SyntaxHighlighter.Dark : OTL.SyntaxHighlighter.Light
}
