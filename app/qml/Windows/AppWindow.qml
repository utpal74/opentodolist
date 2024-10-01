import QtQuick 2.0
import OpenTodoList.Style as C
import "../Utils" as Utils

C.ApplicationWindow {
    id: appWindow

    property Utils.ItemUtils itemUtils: Utils.ItemUtils {
        window: appWindow
    }
}
