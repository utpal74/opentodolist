import QtQuick 2.12

import OpenTodoList.Style as C
import "../Utils" as Utils

C.Label {
    property int level: 1

    font.pointSize: Utils.AppSettings.effectiveFontSize + 7 - level
    font.bold: true
    font.family: C.Fonts.titleFont
    bottomPadding: Utils.AppSettings.smallSpace + Utils.AppSettings.mediumSpace
                   * (1.0 - level / 6.0)
    topPadding: bottomPadding
}
