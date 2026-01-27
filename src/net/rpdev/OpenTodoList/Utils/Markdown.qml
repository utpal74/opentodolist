pragma Singleton

import QtQuick 2.0

import net.rpdev.OpenTodoList as OTL
import net.rpdev.OpenTodoList.Style as C

Item {
    id: root

    property OTL.SyntaxHighlighter syntaxHighlighter: OTL.SyntaxHighlighter {
        theme: C.ColorTheme.isDarkColorScheme ? OTL.SyntaxHighlighter.Dark : OTL.SyntaxHighlighter.Light
    }

    readonly property string stylesheet: generateStylesheet(
                                             C.ColorTheme.selectedPalette, true)

    readonly property string stylesheetContent: generateStylesheet(
                                                    C.ColorTheme.selectedPalette)

    function generateStylesheet(palette, full, linkColor) {
        let template = OTL.Application.loadFile(Qt.resolvedUrl(
                                                    "./text-style.css"))
        let negativeColor = Colors.negativeColor

        if (linkColor === undefined || linkColor === null) {
            if (palette !== null && palette !== undefined) {
                // Pick a suitable link color. If possible, use the button color, but it it yields
                // a too bad contrast, use something else:
                linkColor = palette.button
                if (Math.abs(linkColor.hslLightness - palette.window.hslLightness) < 0.4) {
                    linkColor = palette.dark
                    if (Math.abs(linkColor.hslLightness - palette.window.hslLightness) < 0.4) {
                        linkColor = palette.light
                        if (Math.abs(linkColor.hslLightness - palette.window.hslLightness) < 0.4) {
                            // Last resort: Use text color and tint it with the button color:
                            let tintColor = palette.button
                            tintColor.a = 0.5
                            linkColor = Qt.tint(palette.text, tintColor)
                        }
                    }
                }
            }
        }
        template = template.arg(linkColor).arg(negativeColor).arg(
                    C.Fonts.titleFont).arg(C.Fonts.monoFont)
        if (full) {
            return "<style type='text/css' rel='stylesheet'>" + template + "</style>"
        } else {
            return template
        }
    }

    function markdownToHtml(text, palette, linkColor) {
        if (text === "" || !text) {
            return ""
        }
        let css = stylesheetContent
        if (palette !== null && palette !== undefined) {
            css = generateStylesheet(palette, null, linkColor)
        } else if (linkColor !== undefined && linkColor !== null) {
            css = generateStylesheet(null, null, linkColor)
        }

        return textUtils.markdownToHtml(text, css, syntaxHighlighter)
    }

    function markdownToPlainText(text) {
        return textUtils.htmlToPlainText(textUtils.markdownToHtml(text))
    }


    /*
      Returns the first non-empty plain text line from the markdown text.
     */
    function firstPlainTextLineFromMarkdown(markdown) {
        let plain = markdownToPlainText(markdown)
        let lines = plain.split(/\r?\n/)
        for (var i = 0; i < lines.length; ++i) {
            let line = lines[i]
            if (line.length > 0) {
                return line
            }
        }
        return ""
    }

    OTL.TextUtils {
        id: textUtils
    }
}
