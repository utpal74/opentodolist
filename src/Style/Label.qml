import QtQuick
import QtQuick.Controls.Basic as Basic

import OpenTodoList as OTL

import OpenTodoList.Utils as Utils

Basic.Label {
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere

    function linkHandler(link) {
        shareUtils.openLink(link)
    }

    onLinkActivated: linkHandler(link)
    textFormat: Text.StyledText
    linkColor: Utils.Colors.linkColor
    ToolTip.visible: StyleSettings.useDesktopMode && mouseArea.containsMouse
                     && ToolTip.text !== ""
    ToolTip.text: hoveredLink

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: parent.hoveredLink !== "" ? Qt.PointingHandCursor : Qt.ArrowCursor
        hoverEnabled: StyleSettings.useDesktopMode
    }

    OTL.ShareUtils {
        id: shareUtils
    }
}
