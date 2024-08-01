import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"


Page {
  id: loginPage


ErrorDialog{
  id:errorDialog
}
    
    // Set the background color of the page
    background: Rectangle {
        color: theme.backgroundColor
    }

    // Custom ErrorDialog component
    // This dialog will be used to display error messages
  /*  Dialog {
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
            spacing: 20
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
          }*/
   // }

    // Main content of the login page
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left side of the login page (logo and app name)
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
                    text: qsTr("Connecting donors and hospitals")
                    font: theme.bodyFont
                    color: "white"
                    opacity: 0.9
                    Layout.alignment: Qt.AlignHCenter
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // Right side of the login page (login form)
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: theme.backgroundColor

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width * 0.8, 400)
                spacing: 30

                Label {
                    text: qsTr("Welcome Back!")
                    font: theme.headerFont
                    color: theme.primaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                // Email input field
                TextField {
                    id: emailField
                    placeholderText: qsTr("Enter your email")
                    Layout.fillWidth: true
                    leftPadding: 20
                    palette.text: "black"
                    palette.placeholderText: "#d6d2cb"

                    background: Rectangle {
                        color: "#F8F8F8"
                        radius: 5
                        border.color: emailField.activeFocus ? theme.accentColor : "#DDDDDD"
                        border.width: emailField.activeFocus ? 3 : 1
                    }
                }

                // Password input field
                TextField {
                    id: passwordField
                    placeholderText: qsTr("Enter your password")
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                    leftPadding: 20
                    palette.text: "black"
                    palette.placeholderText: "#d6d2cb"

                    background: Rectangle {
                        color: "#F8F8F8"
                        radius: 5
                        border.color: passwordField.activeFocus ? theme.accentColor : "#DDDDDD"
                        border.width: passwordField.activeFocus ? 2 : 1
                    }
                }

                // Login button
                Button {
                    text: qsTr("Login")
                    Layout.fillWidth: true
                    onClicked: login()

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

                // Sign up link
                Label {
                    text: qsTr("Don't have an account? Sign up")
                    color: theme.accentColor
                    font: theme.bodyFont
                    Layout.alignment: Qt.AlignHCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push("UserSignupPage.qml")
                    }
                }

                // Back to Main Menu link
                Text {
                    text: qsTr("Back to Main Menu")
                    color: theme.accentColor
                    font: theme.bodyFont
                    Layout.alignment: Qt.AlignHCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.font.underline = true
                        onExited: parent.font.underline = false
                        onClicked: stackView.push("../MainView.qml")
                    }
                }
            }
        }
    }

    // Function to handle login process
    function login() {
        if (!validateInputs()) {
            return;
        }

        // userLogin is bool 
        var success = dbManager.userManager().userLogin(emailField.text, passwordField.text)

        if (success) {
            var userData = dbManager.userManager().getUserData(emailField.text)
            stackView.push("../user/UserDashboard.qml", {userEmail: emailField.text, userData: userData})
          } else {
            // Calls the showError Function 
            showError(qsTr("Login Failed"), qsTr("Login failed. Please check your credentials."))
        }
    }

    // Function to validate user inputs
    function validateInputs() {
        if (emailField.text.trim() === "" || !isValidEmail(emailField.text)) {
            showError(qsTr("Invalid Email"), qsTr("Please enter a valid email address."))
            return false;
        }
        if (passwordField.text === "") {
            showError(qsTr("Missing Password"), qsTr("Please enter your password."))
            return false;
        }
        return true;
    }

    // Function to validate email format
    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    // Function to show error dialog
    function showError(title, message) {
        errorDialog.errorTitle = title
        errorDialog.errorMessage = message
        errorDialog.open()
    }
}
