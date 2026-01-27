import QtQuick 2.0

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

C.Pane {
    id: pane

    readonly property double lightShade: 1.0
    readonly property double midShade: 1.1
    readonly property double heavyShade: 1.2

    property OTL.TopLevelItem item: null
    property double shade: lightShade

    readonly property color backgroundColor: Qt.darker(
                                                 Utils.Colors.itemColor(
                                                     item,
                                                     C.ColorTheme.isDarkColorScheme),
                                                 shade)
    readonly property color textColor: C.ColorTheme.textColorForBackgroundColor(
                                           backgroundColor)

    background: Rectangle {
        color: backgroundColor
    }
}
