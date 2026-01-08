import QtQuick 2.0

import OpenTodoList 1.0 as OTL

import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C

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
