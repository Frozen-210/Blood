import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    background: Rectangle {
        color: theme.backgroundColor
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            width: Math.min(parent.width * 0.8, 400)
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Label {
                text: qsTr("User Signup")
                font: theme.headerFont
                color: theme.primaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            CustomTextField {
                id: nameField
                placeholderText: qsTr("Full Name")
                Layout.fillWidth: true
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

            CustomComboBox {
                id: bloodGroupCombo
                model: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                Layout.fillWidth: true
            }

            CustomTextField {
                id: healthInfoField
                placeholderText: qsTr("Health Information (Optional)")
                Layout.fillWidth: true
            }

            CustomButton {
                text: qsTr("Sign Up")
                Layout.fillWidth: true
                onClicked: signUp()
            }

            Label {
                text: qsTr("Already have an account? Log in")
                color: theme.accentColor
                font: theme.bodyFont
                Layout.alignment: Qt.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.pop()
                }
            }
        }
    }

    function signUp() {
        busyIndicator.running = true
        var success = dbManager.userManager().insertUser(
            nameField.text,
            emailField.text,
            passwordField.text,
            bloodGroupCombo.currentText,
            healthInfoField.text
        )
        busyIndicator.running = false

        if (success) {
            showError("Sign up successful. Please log in.")
            stackView.pop()
        } else {
            showError("Sign up failed. Please try again.")
        }
    }
}
