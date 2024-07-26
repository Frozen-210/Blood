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
                text: qsTr("Hospital Signup")
                font: theme.headerFont
                color: theme.accentColor
                Layout.alignment: Qt.AlignHCenter
            }

            CustomTextField {
                id: nameField
                placeholderText: qsTr("Hospital Name")
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

            CustomTextField {
                id: contactNumberField
                placeholderText: qsTr("Contact Number")
                Layout.fillWidth: true
            }

            CustomTextField {
                id: addressField
                placeholderText: qsTr("Address")
                Layout.fillWidth: true
            }

            CustomTextField {
                id: cityField
                placeholderText: qsTr("City")
                Layout.fillWidth: true
            }

            CustomTextField {
                id: stateField
                placeholderText: qsTr("State")
                Layout.fillWidth: true
            }

            CustomTextField {
                id: countryField
                placeholderText: qsTr("Country")
                Layout.fillWidth: true
            }

            CustomTextField {
                id: zipField
                placeholderText: qsTr("ZIP Code")
                Layout.fillWidth: true
            }

            CustomTextField {
                id: licenseField
                placeholderText: qsTr("License Number")
                Layout.fillWidth: true
            }

            CustomButton {
                text: qsTr("Sign Up")
                buttonColor: theme.accentColor
                Layout.fillWidth: true
                onClicked: signUp()
            }

            Label {
                text: qsTr("Already have an account? Log in")
                color: theme.primaryColor
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
        var success = dbManager.hospitalManager().insertHospital(
            nameField.text,
            emailField.text,
            passwordField.text,
            contactNumberField.text,
            addressField.text,
            cityField.text,
            stateField.text,
            countryField.text,
            zipField.text,
            licenseField.text
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
