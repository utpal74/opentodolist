pragma Singleton

import QtQuick
import QtCore

import net.rpdev.OpenTodoList as OTL

Item {
    id: colorPalette

    enum Theme {
        Light,
        Dark,
        System
    }

    property int theme: ColorTheme.Theme.Light


    /**
     * @brief A custom primary color to be used by default.
     */
    property color customPrimaryColor: "transparent"


    /**
     * @brief A custom secondary color to be used by default.
     */
    property color customSecondaryColor: "transparent"

    readonly property bool isDarkColorScheme: {
        switch (theme) {
            case ColorTheme.Theme.Light:
            {
                return false
            }
            case ColorTheme.Theme.Dark:
            {
                return true
            }
            case ColorTheme.Theme.System:
            {
                return OTL.ColorUtils.systemUsesDarkTheme
            }
        }
    }

    // Theme and accent colors:
    readonly property color asparagus: "#6A994E"
    readonly property color yellowGreen: "#A7C957"
    readonly property color parchment: "#F2E8CF"
    readonly property color bittersweetShimmer: "#BC4749"

    // Base colors light:
    readonly property color platinum: "#DBD9DB"
    readonly property color antiFlashWhite: "#E5EBEA"
    readonly property color eggshell: "#F4F1DE"

    // Base colors dark:
    readonly property color paynesGray: "#5A5E72"
    readonly property color charcoal: "#484B5B"
    readonly property color raisinBlack: "#272932"


    /**
     * @brief The primary color used by the light color scheme.
     */
    readonly property color lightThemePrimary: customPrimaryColor.a
                                               === 0 ? asparagus : customPrimaryColor


    /**
     * @brief The secondary color used by the light color scheme.
     */
    readonly property color lightThemeSecondary: customSecondaryColor.a
                                                 === 0 ? bittersweetShimmer : customSecondaryColor


    /**
     * @brief The primary color used by the dark color scheme.
     */
    readonly property color darkThemePrimary: customPrimaryColor.a
                                              === 0 ? yellowGreen : customPrimaryColor


    /**
     * @brief The secondary color used by the dark color scheme.
     */
    readonly property color darkThemeSecondary: customSecondaryColor.a
                                                === 0 ? bittersweetShimmer : customSecondaryColor

    // A light color palette, based on the theme colors:
    readonly property var lightColorPalete: Palette {

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Central roles
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A general background color.
        window: colorPalette.eggshell

        // A general foreground color.
        windowText: colorPalette.raisinBlack

        // Used mostly as the background color for text entry widgets, but can also be used for
        // other painting - such as the background of combobox drop down lists and toolbar handles. It
        //is usually white or another light color.
        base: colorPalette.parchment

        // Used as the alternate background color in views with alternating row colors (see
        // QAbstractItemView::setAlternatingRowColors()).
        alternateBase: colorPalette.platinum

        // Used as the background color for QToolTip and QWhatsThis. Tool tips use the Inactive
        // color group of QPalette, because tool tips are not active windows.
        toolTipBase: colorPalette.eggshell

        // Used as the foreground color for QToolTip and QWhatsThis. Tool tips use the Inactive
        // color group of QPalette, because tool tips are not active windows.
        toolTipText: colorPalette.raisinBlack

        // Used as the placeholder color for various text input widgets. This enum value has been
        // introduced in Qt 5.12
        placeholderText: colorPalette.paynesGray

        // The foreground color used with Base. This is usually the same as the WindowText, in
        // which case it must provide good contrast with Window and Base.
        text: colorPalette.raisinBlack

        // The general button background color. This background can be different from Window as
        // some styles require a different background color for buttons.
        button: colorPalette.lightThemePrimary

        // A foreground color used with the Button color.
        buttonText: colorPalette.textColorForBackgroundColor(colorPalette.lightThemePrimary)

        // A text color that is very different from WindowText, and contrasts well with e.g. Dark.
        // Typically used for text that needs to be drawn where Text or WindowText would give poor
        // contrast, such as on pressed push buttons. Note that text colors can be used for things
        // other than just words; text colors are usually used for text, but it's quite common to
        // use the text color roles for lines, icons, etc.
        brightText: colorPalette.textColorForBackgroundColor(
            colorPalette.getDarkColorFromButtonColor(
                colorPalette.lightThemePrimary, false))

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Used for painting 3D bevels and shadow effects.
        ////////////////////////////////////////////////////////////////////////////////////////////

        // Lighter than Button color.
        light: colorPalette.getLightColorFromButtonColor(colorPalette.lightThemePrimary, false)

        // Between Button and Light.
        midlight: colorPalette.getMidColorFromButtonColor(colorPalette.lightThemePrimary, false)

        // Darker than Button.
        dark: colorPalette.getDarkColorFromButtonColor(colorPalette.lightThemePrimary, false)

        // Between Button and Dark.
        mid: colorPalette.getMidColorFromButtonColor(colorPalette.lightThemePrimary, false)

        // A very dark color. By default, the shadow color is Qt::black.
        shadow: colorPalette.raisinBlack

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Selected/marked items
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A color to indicate a selected item or the current item. By default, the highlight color
        // is Qt::darkBlue.
        highlight: colorPalette.lightThemeSecondary

        // A color that typically contrasts or complements Base, Window and Button colors. It
        // usually represents the users' choice of desktop personalisation. Styling of interactive
        // components is a typical use case. Unless explicitly set, it defaults to Highlight.
        accent: colorPalette.lightThemeSecondary

        // A text color that contrasts with Highlight. By default, the highlighted text color is
        // Qt::white.
        highlightedText: colorPalette.textColorForBackgroundColor(colorPalette.lightThemeSecondary)

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Link colors
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A text color used for unvisited hyperlinks. By default, the link color is Qt::blue.
        link: colorPalette.lightThemeSecondary

        // A text color used for already visited hyperlinks. By default, the linkvisited color
        // is Qt::magenta.
        linkVisited: colorPalette.lightThemeSecondary
    }

    readonly property var darkColorPalette: Palette {

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Central roles
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A general background color.
        window: colorPalette.raisinBlack

        // A general foreground color.
        windowText: colorPalette.antiFlashWhite

        // Used mostly as the background color for text entry widgets, but can also be used for
        // other painting - such as the background of combobox drop down lists and toolbar handles. It
        //is usually white or another light color.
        base: colorPalette.charcoal

        // Used as the alternate background color in views with alternating row colors (see
        // QAbstractItemView::setAlternatingRowColors()).
        alternateBase: colorPalette.paynesGray

        // Used as the background color for QToolTip and QWhatsThis. Tool tips use the Inactive
        // color group of QPalette, because tool tips are not active windows.
        toolTipBase: colorPalette.raisinBlack

        // Used as the foreground color for QToolTip and QWhatsThis. Tool tips use the Inactive
        // color group of QPalette, because tool tips are not active windows.
        toolTipText: colorPalette.antiFlashWhite

        // Used as the placeholder color for various text input widgets. This enum value has been
        // introduced in Qt 5.12
        placeholderText: colorPalette.platinum

        // The foreground color used with Base. This is usually the same as the WindowText, in
        // which case it must provide good contrast with Window and Base.
        text: colorPalette.antiFlashWhite

        // The general button background color. This background can be different from Window as
        // some styles require a different background color for buttons.
        button: colorPalette.darkThemePrimary

        // A foreground color used with the Button color.
        buttonText: colorPalette.textColorForBackgroundColor(colorPalette.darkThemePrimary)

        // A text color that is very different from WindowText, and contrasts well with e.g. Dark.
        // Typically used for text that needs to be drawn where Text or WindowText would give poor
        // contrast, such as on pressed push buttons. Note that text colors can be used for things
        // other than just words; text colors are usually used for text, but it's quite common to
        // use the text color roles for lines, icons, etc.
        brightText: colorPalette.textColorForBackgroundColor(
            colorPalette.getDarkColorFromButtonColor(
                colorPalette.darkThemePrimary, true))

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Used for painting 3D bevels and shadow effects.
        ////////////////////////////////////////////////////////////////////////////////////////////

        // Lighter than Button color.
        light: colorPalette.getLightColorFromButtonColor(colorPalette.darkThemePrimary, true)

        // Between Button and Light.
        midlight: colorPalette.getMidColorFromButtonColor(colorPalette.darkThemePrimary, true)

        // Darker than Button.
        dark: colorPalette.getDarkColorFromButtonColor(colorPalette.darkThemePrimary, true)

        // Between Button and Dark.
        mid: colorPalette.getMidColorFromButtonColor(colorPalette.darkThemePrimary, true)

        // A very dark color. By default, the shadow color is Qt::black.
        shadow: colorPalette.antiFlashWhite

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Selected/marked items
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A color to indicate a selected item or the current item. By default, the highlight color
        // is Qt::darkBlue.
        highlight: colorPalette.darkThemeSecondary

        // A color that typically contrasts or complements Base, Window and Button colors. It
        // usually represents the users' choice of desktop personalisation. Styling of interactive
        // components is a typical use case. Unless explicitly set, it defaults to Highlight.
        accent: colorPalette.darkThemeSecondary

        // A text color that contrasts with Highlight. By default, the highlighted text color is
        // Qt::white.
        highlightedText: colorPalette.textColorForBackgroundColor(colorPalette.darkThemeSecondary)

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Link colors
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A text color used for unvisited hyperlinks. By default, the link color is Qt::blue.
        link: colorPalette.darkThemeSecondary

        // A text color used for already visited hyperlinks. By default, the linkvisited color
        // is Qt::magenta.
        linkVisited: colorPalette.darkThemeSecondary
    }

    function isDarkColor(color) {
        // Force conversion to color:
        let tmp = Qt.darker(color, 1)
        return tmp.hslLightness < 0.5
    }

    function textColorForBackgroundColor(color) {
        if (isDarkColor(color)) {
            return antiFlashWhite
        } else {
            return raisinBlack
        }
    }

    function getLightColorFromButtonColor(color, dark) {
        if (dark) {
            return Qt.darker(color, 1.5)
        } else {
            return Qt.lighter(color, 1.5)
        }
    }

    function getMidlightColorFromButtonColor(color, dark) {
        if (dark) {
            return Qt.darker(color, 1.25)
        } else {
            return Qt.lighter(color, 1.25)
        }
    }

    function getMidColorFromButtonColor(color, dark) {
        if (dark) {
            return Qt.lighter(color, 1.25)
        } else {
            return Qt.darker(color, 1.25)
        }
    }

    function getDarkColorFromButtonColor(color, dark) {
        if (dark) {
            return Qt.lighter(color, 1.5)
        } else {
            return Qt.darker(color, 1.5)
        }
    }

    readonly property var selectedPalette: {
        switch (theme) {
            case ColorTheme.Theme.Light:
            return lightColorPalete
            case ColorTheme.Theme.Dark:
            return darkColorPalette
            default:
            if (OTL.ColorUtils.systemUsesDarkTheme) {
                return darkColorPalette
            } else {
                return lightColorPalete
            }
        }
    }

    onCustomPrimaryColorChanged: settings.customPrimaryColor = customPrimaryColor
    onCustomSecondaryColorChanged: settings.customSecondaryColor = customSecondaryColor
    Component.onCompleted: {
        customPrimaryColor = settings.customPrimaryColor
        customSecondaryColor = settings.customSecondaryColor
    }

    Settings {
        id: settings

        category: "OpenTodoList/Style/ColorTheme"

        property color customPrimaryColor: "transparent"
        property color customSecondaryColor: "transparent"
    }
}
