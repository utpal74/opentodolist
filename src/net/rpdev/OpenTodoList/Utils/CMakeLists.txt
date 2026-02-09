set_source_files_properties(
        AppSettings.qml
        Colors.qml
        DateUtils.qml
        Markdown.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(opentodolist_utils_module
    STATIC
    URI net.rpdev.OpenTodoList.Utils
    QML_FILES
        Accounts.qml
        AppSettings.qml
        Colors.qml
        DateUtils.qml
        DeepLinkHandler.qml
        ItemUtils.qml
        Markdown.qml
        SortFilterModel.qml
    RESOURCES
        text-style.css
    IMPORTS
        QtQuick
        QtQuick.Controls.Basic
)

