import QtQuick 2.0

import OpenTodoList 1.0 as OTL

import OpenTodoList.Utils as Utils
import OpenTodoList.Style as C
import OpenTodoList.Menues as Menues
import OpenTodoList.Windows as W

C.Page {
    id: page

    property OTL.TopLevelItem topLevelItem: null

    property var selectColor: {
        if (topLevelItem) {
            return function () {
                colorMenu.popup()
            }
        } else {
            return null
        }
    }

    function openStackViewWindow(page, props) {
        rootObject.newStackViewWindow(page, props)
    }

    palette.button: d.accentColor
    palette.light: C.ColorTheme.getLightColorFromButtonColor(
                       palette.button, C.ColorTheme.isDarkColorScheme)
    palette.midlight: C.ColorTheme.getMidColorFromButtonColor(
                          palette.button, C.ColorTheme.isDarkColorScheme)
    palette.dark: C.ColorTheme.getDarkColorFromButtonColor(
                      palette.button, C.ColorTheme.isDarkColorScheme)
    palette.mid: C.ColorTheme.getMidColorFromButtonColor(
                     palette.button, C.ColorTheme.isDarkColorScheme)

    QtObject {
        id: d

        property color accentColor: page.topLevelItem && page.topLevelItem.color
                                    !== OTL.TopLevelItem.White ? Utils.Colors.itemColor(
                                                                     page.topLevelItem) : C.ColorTheme.selectedPalette.button

        function createPageSpecificColorPalette(basePalette, item, itemColor) {
            accentedPalette.basePalette = basePalette
            if (itemColor === OTL.TopLevelItem.White) {
                accentedPalette.accentColor = C.ColorTheme.selectedPalette.button
            } else {
                accentedPalette.accentColor = Utils.Colors.itemColor(item)
            }
            return accentedPalette
        }

        function updateColorPalette() {
            page.palette = C.ColorTheme.selectedPalette

            if (!page.topLevelItem) {
                return
            }

            if (page.topLevelItem.color === OTL.TopLevelItem.White) {
                return
            }

            accentedPalette.basePalette = C.ColorTheme.selectedPalette
            accentedPalette.accentColor = Utils.Colors.itemColor(
                        page.topLevelItem, C.ColorTheme.isDarkColorScheme)

            page.palette = accentedPalette
        }
    }

    Menues.ColorMenu {
        id: colorMenu
        item: topLevelItem
    }

    Component {
        id: stackViewWindow

        W.StackViewWindow {}
    }
}
