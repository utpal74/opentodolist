import QtQuick
import net.rpdev.OpenTodoList.Style as Style

Palette {
    id: palette

    property Palette basePalette: Style.ColorTheme.selectedPalette
    property color accentColor: basePalette.accent

    button: palette.accentColor
    window: basePalette.window
    windowText: basePalette.windowText
    base: basePalette.base
    alternateBase: basePalette.alternateBase
    toolTipBase: basePalette.toolTipBase
    toolTipText: basePalette.toolTipText
    placeholderText: basePalette.placeholderText
    text: basePalette.text
    buttonText: basePalette.buttonText
    brightText: basePalette.brightText
    shadow: basePalette.shadow
    highlight: basePalette.highlight
    accent: basePalette.accent
    highlightedText: basePalette.highlightedText
    link: basePalette.link
    linkVisited: basePalette.linkVisited

    dark: Style.ColorTheme.getDarkColorFromButtonColor(palette.button, Style.ColorTheme.isDarkColorScheme)
    light: Style.ColorTheme.getLightColorFromButtonColor(palette.button, Style.ColorTheme.isDarkColorScheme)
    mid: Style.ColorTheme.getMidColorFromButtonColor(palette.button, Style.ColorTheme.isDarkColorScheme)
    midlight: Style.ColorTheme.getMidColorFromButtonColor(palette.button, Style.ColorTheme.isDarkColorScheme)
}
