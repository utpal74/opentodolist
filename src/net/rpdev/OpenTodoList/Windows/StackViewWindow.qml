import QtQuick

import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Components as Cmp
import net.rpdev.OpenTodoList.Widgets as W
import net.rpdev.OpenTodoList.Utils as U

AppWindow {
    id: window

    property alias stackView: stackView
    property alias deepLinkHandler: deepLinkHandler

    function openInitialPage(page, props) {
        stackView.clear()
        stackView.push(page, props)
    }

    width: 800
    height: 600
    title: qsTr("OpenTodoList") + " - " + applicationVersion

    header: Cmp.ApplicationToolBar {
        id: applicationToolBar

        stackView: stackView

        appMenu: appMenu
        appShortcuts: applicationShortcuts
        sidebarControl.visible: false

        backToolButton.visible: stackView?.depth > 1
        backToolButton.onClicked: stackView.goBack()
        problemsButton.visible: false

        Binding {
            target: applicationToolBar
            property: "title"
            value: stackView?.currentItem?.title ?? ""
        }
    }

    C.StackView {
        id: stackView

        anchors.fill: parent
    }

    W.ApplicationMenu {
        id: appMenu
        shortcuts: applicationShortcuts
    }

    Cmp.ApplicationShortcuts {
        id: applicationShortcuts

        stackView: stackView
        window: window
        isSecondaryWindow: true

        leftSidebar.enabled: false
    }

    U.DeepLinkHandler {
        id: deepLinkHandler
        stackView: stackView
    }
}
