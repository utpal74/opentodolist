import QtQuick 2.0
import QtQuick.Layouts 1.3

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Style as C
import net.rpdev.OpenTodoList.Utils
import net.rpdev.OpenTodoList.Windows
import net.rpdev.OpenTodoList.Dialogs as Dialogs

Item {
    id: item

    function attach() {
        dialog.open()
    }

    function attachFiles(fileUrls) {
        for (var i = 0; i < fileUrls.length; ++i) {
            item.item.attachFile(OTL.Application.urlFromString(fileUrls[i]))
        }
    }

    property OTL.ComplexItem item

    height: childrenRect.height

    OTL.ShareUtils {
        id: shareUtils
    }

    Dialogs.FilesDialog {
        id: dialog

        title: qsTr("Attach File")

        onAccepted: {
            for (var i = 0; i < selectedFiles.length; ++i) {
                item.item.attachFile(OTL.Application.urlFromString(
                                         selectedFiles[i]))
            }
        }
    }

    CenteredDialog {
        id: confirmDeleteAttachmentDialog

        property string attachment

        title: qsTr("Delete Attachment?")
        width: 400

        C.Label {
            text: qsTr("Are you sure you want to delete the attachment <strong>%1</strong>? This action " + "cannot be undone.").arg(
                      confirmDeleteAttachmentDialog.attachment)
            width: parent.width
        }
        standardButtons: C.Dialog.Ok | C.Dialog.Cancel
        onAccepted: {
            item.item.detachFile(attachment)
        }
    }

    Heading {
        id: header

        level: 2
        text: qsTr("Attachments")
        visible: item.item?.attachments.length > 0 ?? false
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
            top: header.bottom
        }
        Repeater {
            model: item.item?.attachments ?? []
            delegate: MouseArea {
                width: parent.width
                height: childrenRect.height
                onClicked: shareUtils.openFile(item.item.attachmentFileName(
                                                   modelData))

                RowLayout {
                    width: parent.width

                    C.Label {
                        text: modelData
                        Layout.fillWidth: true
                    }

                    C.Symbol {
                        symbol: C.Icons.mdiDelete
                        onClicked: {
                            confirmDeleteAttachmentDialog.attachment = modelData
                            confirmDeleteAttachmentDialog.open()
                        }
                    }
                }
            }
        }
    }
}
