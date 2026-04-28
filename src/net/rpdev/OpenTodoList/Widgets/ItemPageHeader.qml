import QtQuick 2.0
import QtQuick.Layouts 1.12
import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Utils

Item {
    id: root

    property int counter: 0
    property int total: 0
    property OTL.LibraryItem item: null

    width: parent.width
    height: childrenRect.height * 1.5

    Heading {
        id: pageHeading
        text: Markdown.markdownToHtml(
                  "%1%2".arg(root.item?.title).arg(
                      root.total > 0 ? " (%1/%2)".arg(root.counter).arg(
                                           root.total) : ""), palette)
        width: parent.width
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        textFormat: Text.RichText
        bottomPadding: 0
        topPadding: 0
    }
}
