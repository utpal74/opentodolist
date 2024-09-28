pragma Singleton

import QtQuick

Item {
    property bool useDesktopMode: {
        switch (Qt.platform.os) {
            case "android":
            case "ios":
            return false
            default:
            return true
        }
    }
}
