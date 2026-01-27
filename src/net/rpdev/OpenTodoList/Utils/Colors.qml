pragma Singleton

import QtQuick 2.10
import QtCore

import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Style as C

Item {
    id: root

    readonly property string systemTheme: "system"
    readonly property string lightTheme: "light"
    readonly property string darkTheme: "dark"
    readonly property string systemThemeName: qsTr("System")
    readonly property string lightThemeName: qsTr("Light")
    readonly property string darkThemeName: qsTr("Dark")

    readonly property var themes: ([{
                                        "name": systemTheme,
                                        "title": systemThemeName
                                    }, {
                                        "name": lightTheme,
                                        "title": lightThemeName
                                    }, {
                                        "name": darkTheme,
                                        "title": darkThemeName
                                    }])

    property string theme: systemTheme

    // Pre-defined colors for specific "roles":
    readonly property color negativeColor: C.ColorTheme.selectedPalette.accent
    readonly property color linkColor: C.ColorTheme.selectedPalette.button

    function itemColor(item, darkColorScheme) {
        if (!item || item.color === undefined) {
            return Qt.darker("#00000000", 1.0)
        }

        if (darkColorScheme) {
            switch (item.color) {
            case OTL.TopLevelItem.White:
                return Qt.darker("#25282A", 1.0) // RAL 9011 Graphite black
            case OTL.TopLevelItem.Red:
                return Qt.darker("#B92726", 1.0) // RAL 3028 Pure red
            case OTL.TopLevelItem.Green:
                return Qt.darker("#689A45", 1.0) // RAL 6018 Yellow green
            case OTL.TopLevelItem.Blue:
                return Qt.darker("#3172AD", 1.0) // RAL 5015 Sky blue
            case OTL.TopLevelItem.Yellow:
                return Qt.darker("#E8E253", 1.0) // RAL 1016 Sulfur yellow
            case OTL.TopLevelItem.Orange:
                return Qt.darker("#FF4612", 1.0) // RAL 2005 Luminous orange
            case OTL.TopLevelItem.Lilac:
                return Qt.darker("#746395", 1.0) // RAL 4005 Blue lilac
            }
        } else {
            switch (item.color) {
            case OTL.TopLevelItem.White:
                return Qt.darker("#EFEEE5", 1.0) // RAL 9010 Pure White
            case OTL.TopLevelItem.Red:
                return Qt.darker("#B92726", 1.0) // RAL 3028 Pure red
            case OTL.TopLevelItem.Green:
                return Qt.darker("#689A45", 1.0) // RAL 6018 Yellow green
            case OTL.TopLevelItem.Blue:
                return Qt.darker("#3172AD", 1.0) // RAL 5015 Sky blue
            case OTL.TopLevelItem.Yellow:
                return Qt.darker("#E8E253", 1.0) // RAL 1016 Sulfur yellow
            case OTL.TopLevelItem.Orange:
                return Qt.darker("#FFAD19",
                                 1.0) // RAL 2007 Luminous bright orange
            case OTL.TopLevelItem.Lilac:
                return Qt.darker("#746395", 1.0) // RAL 4005 Blue lilac
            }
        }
    }

    Settings {
        category: "Colors"

        property alias theme: root.theme
    }

    Binding {
        target: C.ColorTheme
        property: "theme"
        value: {
            switch (root.theme) {
                case root.lightTheme:
                {
                    return C.ColorTheme.Theme.Light
                }
                case root.darkTheme:
                {
                    return C.ColorTheme.Theme.Dark
                }
                case root.systemTheme:
                {
                    return C.ColorTheme.Theme.System
                }
            }
        }
    }
}
