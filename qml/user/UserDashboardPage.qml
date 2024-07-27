// UserDashboardPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    id: userDashboardPage
    
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
        
        totalDonationsLabel.text = "Total Donations: " + dbManager.userManager().getUserTotalDonations(userEmail)
        lastDonationLabel.text = "Last Donation: " + dbManager.userManager().getUserLastDonation(userEmail)
        
        var appointments = dbManager.appointmentManager().getUserAppointments(userEmail)
        appointmentListModel.clear()
        for (var i = 0; i < appointments.length; i++) {
            appointmentListModel.append(appointments[i])
        }
        
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
                Label { id: totalDonationsLabel; font: theme.bodyFont }
                Label { id: lastDonationLabel; font: theme.bodyFont }
            }

            ColumnLayout {
                Button {
                    text: "Logout"
                    onClicked: logout()
                }
                
                Button {
                    text: "Delete Account"
                    onClicked: deleteAccountDialog.open()
                }
            }
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabButton { text: "Appointments" }
            TabButton { text: "Donations" }
            TabButton { text: "Search Donors" }
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
                        }
                    }

                    Button {
                        text: "Book Appointment"
                        onClicked: bookAppointmentDialog.open()
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
                    }
                }
            }

            // Search Donors Tab
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    TextField {
                        id: bloodGroupField
                        placeholderText: "Blood Group"
                        Layout.fillWidth: true
                    }

                    TextField {
                        id: locationField
                        placeholderText: "Location"
                        Layout.fillWidth: true
                    }

                    Button {
                        text: "Search Donors"
                        onClicked: searchDonors()
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: ListModel { id: donorListModel }
                        delegate: ItemDelegate {
                            text: model.name + " - " + model.bloodGroup + " - " + model.address
                            width: parent.width
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: deleteAccountDialog
        title: "Delete Account"
        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            spacing: 10
            TextField {
                id: deletePasswordField
                placeholderText: "Enter your password"
                echoMode: TextInput.Password
                Layout.fillWidth: true
            }
        }

        onAccepted: {
            var success = dbManager.userManager().deleteUser(userEmail, deletePasswordField.text)
            if (success) {
                logout()
            } else {
                showError("Failed to delete account. Please check your password.")
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
            }

            TextField {
                id: appointmentDateField
                placeholderText: "Appointment Date (YYYY-MM-DD)"
                Layout.fillWidth: true
            }

            TextField {
                id: appointmentTimeField
                placeholderText: "Appointment Time (HH:MM)"
                Layout.fillWidth: true
            }

            TextField {
                id: healthConditionField
                placeholderText: "Current Health Condition"
                Layout.fillWidth: true
            }
        }

        onAccepted: {
            var success = dbManager.appointmentManager().scheduleAppointment(
                userEmail,
                hospitalCombo.currentValue.email,
                appointmentDateField.text + " " + appointmentTimeField.text,
                healthConditionField.text
            )

            if (success) {
                updateUI()
                showMessage("Appointment booked successfully!")
            } else {
                showError("Failed to book appointment. Please try again.")
            }
        }
    }

    function searchDonors() {
        var donors = dbManager.userManager().searchDonors(bloodGroupField.text, locationField.text)
        donorListModel.clear()
        for (var i = 0; i < donors.length; i++) {
            donorListModel.append(donors[i])
        }
    }

    function logout() {
        stackView.pop(null) // Go back to the main page
    }

    function showError(message) {
        errorDialog.text = message
        errorDialog.open()
    }

    function showMessage(message) {
        messageDialog.text = message
        messageDialog.open()
    }

    Dialog {
        id: errorDialog
        title: "Error"
        standardButtons: Dialog.Ok
        property alias text: errorLabel.text

        Label {
            id: errorLabel
            wrapMode: Text.Wrap
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
        }
    }
}
