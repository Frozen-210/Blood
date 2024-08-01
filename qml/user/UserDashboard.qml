import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components"
import "." as LocalComponents

Page {
    id: userDashboardPage

    property string userEmail: ""
    property var userData: ({})

    Component.onCompleted: {
        userData = dbManager.userManager().getUserData(userEmail)
        updateAppointments()
        updateDonations()
    }

    background: Rectangle {
        color: "#f5f5f5"  // Light gray background
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 80
            color: theme.primaryColor

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 4
                color: Qt.darker(theme.primaryColor, 1.2)
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15

                Image {
                    source: "qrc:/Image/Image/Logo.png"
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: qsTr("Welcome, ") + (userData.name || qsTr("User"))
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: "white"
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: qsTr("Logout")
                    onClicked: logout()
                    Material.background: "white"
                    Material.foreground: theme.primaryColor
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }
            }
        }

        // Main content
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            spacing: 20

            // Left sidebar
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 300
                color: "white"
                border.color: "#e0e0e0"
                border.width: 1
                radius: 4

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 20

                    Image {
                        source: "qrc:/Image/Image/user_avatar.png"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 120
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        text: "User Profile"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                        color: theme.primaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ColumnLayout {
                        spacing: 15
                        Layout.fillWidth: true

                        UserInfoItem { label: "Name"; value: userData.name || "N/A" }
                        UserInfoItem { label: "Email"; value: userData.email || "N/A" }
                        UserInfoItem { label: "Blood Group"; value: userData.bloodGroup || "N/A" }
                        UserInfoItem { label: "Health Info"; value: userData.healthInfo || "N/A" }
                        UserInfoItem { label: "Total Donations"; value: dbManager.userManager().getUserTotalDonations(userEmail) || "0" }
                        UserInfoItem { label: "Last Donation"; value: dbManager.userManager().getUserLastDonation(userEmail) || "Never" }
                    }

                    Item { Layout.fillHeight: true }

                    Button {
                        text: qsTr("Edit Profile")
                        Layout.fillWidth: true
                        onClicked: editProfile()
                        Material.background: theme.accentColor
                        Material.foreground: "white"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                    }

                    Button {
                        text: qsTr("Delete Account")
                        Layout.fillWidth: true
                        onClicked: deleteAccountDialog.open()
                        Material.background: Material.Red
                        Material.foreground: "white"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                    }
                }
            }

            // Main content area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "white"
                border.color: "#e0e0e0"
                border.width: 1
                radius: 4

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 20

                    TabBar {
                        id: tabBar
                        Layout.fillWidth: true
                        Material.background: theme.primaryColor
                        Material.accent: "white"

                        TabButton { text: qsTr("Appointments"); font.pixelSize: 16 }
                        TabButton { text: qsTr("Donations"); font.pixelSize: 16 }
                        TabButton { text: qsTr("Search Donors"); font.pixelSize: 16 }
                    }

                    StackLayout {
                        currentIndex: tabBar.currentIndex
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        // Appointments Tab
                        ColumnLayout {
                            spacing: 15

                            ListView {
                                id: appointmentListView
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: ListModel { id: appointmentListModel }
                                
                                delegate: ItemDelegate {
                                    width: parent.width
                                    height: 60
                                    Material.background: index % 2 === 0 ? "#f9f9f9" : "white"

                                    contentItem: RowLayout {
                                        spacing: 10
                                        Label { 
                                            text: model.date + " - " + model.hospitalName
                                            font.pixelSize: 16
                                            Layout.fillWidth: true
                                        }
                                        Button {
                                            text: "Cancel"
                                            onClicked: cancelAppointment(model.id)
                                            Material.background: Material.Red
                                            Material.foreground: "white"
                                        }
                                    }
                                }
                            }

                            Button {
                                text: qsTr("Book New Appointment")
                                onClicked: bookAppointmentDialog.open()
                                Material.background: theme.accentColor
                                Material.foreground: "white"
                                Layout.alignment: Qt.AlignRight
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }
                        }

                        // Donations Tab
                        ColumnLayout {
                            spacing: 15

                            ListView {
                                id: donationListView
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: ListModel { id: donationListModel }
                                
                                delegate: ItemDelegate {
                                    width: parent.width
                                    height: 60
                                    Material.background: index % 2 === 0 ? "#f9f9f9" : "white"

                                    contentItem: RowLayout {
                                        spacing: 10
                                        Label { 
                                            text: model.date
                                            font.pixelSize: 16
                                            Layout.preferredWidth: parent.width * 0.3
                                        }
                                        Label { 
                                            text: model.amount + " ml"
                                            font.pixelSize: 16
                                            Layout.preferredWidth: parent.width * 0.3
                                        }
                                        Label { 
                                            text: model.hospitalName
                                            font.pixelSize: 16
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }

                            Button {
                                text: qsTr("Schedule New Donation")
                                onClicked: scheduleDonationDialog.open()
                                Material.background: theme.accentColor
                                Material.foreground: "white"
                                Layout.alignment: Qt.AlignRight
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }
                        }

                        // Search Donors Tab
                        ColumnLayout {
                            spacing: 15

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 10

                                TextField {
                                    id: bloodGroupField
                                    placeholderText: "Blood Group"
                                    Layout.fillWidth: true
                                    font.pixelSize: 16
                                }

                                TextField {
                                    id: locationField
                                    placeholderText: "Location"
                                    Layout.fillWidth: true
                                    font.pixelSize: 16
                                }

                                Button {
                                    text: "Search"
                                    onClicked: searchDonors()
                                    Material.background: theme.accentColor
                                    Material.foreground: "white"
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                }
                            }

                            ListView {
                                id: donorListView
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: ListModel { id: donorListModel }
                                
                                delegate: ItemDelegate {
                                    width: parent.width
                                    height: 60
                                    Material.background: index % 2 === 0 ? "#f9f9f9" : "white"

                                    contentItem: RowLayout {
                                        spacing: 10
                                        Label { 
                                            text: model.name
                                            font.pixelSize: 16
                                            Layout.preferredWidth: parent.width * 0.3
                                        }
                                        Label { 
                                            text: model.bloodGroup
                                            font.pixelSize: 16
                                            Layout.preferredWidth: parent.width * 0.3
                                        }
                                        Label { 
                                            text: model.location
                                            font.pixelSize: 16
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    LocalComponents.BookAppointmentDialog {
        id: bookAppointmentDialog
        userEmail: userDashboardPage.userEmail
        onAppointmentBooked: {
            updateAppointments()
            showMessage("Appointment booked successfully!")
        }
    }

    LocalComponents.ScheduleDonationDialog {
        id: scheduleDonationDialog
        userEmail: userDashboardPage.userEmail
        onDonationScheduled: {
            updateDonations()
            showMessage("Donation scheduled successfully!")
        }
    }

    LocalComponents.DeleteAccountDialog {
        id: deleteAccountDialog
        userEmail: userDashboardPage.userEmail
        onAccountDeleted: logout()
    }

    function updateAppointments() {
        var appointments = dbManager.appointmentManager().getUserAppointments(userEmail)
        appointmentListModel.clear()
        for (var i = 0; i < appointments.length; i++) {
            appointmentListModel.append(appointments[i])
        }
    }

    function updateDonations() {
        var donations = dbManager.donationManager().getUserDonationHistory(userEmail)
        donationListModel.clear()
        for (var i = 0; i < donations.length; i++) {
            donationListModel.append(donations[i])
        }
    }

    function cancelAppointment(appointmentId) {
        var success = dbManager.appointmentManager().cancelAppointment(appointmentId)
        if (success) {
            updateAppointments()
            showMessage("Appointment cancelled successfully.")
        } else {
            showError("Failed to cancel appointment. Please try again.")
        }
    }

    function searchDonors() {
        var donors = dbManager.userManager().searchDonors(bloodGroupField.text, locationField.text)
        donorListModel.clear()
        for (var i = 0; i < donors.length; i++) {
            donorListModel.append(donors[i])
        }
    }

    function editProfile() {
        var dialog = editProfileDialog.createObject(userDashboardPage, {userData: userData})
        dialog.open()
    }

    function logout() {
        stackView.pop(null) // Go back to the main page
    }

    function showError(message) {
        errorDialog.errorMessage = message
        errorDialog.open()
    }

    function showMessage(message) {
        messageDialog.text = message
        messageDialog.open()
    }

    ErrorDialog {
        id: errorDialog
    }

    MessageDialog {
        id: messageDialog
    }

    Component {
        id: editProfileDialog
        Dialog {
            title: qsTr("Edit Profile")
            standardButtons: Dialog.Ok | Dialog.Cancel
            onAccepted: {
                var success = dbManager.userManager().updateUserProfile(userEmail, {
                    name: nameField.text,
                    bloodGroup: bloodGroupField.text,
                    healthInfo: healthInfoField.text
                })
                if (success) {
                    userData = dbManager.userManager().getUserData(userEmail)
                    updateAppointments()
                    updateDonations()
                    showMessage("Profile updated successfully.")
                } else {
                    showError("Failed to update profile. Please try again.")
                }
            }

            ColumnLayout {
                TextField {
                    id: nameField
                    placeholderText: qsTr("Full Name")
                    text: userData.name
                    Layout.fillWidth: true
                }
                TextField {
                    id: bloodGroupField
                    placeholderText: qsTr("Blood Group")
                    text: userData.bloodGroup
                    Layout.fillWidth: true
                }
                TextField {
                    id: healthInfoField
                    placeholderText: qsTr("Health Information")
                    text: userData.healthInfo
                    Layout.fillWidth: true
                }
            }
        }
    }

    component UserInfoItem: ColumnLayout {
        property string label: ""
        property string value: ""
        spacing: 2
        
        Label {
            text: label
            font.pixelSize: 14
            color: theme.textColor
            opacity: 0.7
        }
        Label {
            text: value
            font.pixelSize: 16
            font.weight: Font.Medium
            color: theme.textColor
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
    }
}
