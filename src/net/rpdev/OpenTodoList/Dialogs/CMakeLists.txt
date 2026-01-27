qt_add_qml_module(opentodolist_dialogs_module
    STATIC
    URI net.rpdev.OpenTodoList.Dialogs
    QML_FILES
        FileDialog.qml
        FilesDialog.qml
    IMPORTS
        QtQuick
        QtQuick.Controls.Basic
)
