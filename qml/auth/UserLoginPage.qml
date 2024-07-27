// UserLoginPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    id: loginPage
    
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

                TextField {
                    id: emailField
                    placeholderText: qsTr("Enter your email")
                    Layout.fillWidth: true
                    leftPadding: 40

                    background: Rectangle {
                        color: "#F8F8F8"
                        radius: 5
                        border.color: emailField.activeFocus ? theme.accentColor : "#DDDDDD"
                        border.width: emailField.activeFocus ? 2 : 1
                    }
                }

                TextField {
                    id: passwordField
                    placeholderText: qsTr("Enter your password")
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                    leftPadding: 40

                    background: Rectangle {
                        color: "#F8F8F8"
                        radius: 5
                        border.color: passwordField.activeFocus ? theme.accentColor : "#DDDDDD"
                        border.width: passwordField.activeFocus ? 2 : 1
                    }
                }

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

    function login() {
//        if (!validateInputs()) {
  //          return;
    //    }

        var success = dbManager.userManager().userLogin(emailField.text, passwordField.text)

        if (success) {
            var userData = dbManager.userManager().getUserData(emailField.text)
            stackView.push("../user/UserDashboardPage.qml", {userEmail: emailField.text, userData: userData})
        } else {
            showError(qsTr("Login failed. Please check your credentials."))
        }
    }

  /*  function validateInputs() {
        if (emailField.text.trim() === "" || !isValidEmail(emailField.text)) {
            showError(qsTr("Please enter a valid email address."))
            return false;
        }
        if (passwordField.text === "") {
            showError(qsTr("Please enter your password."))
            return false;
        }
        return true;
    }

    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
      } */
}
