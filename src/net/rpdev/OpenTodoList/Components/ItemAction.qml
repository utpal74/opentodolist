import QtQuick 2.0

import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList as OTL

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
    readonly property OTL.NotePageItem notePageItem: item as OTL.NotePageItem
}
