/*
 * Copyright 2020, 2021 Martin Hoeher <martin@rpdev.net>
 +
 * This file is part of OpenTodoList.
 *
 * OpenTodoList is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version.
 *
 * OpenTodoList is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OpenTodoList.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QQmlExtensionPlugin>

#include "appstartup.h"

// Explicitly link against sub-qml plugin modules to ensure they are
// not eliminated by the linker (see
// https://www.basyskom.de/en/how-to-use-modern-qml-tooling-in-practice/):
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_ActionsPlugin)
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_ComponentsPlugin)
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_DialogsPlugin)
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_MenuesPlugin)
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_StylePlugin)
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_UtilsPlugin)
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_WidgetsPlugin)
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_WindowsPlugin)
Q_IMPORT_QML_PLUGIN(net_rpdev_OpenTodoList_PagesPlugin)

int main(int argc, char* argv[])
{
    qWarning() << "Entered main";
#ifdef OPENTODOLIST_FLATPAK
    {
        auto xdgRuntimeDir = qgetenv("XDG_RUNTIME_DIR");
        qputenv("TMPDIR", xdgRuntimeDir + "/app/net.rpdev.OpenTodoList");
    }
#endif
#ifdef Q_OS_IOS
    // WA for https://bugreports.qt.io/browse/QTBUG-109737:
    qputenv("QML_NO_TOUCH_COMPRESSION", "1");
#endif
    AppStartup appStartup;
    qWarning() << "Starting app";
    return appStartup.exec(argc, argv);
}
