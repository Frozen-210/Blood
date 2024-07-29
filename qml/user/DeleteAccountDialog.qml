import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components"

Dialog {
    id: root
    title: "Delete Account"
    width: 400
    height: 250
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel
    signal accountDeleted()


    property string userEmail: ""  // Add this line

    background: Rectangle {
        color: theme.backgroundColor
        border.color: Material.Red
        border.width: 2
        radius: 10
    }

    header: Rectangle {
        color: Material.Red
        height: 50
        width: parent.width

        Label {
            anchors.centerIn: parent
            text: root.title
            color: "white"
            font: theme.headerFont
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Label {
            text: "Are you sure you want to delete your account? This action cannot be undone."
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            font: theme.bodyFont
        }

        TextField {
            id: deletePasswordField
            placeholderText: "Enter your password"
            echoMode: TextInput.Password
            Layout.fillWidth: true
            font: theme.bodyFont
        }
    }

    onAccepted: {
        var success = dbManager.userManager().deleteUser(userEmail, deletePasswordField.text)
        if (success) {
            accountDeleted()
        } else {
            showError(qsTr("Invalid"),qsTr("Failed to delete account. Please check your password."))
        }
    }
}
