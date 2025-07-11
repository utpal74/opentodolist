import QtQuick 2.12
import QtQuick.Layouts 1.0
import Qt.labs.qmlmodels 1.0
import QtQml.Models

import OpenTodoList.Style as C
import "../Utils" as Utils
import "../Widgets" as Widgets

import OpenTodoList 1.0 as OTL

C.ToolBar {
    id: headerToolBar

    property string title: ""
    property C.StackView stackView
    property Widgets.ApplicationMenu appMenu
    property ApplicationShortcuts appShortcuts

    property alias sidebarControl: sidebarControl
    property alias backToolButton: backToolButton
    property alias problemsButton: problemsButton

    padding: 4

    FontMetrics {
        id: fontMetrics
        font: pageTitleLabel.font
    }

    Column {
        width: parent.width
        spacing: 4

        RowLayout {
            id: toolBarLayout

            width: parent.width

            C.ToolButton {
                id: sidebarControl
                symbol: appShortcuts.leftSidebar.symbol
                down: appShortcuts.leftSidebar.checked
                flat: true
                textColor: palette.text
                onClicked: appShortcuts.leftSidebar.triggered()
                Layout.alignment: Qt.AlignVCenter
            }

            C.ToolButton {
                id: backToolButton

                flat: true
                textColor: palette.text
                symbol: {
                    switch (Qt.platform.os) {
                    case "ios":
                    case "macos":
                        return C.Icons.mdiArrowBackIosNew
                    default:
                        return C.Icons.mdiArrowBack
                    }
                }
                Layout.alignment: Qt.AlignVCenter
            }

            C.Label {
                id: pageTitleLabel
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                wrapMode: Text.NoWrap
                leftPadding: 10
                rightPadding: 10
                color: palette.text

                elide: Text.ElideRight
                text: headerToolBar.title
            }

            C.ToolButton {
                id: problemsButton

                symbol: C.Icons.mdiReportProblem
                highlighted: true
                Layout.alignment: Qt.AlignVCenter

                C.ToolTip.text: qsTr("Problems")
            }

            Repeater {
                model: appMenu.menus

                delegate: C.ToolButton {
                    //hoverEnabled: true
                    symbol: modelData.symbol
                    flat: true
                    textColor: headerToolBar.palette.text
                    menu: C.Menu {
                        id: menuFromAppMenu

                        property var appMenuEntry: modelData

                        title: modelData.title
                        modal: true
                        y: applicationToolBar.height
                        palette: C.ColorTheme.selectedPalette

                        Repeater {
                            model: menuFromAppMenu.appMenuEntry.items
                            delegate: DelegateChooser {
                                role: "type"

                                DelegateChoice {
                                    roleValue: "separator"
                                    C.MenuSeparator {
                                        visible: false
                                        height: 0
                                    }
                                }

                                DelegateChoice {
                                    roleValue: "item"
                                    C.MenuItem {
                                        text: modelData.text
                                        onTriggered: modelData.triggered()
                                        enabled: modelData.enabled
                                        visible: enabled
                                        height: visible ? implicitHeight : 0
                                    }
                                }
                            }
                        }
                    }
                    Layout.alignment: Qt.AlignVCenter
                    C.ToolTip.text: modelData.title
                }
            }
        }

        C.ProgressBar {
            id: progressBar

            width: parent.width
            height: 3
            from: 0
            to: 100
            value: {
                if (stackView?.syncRunning) {
                    // If a sync is running, report the current sync prograss as-is:
                    return stackView?.syncProgress ?? 0
                } else {
                    // Otherwise, always return 0:
                    return 0
                }
            }

            indeterminate: {
                if (stackView?.syncRunning ?? false) {
                    return (stackView?.syncProgress ?? 0) < 0
                } else {
                    // Also show indeterminate progress when cache accesses are queued:
                    return OTL.Application.cache.numberOfRunningTransactions > 0 ? 1.0 : 0.0
                }
            }

            // "Hide" the background so it blends with the toolbar
            background: Rectangle {
                height: 6
                color: headerToolBar.palette.button
            }
        }
    }
}
