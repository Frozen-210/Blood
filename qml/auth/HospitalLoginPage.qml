// HospitalLoginPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: hospitalLoginPage
    
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
                    text: qsTr("Connecting hospitals with donors")
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
                    text: qsTr("Hospital Login")
                    font: theme.headerFont
                    color: theme.accentColor
                    Layout.alignment: Qt.AlignHCenter
                }

                TextField {
                    id: emailField
                    placeholderText: qsTr("Enter hospital email (e.g., hospital@example.com)")
                    Layout.fillWidth: true
                    leftPadding: 40

                    background: Rectangle {
                        color: "#F8F8F8"
                        radius: 5
                        border.color: emailField.activeFocus ? theme.accentColor : "#DDDDDD"
                        border.width: emailField.activeFocus ? 2 : 1
                    }

                    Image {
                        source: "qrc:/Image/Image/hospital_icon.png"
                        width: 20
                        height: 20
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 10
                    }
                }

                TextField {
                    id: passwordField
                    placeholderText: qsTr("Enter password (min. 8 characters)")
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                    leftPadding: 40

                    background: Rectangle {
                        color: "#F8F8F8"
                        radius: 5
                        border.color: passwordField.activeFocus ? theme.accentColor : "#DDDDDD"
                        border.width: passwordField.activeFocus ? 2 : 1
                    }

                    Image {
                        source: "qrc:/Image/Image/lock_icon.png"
                        width: 20
                        height: 20
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 10
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
                    color: theme.primaryColor
                    font: theme.bodyFont
                    Layout.alignment: Qt.AlignHCenter
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: stackView.push("HospitalSignupPage.qml")
                    }
                }

                Text {
                    text: qsTr("Back to main menu")
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

    function login() {
   //     if (!validateInputs()) {
    //        return;
     //   }

        var success = dbManager.hospitalManager().hospitalLogin(emailField.text, passwordField.text)

        if (success) {
            var hospitalData = dbManager.hospitalManager().getHospitalData(emailField.text)
            stackView.push("../hospital/HospitalDashboardPage.qml", {hospitalEmail: emailField.text, hospitalData: hospitalData})
        } else {
            showError(qsTr("Login failed. Please check your credentials."))
        }
    }

  /*  function validateInputs() {
        if (emailField.text.trim() === "" || !isValidEmail(emailField.text)) {
            showError(qsTr("Please enter a valid email address."))
            return false;
        }
        if (passwordField.text.length < 8) {
            showError(qsTr("Password must be at least 8 characters long."))
            return false;
        }
        return true;
    }

    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
      }*/
}
