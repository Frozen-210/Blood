// UserDashboardPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
  id: userDashboardPage

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
    
    property string userEmail: ""
    property var userData: ({})

    Component.onCompleted: {
        userData = dbManager.userManager().getUserData(userEmail)
        updateUI()
    }

    function updateUI() {
        userNameLabel.text = "Name: " + (userData.name || "")
        userEmailLabel.text = "Email: " + (userData.email || "")
        userBloodGroupLabel.text = "Blood Group: " + (userData.bloodGroup || "")
        userHealthInfoLabel.text = "Health Info: " + (userData.healthInfo || "")
        
        // Fetch and display appointments
        var appointments = dbManager.appointmentManager().getUserAppointments(userEmail)
        appointmentListModel.clear()
        for (var i = 0; i < appointments.length; i++) {
            appointmentListModel.append(appointments[i])
        }
        
        // Fetch and display donations
        var donations = dbManager.donationManager().getUserDonationHistory(userEmail)
        donationListModel.clear()
        for (var j = 0; j < donations.length; j++) {
            donationListModel.append(donations[j])
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20
        anchors.margins: 20

        RowLayout {
            Layout.fillWidth: true
            
            ColumnLayout {
                Layout.fillWidth: true
                
                Label {
                    text: "User Dashboard"
                    font: theme.headerFont
                    color: theme.primaryColor
                }

                Label { id: userNameLabel; font: theme.bodyFont }
                Label { id: userEmailLabel; font: theme.bodyFont }
                Label { id: userBloodGroupLabel; font: theme.bodyFont }
                Label { id: userHealthInfoLabel; font: theme.bodyFont }
            }

            Button {
                text: "Logout"
                onClicked: logout()
                
                contentItem: Text {
                    text: parent.text
                    font: theme.buttonFont
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: theme.primaryColor
                    radius: 5
                }
            }
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabButton {
                text: "Appointments"
                width: implicitWidth
                font: theme.buttonFont
            }
            TabButton {
                text: "Donations"
                width: implicitWidth
                font: theme.buttonFont
            }
        }

        StackLayout {
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Appointments Tab
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: ListModel { id: appointmentListModel }
                        delegate: ItemDelegate {
                            text: model.date + " - " + model.hospitalName
                            width: parent.width
                            font: theme.bodyFont
                        }
                    }

                    Button {
                        text: "Book Appointment"
                        onClicked: bookAppointmentDialog.open()
                        Layout.alignment: Qt.AlignRight
                        
                        contentItem: Text {
                            text: parent.text
                            font: theme.buttonFont
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            color: theme.accentColor
                            radius: 5
                        }
                    }
                }
            }

            // Donations Tab
            Item {
                ListView {
                    anchors.fill: parent
                    model: ListModel { id: donationListModel }
                    delegate: ItemDelegate {
                        text: model.date + " - " + model.amount + "ml"
                        width: parent.width
                        font: theme.bodyFont
                    }
                }
            }
        }
    }

    Dialog {
        id: bookAppointmentDialog
        title: "Book Appointment"
        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            width: parent.width
            spacing: 10

            ComboBox {
                id: hospitalCombo
                model: dbManager.hospitalManager().getHospitalList()
                textRole: "name"
                Layout.fillWidth: true
                font: theme.bodyFont
            }

            TextField {
                id: appointmentDateField
                placeholderText: "Appointment Date (YYYY-MM-DD)"
                Layout.fillWidth: true
                font: theme.bodyFont
            }

            TextField {
                id: healthConditionField
                placeholderText: "Current Health Condition"
                Layout.fillWidth: true
                font: theme.bodyFont
            }
        }

        onAccepted: {
            var lastDonationDate = dbManager.donationManager().getLastDonationDate(userEmail)
            var today = new Date()
            var threeMonthsAgo = new Date(today.setMonth(today.getMonth() - 3))
            
            if (lastDonationDate && new Date(lastDonationDate) > threeMonthsAgo) {
                showError("You must wait 3 months between donations.")
                return
            }

            var success = dbManager.appointmentManager().scheduleAppointment(
                userEmail,
                hospitalCombo.currentValue.email,
                appointmentDateField.text,
                healthConditionField.text
            )

            if (success) {
                showMessage("Appointment booked successfully!")
                updateUI()
            } else {
                showError("Failed to book appointment. Please try again.")
            }
        }
    }

    function showError(message) {
        errorDialog.text = message
        errorDialog.open()
    }

    function showMessage(message) {
        messageDialog.text = message
        messageDialog.open()
    }

    function logout() {
        stackView.pop(null) // Go back to the main page
    }

    Dialog {
        id: errorDialog
        title: "Error"
        standardButtons: Dialog.Ok
        property alias text: errorLabel.text

        Label {
            id: errorLabel
            wrapMode: Text.Wrap
            font: theme.bodyFont
        }
    }

    Dialog {
        id: messageDialog
        title: "Message"
        standardButtons: Dialog.Ok
        property alias text: messageLabel.text

        Label {
            id: messageLabel
            wrapMode: Text.Wrap
            font: theme.bodyFont
        }
    }
}
