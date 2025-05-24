import QtQuick 2.0

import OpenTodoList.Style as C
import OpenTodoList 1.0 as OTL

C.Action {
    property OTL.LibraryItem item: null
    property string symbol: ""
    property bool hideButton: false
    readonly property OTL.ComplexItem complexItem: item as OTL.ComplexItem
    readonly property OTL.TopLevelItem topLevelItem: item as OTL.TopLevelItem
    readonly property OTL.TodoList todoListItem: item as OTL.TodoList
    readonly property OTL.Todo todoItem: item as OTL.Todo
    readonly property OTL.Task taskItem: item as OTL.Task
    readonly property OTL.Image imageItem: item as OTL.Image
    readonly property OTL.Note noteItem: item as OTL.Note
    readonly property OTL.NotePage notePageItem: item as OTL.NotePage
}
