import QtQuick 2.0
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils as Utils

C.ApplicationWindow {
    id: appWindow

    property Utils.ItemUtils itemUtils: Utils.ItemUtils {
        window: appWindow
    }
}
