import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.Menu {
    width: {
        var result = implicitWidth
        var padding = 0
        for (var i = 0; i < count; ++i) {
            var item = itemAt(i)
            result = Math.max(item.contentItem.implicitWidth, result)
            padding = Math.max(item.padding, padding)
        }
        return result + padding * 2
    }
}
