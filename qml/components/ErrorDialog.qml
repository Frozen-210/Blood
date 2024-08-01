import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


    // Custom ErrorDialog component
    // This dialog will be used to display error messages
    Dialog {
        id: errorDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        property alias errorMessage: messageText.text
        property alias errorTitle: titleText.text

        // Style the dialog background
        background: Rectangle {
            color: theme.backgroundColor
            border.color: theme.primaryColor
            border.width: 2
            radius: 10
        }

        // Content of the error dialog
        ColumnLayout {
            spacing: 15
            width: parent.width


            // Error title
            Text {
                id: titleText
                font: theme.headerFont
                color: theme.primaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            // Error message
            Text {
                id: messageText
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font: theme.bodyFont
                color: theme.textColor
                Layout.fillWidth: true
            }

            // OK button to close the dialog
            Button {
                text: qsTr("OK")
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 100
                onClicked: errorDialog.close()

                contentItem: Text {
                    text: parent.text
                    font: theme.buttonFont
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.down ? Qt.darker(theme.accentColor, 1.2) : theme.accentColor
                    radius: 5
                }
            }
        }
    }
