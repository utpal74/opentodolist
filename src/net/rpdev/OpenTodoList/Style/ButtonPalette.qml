import QtQuick
import net.rpdev.OpenTodoList.Style as Style

Palette {
    id: palette

    property Palette basePalette: Style.ColorTheme.selectedPalette

    button: basePalette.button
    window: basePalette.window
    windowText: basePalette.windowText
    base: basePalette.base
    alternateBase: basePalette.alternateBase
    toolTipBase: basePalette.toolTipBase
    toolTipText: basePalette.toolTipText
    placeholderText: basePalette.placeholderText
    text: Style.ColorTheme.textColorForBackgroundColor(basePalette.button)
    buttonText: basePalette.buttonText
    brightText: basePalette.brightText
    shadow: basePalette.shadow
    highlight: basePalette.highlight
    accent: basePalette.accent
    highlightedText: basePalette.highlightedText
    link: basePalette.link
    linkVisited: basePalette.linkVisited
    dark: basePalette.dark
    light: basePalette.light
    mid: basePalette.mid
    midlight: basePalette.midlight
}
