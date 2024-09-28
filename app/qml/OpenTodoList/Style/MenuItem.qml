import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.MenuItem {
    onTriggered: {
        if (action && action.menu) {
            action.menu.popup()
        }
    }
}
