// HospitalSignupPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: hospitalSignupPage
    
    background: Rectangle {
        color: theme.backgroundColor
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.4
            color: theme.primaryColor

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30
                width: parent.width * 0.8

                Image {
                    source: "qrc:/Image/Image/Logo.png"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: Math.min(parent.width * 0.6, 180)
                    Layout.preferredHeight: Layout.preferredWidth
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: qsTr("BloodBound")
                    font: theme.headerFont
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: qsTr("Join our network of hospitals")
                    font: theme.bodyFont
                    color: "white"
                    opacity: 0.9
                    Layout.alignment: Qt.AlignHCenter
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: theme.backgroundColor

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

                    TextField {
                        id: nameField
                        placeholderText: qsTr("Hospital Name (e.g., City General Hospital)")
                        Layout.fillWidth: true
                        leftPadding: 20
                        palette.text : "black"
                        palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: nameField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: nameField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: emailField
                        placeholderText: qsTr("Hospital Email (e.g., info@cityhospital.com)")
                        Layout.fillWidth: true
                        leftPadding: 20
                        palette.text : "black"
                        palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: emailField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: emailField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: passwordField
                        placeholderText: qsTr("Password (min. 8 characters)")
                        echoMode: TextInput.Password
                        Layout.fillWidth: true
                        leftPadding: 40
                        palette.text : "black"
                    palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: passwordField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: passwordField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: contactNumberField
                        placeholderText: qsTr("Contact Number (e.g., +1 234 567 8900)")
                        Layout.fillWidth: true
                        leftPadding: 20
                        palette.text : "black"
                    palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: contactNumberField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: contactNumberField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: addressField
                        placeholderText: qsTr("Address (e.g., 123 Main St, Suite 456)")
                        Layout.fillWidth: true
                        leftPadding: 20
                        palette.text : "black"
                    palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: addressField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: addressField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: cityField
                        placeholderText: qsTr("City (e.g., New York)")
                        Layout.fillWidth: true
                        leftPadding: 20
palette.text : "black"
                    palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: cityField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: cityField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: stateField
                        placeholderText: qsTr("State (e.g., NY)")
                        Layout.fillWidth: true
                        leftPadding: 20
                        palette.text : "black"
                    palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: stateField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: stateField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: countryField
                        placeholderText: qsTr("Country (e.g., United States)")
                        Layout.fillWidth: true
                        leftPadding: 20
palette.text : "black"
                    palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: countryField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: countryField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: zipField
                        placeholderText: qsTr("ZIP Code (e.g., 12345)")
                        Layout.fillWidth: true
                        leftPadding: 20
                        palette.text : "black"
                    palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: zipField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: zipField.activeFocus ? 2 : 1
                        }
                    }

                    TextField {
                        id: licenseField
                        placeholderText: qsTr("License Number (e.g., HOSP-12345-NY)")
                        Layout.fillWidth: true
                        leftPadding: 20
                        palette.text : "black"
                    palette.placeholderText : "#d6d2cb"

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: licenseField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: licenseField.activeFocus ? 2 : 1
                        }
                    }

                    Button {
                        text: qsTr("Sign Up")
                        Layout.fillWidth: true
                        onClicked: signUp()

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

                    Label {
                        text: qsTr("Already have an account? Log in")
                        color: theme.primaryColor
                        font: theme.bodyFont
                        Layout.alignment: Qt.AlignHCenter
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stackView.pop()
                        }
                    }

                    Text {
                        text: qsTr("Back to Main Menu")
                        color: theme.accentColor
                        font: theme.bodyFont
                        Layout.alignment: Qt.AlignHCenter
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.font.underline = true
                            onExited: parent.font.underline = false
                            onClicked: stackView.push("../MainView.qml")
                        }
                    }
                }
            }
        }
    }

    function signUp() {
        if (!validateInputs()) {
            return;
        }

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

        if (success) {
            var hospitalData = dbManager.hospitalManager().getHospitalData(emailField.text)
            stackView.push("../hospital/HospitalDashboardPage.qml", {hospitalEmail: emailField.text, hospitalData: hospitalData})
        } else {
            showError(qsTr("Sign up failed. Please try again."))
        }
    }

    function validateInputs() {
        if (nameField.text.trim() === "") {
            showError(qsTr("Please enter the hospital name."))
            return false;
        }
        if (emailField.text.trim() === "" || !isValidEmail(emailField.text)) {
            showError(qsTr("Please enter a valid email address."))
            return false;
        }
        if (passwordField.text.length < 8) {
            showError(qsTr("Password must be at least 8 characters long."))
            return false;
        }
        if (contactNumberField.text.trim() === "") {
            showError(qsTr("Please enter a contact number."))
            return false;
        }
        if (addressField.text.trim() === "") {
            showError(qsTr("Please enter the hospital address."))
            return false;
        }
        if (cityField.text.trim() === "") {
            showError(qsTr("Please enter the city."))
            return false;
        }
        if (stateField.text.trim() === "") {
            showError(qsTr("Please enter the state."))
            return false;
        }
        if (countryField.text.trim() === "") {
            showError(qsTr("Please enter the country."))
            return false;
        }
        if (zipField.text.trim() === "") {
            showError(qsTr("Please enter the ZIP code."))
            return false;
        }
        if (licenseField.text.trim() === "") {
            showError(qsTr("Please enter the hospital license number."))
            return false;
        }
        return true;
    }

    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
      }
}
