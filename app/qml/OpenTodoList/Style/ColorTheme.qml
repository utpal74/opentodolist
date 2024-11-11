pragma Singleton

import QtQuick
import QtCore

import OpenTodoList as OTL

Item {
    id: palette

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
                return OTL.Colors.systemUsesDarkTheme
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
        window: eggshell

        // A general foreground color.
        windowText: raisinBlack

        // Used mostly as the background color for text entry widgets, but can also be used for
        // other painting - such as the background of combobox drop down lists and toolbar handles. It
        //is usually white or another light color.
        base: parchment

        // Used as the alternate background color in views with alternating row colors (see
        // QAbstractItemView::setAlternatingRowColors()).
        alternateBase: platinum

        // Used as the background color for QToolTip and QWhatsThis. Tool tips use the Inactive
        // color group of QPalette, because tool tips are not active windows.
        toolTipBase: eggshell

        // Used as the foreground color for QToolTip and QWhatsThis. Tool tips use the Inactive
        // color group of QPalette, because tool tips are not active windows.
        toolTipText: raisinBlack

        // Used as the placeholder color for various text input widgets. This enum value has been
        // introduced in Qt 5.12
        placeholderText: paynesGray

        // The foreground color used with Base. This is usually the same as the WindowText, in
        // which case it must provide good contrast with Window and Base.
        text: raisinBlack

        // The general button background color. This background can be different from Window as
        // some styles require a different background color for buttons.
        button: lightThemePrimary

        // A foreground color used with the Button color.
        buttonText: textColorForBackgroundColor(lightThemePrimary)

        // A text color that is very different from WindowText, and contrasts well with e.g. Dark.
        // Typically used for text that needs to be drawn where Text or WindowText would give poor
        // contrast, such as on pressed push buttons. Note that text colors can be used for things
        // other than just words; text colors are usually used for text, but it's quite common to
        // use the text color roles for lines, icons, etc.
        brightText: textColorForBackgroundColor(getDarkColorFromButtonColor(
                                                    lightThemePrimary, false))

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Used for painting 3D bevels and shadow effects.
        ////////////////////////////////////////////////////////////////////////////////////////////

        // Lighter than Button color.
        light: getLightColorFromButtonColor(lightThemePrimary, false)

        // Between Button and Light.
        midlight: getMidColorFromButtonColor(lightThemePrimary, false)

        // Darker than Button.
        dark: getDarkColorFromButtonColor(lightThemePrimary, false)

        // Between Button and Dark.
        mid: getMidColorFromButtonColor(lightThemePrimary, false)

        // A very dark color. By default, the shadow color is Qt::black.
        shadow: raisinBlack

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Selected/marked items
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A color to indicate a selected item or the current item. By default, the highlight color
        // is Qt::darkBlue.
        highlight: lightThemeSecondary

        // A color that typically contrasts or complements Base, Window and Button colors. It
        // usually represents the users' choice of desktop personalisation. Styling of interactive
        // components is a typical use case. Unless explicitly set, it defaults to Highlight.
        accent: lightThemeSecondary

        // A text color that contrasts with Highlight. By default, the highlighted text color is
        // Qt::white.
        highlightedText: textColorForBackgroundColor(lightThemeSecondary)

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Link colors
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A text color used for unvisited hyperlinks. By default, the link color is Qt::blue.
        link: lightThemeSecondary

        // A text color used for already visited hyperlinks. By default, the linkvisited color
        // is Qt::magenta.
        linkVisited: lightThemeSecondary
    }

    readonly property var darkColorPalete: Palette {

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Central roles
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A general background color.
        window: raisinBlack

        // A general foreground color.
        windowText: antiFlashWhite

        // Used mostly as the background color for text entry widgets, but can also be used for
        // other painting - such as the background of combobox drop down lists and toolbar handles. It
        //is usually white or another light color.
        base: charcoal

        // Used as the alternate background color in views with alternating row colors (see
        // QAbstractItemView::setAlternatingRowColors()).
        alternateBase: paynesGray

        // Used as the background color for QToolTip and QWhatsThis. Tool tips use the Inactive
        // color group of QPalette, because tool tips are not active windows.
        toolTipBase: raisinBlack

        // Used as the foreground color for QToolTip and QWhatsThis. Tool tips use the Inactive
        // color group of QPalette, because tool tips are not active windows.
        toolTipText: antiFlashWhite

        // Used as the placeholder color for various text input widgets. This enum value has been
        // introduced in Qt 5.12
        placeholderText: platinum

        // The foreground color used with Base. This is usually the same as the WindowText, in
        // which case it must provide good contrast with Window and Base.
        text: antiFlashWhite

        // The general button background color. This background can be different from Window as
        // some styles require a different background color for buttons.
        button: darkThemePrimary

        // A foreground color used with the Button color.
        buttonText: textColorForBackgroundColor(darkThemePrimary)

        // A text color that is very different from WindowText, and contrasts well with e.g. Dark.
        // Typically used for text that needs to be drawn where Text or WindowText would give poor
        // contrast, such as on pressed push buttons. Note that text colors can be used for things
        // other than just words; text colors are usually used for text, but it's quite common to
        // use the text color roles for lines, icons, etc.
        brightText: textColorForBackgroundColor(getDarkColorFromButtonColor(
                                                    darkThemePrimary, true))

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Used for painting 3D bevels and shadow effects.
        ////////////////////////////////////////////////////////////////////////////////////////////

        // Lighter than Button color.
        light: getLightColorFromButtonColor(darkThemePrimary, true)

        // Between Button and Light.
        midlight: getMidColorFromButtonColor(darkThemePrimary, true)

        // Darker than Button.
        dark: getDarkColorFromButtonColor(darkThemePrimary, true)

        // Between Button and Dark.
        mid: getMidColorFromButtonColor(darkThemePrimary, true)

        // A very dark color. By default, the shadow color is Qt::black.
        shadow: antiFlashWhite

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Selected/marked items
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A color to indicate a selected item or the current item. By default, the highlight color
        // is Qt::darkBlue.
        highlight: darkThemeSecondary

        // A color that typically contrasts or complements Base, Window and Button colors. It
        // usually represents the users' choice of desktop personalisation. Styling of interactive
        // components is a typical use case. Unless explicitly set, it defaults to Highlight.
        accent: darkThemeSecondary

        // A text color that contrasts with Highlight. By default, the highlighted text color is
        // Qt::white.
        highlightedText: textColorForBackgroundColor(darkThemeSecondary)

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Link colors
        ////////////////////////////////////////////////////////////////////////////////////////////

        // A text color used for unvisited hyperlinks. By default, the link color is Qt::blue.
        link: darkThemeSecondary

        // A text color used for already visited hyperlinks. By default, the linkvisited color
        // is Qt::magenta.
        linkVisited: darkThemeSecondary
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
            return darkColorPalete
            default:
            if (OTL.Colors.systemUsesDarkTheme) {
                return darkColorPalete
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
