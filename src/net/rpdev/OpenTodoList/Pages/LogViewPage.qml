import QtQuick 2.10
import QtQuick.Layouts 1.3

import net.rpdev.OpenTodoList as OTL

import net.rpdev.OpenTodoList.Components
import net.rpdev.OpenTodoList.Utils as Utils
import net.rpdev.OpenTodoList.Style as C

C.Page {
    id: page

    title: qsTr("Synchronization Log")

    property alias log: view.model

    function copyItem() {
        OTL.Application.copyToClipboard(JSON.stringify(page.log))
    }

    function scrollToTop() {
        view.positionViewAtBeginning()
    }

    function scrollToBottom() {
        view.positionViewAtEnd()
    }

    ListView {
        id: view

        anchors.fill: parent
        C.ScrollBar.vertical: C.ScrollBar {}
        spacing: Utils.AppSettings.mediumSpace

        delegate: RowLayout {
            width: view.width
            C.Symbol {
                symbol: {
                    switch (modelData.type) {
                    case OTL.Synchronizer.Debug:
                        return C.Icons.mdiInbox
                    case OTL.Synchronizer.Warning:
                        return C.Icons.mdiFeedback
                    case OTL.Synchronizer.Error:
                        return C.Icons.mdiError
                    case OTL.Synchronizer.Download:
                        return C.Icons.mdiDownload
                    case OTL.Synchronizer.Upload:
                        return C.Icons.mdiUpload
                    case OTL.Synchronizer.LocalMkDir:
                        return C.Icons.mdiFolder
                    case OTL.Synchronizer.RemoteMkDir:
                        return C.Icons.mdiDriveFolderUpload
                    case OTL.Synchronizer.LocalDelete:
                        return C.Icons.mdiDelete
                    case OTL.Synchronizer.RemoteDelete:
                        return C.Icons.mdiDeleteSweep
                    default:
                        return C.Icons.mdiHelpOutline
                    }
                }
                Layout.alignment: Qt.AlignTop

                C.ToolTip.text: {
                    switch (modelData.type) {
                    case OTL.Synchronizer.Debug:
                        return qsTr("Debugging information")
                    case OTL.Synchronizer.Warning:
                        return qsTr("Warning")
                    case OTL.Synchronizer.Error:
                        return qsTr("Error")
                    case OTL.Synchronizer.Download:
                        return qsTr("Download")
                    case OTL.Synchronizer.Upload:
                        return qsTr("Upload")
                    case OTL.Synchronizer.LocalMkDir:
                        return qsTr("Create local folder")
                    case OTL.Synchronizer.RemoteMkDir:
                        return qsTr("Create remote folder")
                    case OTL.Synchronizer.LocalDelete:
                        return qsTr("Deleting locally")
                    case OTL.Synchronizer.RemoteDelete:
                        return qsTr("Deleting remotely")
                    default:
                        return qsTr("Unknown log message type")
                    }
                }
            }

            C.Label {
                text: modelData.time
                Layout.maximumWidth: view.width / 4
                Layout.alignment: Qt.AlignTop
            }
            C.Label {
                Layout.fillWidth: true
                text: modelData.message
                Layout.alignment: Qt.AlignTop
            }
        }
    }
}
