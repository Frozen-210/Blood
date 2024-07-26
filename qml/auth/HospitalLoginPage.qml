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
            text: qsTr("Hospital Login")
            font: theme.headerFont
            color: theme.accentColor
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
            buttonColor: theme.accentColor
            Layout.fillWidth: true
            onClicked: login()
        }

        Label {
            text: qsTr("Don't have an account? Sign up")
            color: theme.primaryColor
            font: theme.bodyFont
            Layout.alignment: Qt.AlignHCenter
            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push("../auth/HospitalSignupPage.qml")
            }
        }
    }

    function login() {
        busyIndicator.running = true
        var success = dbManager.hospitalManager().hospitalLogin(emailField.text, passwordField.text)
        busyIndicator.running = false

        if (success) {
            var hospitalData = dbManager.hospitalManager().getHospitalData(emailField.text)
            stackView.push("../hospital/HospitalDashboardPage.qml", {hospitalEmail: emailField.text, hospitalData: hospitalData})
        } else {
            showError("Login failed. Please check your credentials.")
        }
    }
}
