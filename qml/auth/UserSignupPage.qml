// UserSignupPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
  id: signupPage

ThemeColors {
    id: theme
    property color primaryColor: "#E53935"
    property color accentColor: "#1E88E5"
    property color backgroundColor: "#FFFFFF"
    property color textColor: "#212121"
    property color lightTextColor: "#757575"
    property font headerFont: Qt.font({ family: "Segoe UI", pixelSize: 32, weight: Font.Bold })
    property font subHeaderFont: Qt.font({ family: "Segoe UI", pixelSize: 24, weight: Font.DemiBold })
    property font bodyFont: Qt.font({ family: "Segoe UI", pixelSize: 16 })
    property font buttonFont: Qt.font({ family: "Segoe UI", pixelSize: 16, weight: Font.Medium })
}
    
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
                    text: qsTr("Join our community of donors")
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
                        text: qsTr("Create Your Account")
                        font: theme.headerFont
                        color: theme.primaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    TextField {
                        id: nameField
                        placeholderText: qsTr("Full Name")
                        Layout.fillWidth: true
                        leftPadding: 40

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: nameField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: nameField.activeFocus ? 2 : 1
                        }

                    }

                    TextField {
                        id: emailField
                        placeholderText: qsTr("Email")
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
                        placeholderText: qsTr("Password")
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

                    ComboBox {
                        id: bloodGroupCombo
                        model: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                        Layout.fillWidth: true
                        leftPadding: 40

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: bloodGroupCombo.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: bloodGroupCombo.activeFocus ? 2 : 1
                        }


                    }

                    TextField {
                        id: healthInfoField
                        placeholderText: qsTr("Health Information (Optional)")
                        Layout.fillWidth: true
                        leftPadding: 40

                        background: Rectangle {
                            color: "#F8F8F8"
                            radius: 5
                            border.color: healthInfoField.activeFocus ? theme.accentColor : "#DDDDDD"
                            border.width: healthInfoField.activeFocus ? 2 : 1
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
                        color: theme.accentColor
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
                            onClicked: stackView.push("MainView.qml")
                        }
                    }
                }
            }
        }
    }

    function signUp() {
    //    if (!validateInputs()) {
      //      return;
      //  }

        var success = dbManager.userManager().insertUser(
            nameField.text,
            emailField.text,
            passwordField.text,
            bloodGroupCombo.currentText,
            healthInfoField.text
        )

        if (success) {
            var userData = dbManager.userManager().getUserData(emailField.text)
            stackView.push("../user/UserDashboardPage.qml", 
                           {userEmail: emailField.text, userData: userData})
        } else {
            showError(qsTr("Sign up failed. Please try again."))
        }
    }

  /*  function validateInputs() {
        if (nameField.text.trim() === "") {
            showError(qsTr("Please enter your full name."))
            return false;
        }
        if (emailField.text.trim() === "" || !isValidEmail(emailField.text)) {
            showError(qsTr("Please enter a valid email address."))
            return false;
        }
        if (passwordField.text.length < 6) {
            showError(qsTr("Password must be at least 6 characters long."))
            return false;
        }
        return true;
    }

    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
      }*/
}
