import QtQuick 2.0

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Menues as Menues
import net.rpdev.OpenTodoList.Windows as W

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

    palette: C.ColorTheme.getAccentedPalette(d.accentColor, C.ColorTheme.selectedPalette, page)

    QtObject {
        id: d

        property color accentColor: page.topLevelItem && page.topLevelItem.color
                                    !== OTL.TopLevelItem.White ? Utils.Colors.itemColor(
                                                                     page.topLevelItem) : C.ColorTheme.selectedPalette.button
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
