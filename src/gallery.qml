import QtQuick 2.10
import net.rpdev.OpenTodoList.Style

ApplicationWindow {
    id: window

    width: 800
    height: 600
    palette: ColorTheme.selectedPalette
    font.family: Fonts.regularFont
    font.weight: 500

    menuBar: MenuBar {
        Menu {
            title: "Theme"

            MenuItem {
                text: "Light"
                onTriggered: ColorTheme.theme = ColorTheme.Theme.Light
            }
            MenuItem {
                text: "Dark"
                onTriggered: ColorTheme.theme = ColorTheme.Theme.Dark
            }
            MenuItem {
                text: "System"
                onTriggered: ColorTheme.theme = ColorTheme.Theme.System
            }
        }

        Menu {
            title: "Font"

            Repeater {
                model: [300, 400, 500, 600, 700]
                delegate: MenuItem {
                    text: "%1".arg(modelData)
                    onTriggered: window.font.weight = modelData
                }
            }
        }
    }

    Component.onCompleted: show()

    component DemoColumn: Column {
        spacing: 16
    }

    ScrollView {
        id: scrollView

        anchors.fill: parent

        Flow {
            width: scrollView.availableWidth
            height: childrenRect.height
            spacing: 32
            padding: 32

            DemoColumn {

                Button {
                    text: "A button (with tooltip)"

                    ToolTip.text: "Hello World"
                    ToolTip.delay: 500
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                }

                Button {
                    text: "A highlighted button"
                    highlighted: true
                }
                Button {
                    text: "A checked button"
                    checked: true
                }

                Button {
                    text: "A disabled button"
                    enabled: false
                }
            }

            DemoColumn {
                CheckBox {
                    text: "Unchecked"
                }
                CheckBox {
                    text: "Checked"
                    checked: true
                }
                CheckBox {
                    text: "Disabled"
                    enabled: false
                }
            }

            DemoColumn {
                Switch {
                    text: "Unchecked"
                }
                Switch {
                    text: "Checked"
                    checked: true
                }
                Switch {
                    text: "Disabled"
                    enabled: false
                }
            }

            DemoColumn {
                TextField {
                    text: "Hello World"
                }
                TextField {
                    placeholderText: "I am a place holder"
                }
                TextArea {
                    text: "Hello\nWorld"
                }
                TextArea {
                    placeholderText: "Another placeholder"
                }
            }

            DemoColumn {
                ItemDelegate {
                    text: "An Item"
                }
                ItemDelegate {
                    text: "An disabled Item"
                    enabled: false
                }
            }

            DemoColumn {
                CheckDelegate {
                    text: "A checkable item"
                }
                CheckDelegate {
                    text: "Another checkable item"
                    checked: true
                }
                CheckDelegate {
                    text: "Another checkable item"
                    enabled: false
                }
            }

            DemoColumn {
                SwitchDelegate {
                    text: "A checkable item"
                }
                SwitchDelegate {
                    text: "Another checkable item"
                    checked: true
                }
                SwitchDelegate {
                    text: "Another checkable item"
                    enabled: false
                }
            }

            DemoColumn {
                RoundButton {
                    text: "+"
                }
                RoundButton {
                    text: "+"
                    highlighted: true
                }
                RoundButton {
                    text: "+"
                    checked: true
                }
                RoundButton {
                    text: "+"
                    enabled: false
                }
            }

            DemoColumn {
                ToolBar {
                    Row {
                        ToolButton {
                            symbol: "+"
                        }
                        ToolButton {
                            symbol: "+"
                            highlighted: true
                        }
                        ToolButton {
                            symbol: "+"
                            checked: true
                        }
                        ToolButton {
                            symbol: "+"
                            enabled: false
                        }
                        ToolButton {
                            symbol: "+"
                            flat: true
                        }
                    }
                }
                ToolBar {
                    Row {
                        ToolButton {
                            symbol: "+"
                            text: "Add"
                        }
                        ToolButton {
                            symbol: "+"
                            text: "Add"
                            highlighted: true
                        }
                        ToolButton {
                            symbol: "+"
                            text: "Add"
                            checked: true
                        }
                        ToolButton {
                            symbol: "+"
                            text: "Add"
                            enabled: false
                        }
                        ToolButton {
                            symbol: "+"
                            text: "Add"
                            flat: true
                        }
                    }
                }
                ToolBar {
                    Row {
                        ToolButton {
                            text: "Add"
                        }
                        ToolButton {
                            text: "Add"
                            highlighted: true
                        }
                        ToolButton {
                            text: "Add"
                            checked: true
                        }
                        ToolButton {
                            text: "Add"
                            enabled: false
                        }
                        ToolButton {
                            text: "Add"
                            flat: true
                        }
                    }
                }
            }

            DemoColumn {
                component ColorPatch: Row {
                    id: colorPatch

                    property string name: ""
                    property color color: "white"

                    Label {
                        width: 300
                        text: colorPatch.name
                    }

                    Rectangle {
                        width: 32
                        height: 32
                        color: colorPatch.color
                        border.width: 1
                        border.color: "black"
                    }
                }

                ColorPatch {
                    name: "window"
                    color: ColorTheme.selectedPalette.window
                }

                ColorPatch {
                    name: "windowText"
                    color: ColorTheme.selectedPalette.windowText
                }

                ColorPatch {
                    name: "base"
                    color: ColorTheme.selectedPalette.base
                }

                ColorPatch {
                    name: "alternateBase"
                    color: ColorTheme.selectedPalette.alternateBase
                }

                ColorPatch {
                    name: "toolTipBase"
                    color: ColorTheme.selectedPalette.toolTipBase
                }

                ColorPatch {
                    name: "toolTipText"
                    color: ColorTheme.selectedPalette.toolTipText
                }

                ColorPatch {
                    name: "placeholderText"
                    color: ColorTheme.selectedPalette.placeholderText
                }

                ColorPatch {
                    name: "text"
                    color: ColorTheme.selectedPalette.text
                }

                ColorPatch {
                    name: "button"
                    color: ColorTheme.selectedPalette.button
                }

                ColorPatch {
                    name: "buttonText"
                    color: ColorTheme.selectedPalette.buttonText
                }

                ColorPatch {
                    name: "brightText"
                    color: ColorTheme.selectedPalette.brightText
                }

                ColorPatch {
                    name: "light"
                    color: ColorTheme.selectedPalette.light
                }

                ColorPatch {
                    name: "midlight"
                    color: ColorTheme.selectedPalette.midlight
                }

                ColorPatch {
                    name: "dark"
                    color: ColorTheme.selectedPalette.dark
                }

                ColorPatch {
                    name: "mid"
                    color: ColorTheme.selectedPalette.mid
                }

                ColorPatch {
                    name: "shadow"
                    color: ColorTheme.selectedPalette.shadow
                }

                ColorPatch {
                    name: "highlight"
                    color: ColorTheme.selectedPalette.highlight
                }

                ColorPatch {
                    name: "accent"
                    color: ColorTheme.selectedPalette.accent
                }

                ColorPatch {
                    name: "highlightedText"
                    color: ColorTheme.selectedPalette.highlightedText
                }

                ColorPatch {
                    name: "link"
                    color: ColorTheme.selectedPalette.link
                }

                ColorPatch {
                    name: "linkVisited"
                    color: ColorTheme.selectedPalette.linkVisited
                }
            }
        }
    }
}
