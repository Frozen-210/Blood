import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    background: Rectangle {
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, 400)
        spacing: 20

        Label {
            text: qsTr("User Login")
            font: theme.headerFont
            color: theme.primaryColor
            Layout.alignment: Qt.AlignHCenter
        }

        CustomTextField {
            id: emailField
            placeholderText: qsTr("Email")
            Layout.fillWidth: true
        }

        CustomTextField {
            id: passwordField
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            Layout.fillWidth: true
        }

        CustomButton {
            text: qsTr("Login")
            Layout.fillWidth: true
            onClicked: login()
        }

        Label {
            text: qsTr("Don't have an account? Sign up")
            color: theme.accentColor
            font: theme.bodyFont
            Layout.alignment: Qt.AlignHCenter
            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push("../auth/UserSignupPage.qml")
            }
        }
    }

    function login() {
        busyIndicator.running = true
        var success = dbManager.userManager().userLogin(emailField.text, passwordField.text)
        busyIndicator.running = false

        if (success) {
            var userData = dbManager.userManager().getUserData(emailField.text)
            stackView.push("../user/UserDashboardPage.qml", {userEmail: emailField.text, userData: userData})
        } else {
            showError("Login failed. Please check your credentials.")
        }
    }
}
