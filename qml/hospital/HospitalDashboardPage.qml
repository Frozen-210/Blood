// HospitalDashboardPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components/"

Page {
  id: hospitalDashboardPage


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


    
    property string hospitalEmail: ""
    property var hospitalData: ({})

    Component.onCompleted: {
        hospitalData = dbManager.hospitalManager().getHospitalData(hospitalEmail)
    }

    background: Rectangle {
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 80
            color: theme.primaryColor

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15

                Label {
                    text: qsTr("Welcome, ") + (hospitalData.name || qsTr("Hospital"))
                    font: theme.headerFont
                    color: "white"
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: qsTr("Logout")
                    onClicked: logout()
                    
                    contentItem: Text {
                        text: parent.text
                        font: theme.buttonFont
                        color: theme.primaryColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: "white"
                        radius: 5
                    }
                }
            }
        }

        // Main content
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Left sidebar
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 250
                color: theme.backgroundColor
                border.color: theme.lightTextColor
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20

                    Image {
                        source: "qrc:/Image/Image/HospitalLogo.png"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 120
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        text: hospitalData.name || qsTr("Hospital Name")
                        font.pixelSize: 20
                        font.weight: Font.DemiBold
                        color: theme.textColor
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        text: qsTr("License: ") + (hospitalData.license || qsTr("N/A"))
                        font.pixelSize: 16
                        color: theme.textColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.lightTextColor
                    }

                    Label {
                        text: qsTr("Total Appointments")
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        color: theme.textColor
                    }

                    Label {
                        text: dbManager.appointmentManager().getHospitalAppointments(hospitalEmail).length || "0"
                        font.pixelSize: 14
                        color: theme.textColor
                    }

                    Item { Layout.fillHeight: true }

                    Button {
                        text: qsTr("Edit Profile")
                        Layout.fillWidth: true
                        onClicked: editProfile()
                        
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

            // Main content area
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 20
                spacing: 20

                TabBar {
                    id: tabBar
                    Layout.fillWidth: true

                    TabButton {
                        text: qsTr("Blood Inventory")
                        font: theme.buttonFont
                    }
                    TabButton {
                        text: qsTr("Appointments")
                        font: theme.buttonFont
                    }
                }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: tabBar.currentIndex

                    // Blood Inventory Page
                    ColumnLayout {
                        spacing: 15

                        RowLayout {
                            Layout.fillWidth: true
                            Label { 
                                text: qsTr("Blood Inventory")
                                font.pixelSize: 22
                                font.weight: Font.DemiBold
                            }
                            Item { Layout.fillWidth: true }
                            Button {
                                text: qsTr("Update Inventory")
                                onClicked: updateInventory()
                                
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

                        GridLayout {
                            columns: 4
                            rowSpacing: 10
                            columnSpacing: 20
                            Layout.fillWidth: true

                            Repeater {
                                model: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                                delegate: ColumnLayout {
                                    Label {
                                        text: modelData
                                        font.bold: true
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Label {
                                        text: dbManager.hospitalManager().getBloodInventoryLevels(hospitalEmail)[modelData] + " ml"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }
                    }

                    // Appointments Page
                    ColumnLayout {
                        spacing: 15

                          RowLayout {
                            Layout.fillWidth: true
                            Label { 
                                text: qsTr("Upcoming Appointments")
                                font.pixelSize: 22
                                font.weight: Font.DemiBold
                            }
                            Item { Layout.fillWidth: true }
                            Button {
                                text: qsTr("Schedule Appointment")
                                onClicked: scheduleAppointment()
                                
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

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: dbManager.appointmentManager().getHospitalAppointments(hospitalEmail)
                            delegate: ItemDelegate {
                                width: parent.width
                                height: 80
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 15

                                    Rectangle {
                                        width: 50
                                        height: 50
                                        radius: 25
                                        color: theme.accentColor

                                        Label {
                                            anchors.centerIn: parent
                                            text: Qt.formatDateTime(modelData.date, "MMM\nd")
                                            color: "white"
                                            font.pixelSize: 12
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 5
                                        Label {
                                            text: modelData.userName
                                            font.pixelSize: 16
                                            font.weight: Font.DemiBold
                                        }
                                        Label {
                                            text: qsTr("Blood Group: ") + modelData.bloodGroup
                                            font.pixelSize: 14
                                        }
                                        Label {
                                            text: Qt.formatDateTime(modelData.date, "dddd, MMMM d, yyyy h:mm AP")
                                            font.pixelSize: 14
                                            color: theme.lightTextColor
                                        }
                                    }

                                    Button {
                                        text: qsTr("Cancel")
                                        onClicked: cancelAppointment(modelData.id)
                                        
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
                            }

                            // Placeholder when the list is empty
                            Item {
                                anchors.fill: parent
                                visible: parent.count === 0

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 20

                                    Label {
                                        text: qsTr("No upcoming appointments")
                                        font.pixelSize: 18
                                        color: theme.lightTextColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Button {
                                        text: qsTr("Schedule Your First Appointment")
                                        Layout.alignment: Qt.AlignHCenter
                                        onClicked: scheduleAppointment()
                                        
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
                        }
                    }
                }
            }
        }
    }

    function logout() {
        stackView.pop(null) // Go back to the main page
    }

    function editProfile() {
        var dialog = editProfileDialog.createObject(hospitalDashboardPage, {hospitalData: hospitalData})
        dialog.open()
    }

    function updateInventory() {
        var dialog = updateInventoryDialog.createObject(hospitalDashboardPage, {hospitalEmail: hospitalEmail})
        dialog.open()
    }

    function scheduleAppointment() {
        var dialog = scheduleAppointmentDialog.createObject(hospitalDashboardPage, {hospitalEmail: hospitalEmail})
        dialog.open()
    }

    function cancelAppointment(appointmentId) {
        busyIndicator.running = true
        var success = dbManager.appointmentManager().cancelAppointment(appointmentId)
        busyIndicator.running = false

        if (success) {
            // Refresh the appointment list
            tabBar.currentIndex = 1 // Switch to Appointments tab
        } else {
            showError(qsTr("Failed to cancel appointment. Please try again."))
        }
    }

    Component {
        id: editProfileDialog
        Dialog {
            title: qsTr("Edit Hospital Profile")
            standardButtons: Dialog.Ok | Dialog.Cancel
            onAccepted: {
                busyIndicator.running = true
                var success = dbManager.hospitalManager().updateHospitalProfile(hospitalEmail, {
                    name: nameField.text,
                    contactNumber: contactNumberField.text,
                    address: addressField.text,
                    city: cityField.text,
                    state: stateField.text,
                    country: countryField.text,
                    zip: zipField.text,
                    license: licenseField.text
                })
                busyIndicator.running = false

                if (success) {
                    hospitalData = dbManager.hospitalManager().getHospitalData(hospitalEmail)
                } else {
                    showError(qsTr("Failed to update profile. Please try again."))
                }
            }

            ColumnLayout {
                TextField {
                    id: nameField
                    placeholderText: qsTr("Hospital Name")
                    text: hospitalData.name
                    Layout.fillWidth: true
                }
                TextField {
                    id: contactNumberField
                    placeholderText: qsTr("Contact Number")
                    text: hospitalData.contactNumber
                    Layout.fillWidth: true
                }
                TextField {
                    id: addressField
                    placeholderText: qsTr("Address")
                    text: hospitalData.address
                    Layout.fillWidth: true
                }
                TextField {
                    id: cityField
                    placeholderText: qsTr("City")
                    text: hospitalData.city
                    Layout.fillWidth: true
                }
                TextField {
                    id: stateField
                    placeholderText: qsTr("State")
                    text: hospitalData.state
                    Layout.fillWidth: true
                }
                TextField {
                    id: countryField
                    placeholderText: qsTr("Country")
                    text: hospitalData.country
                    Layout.fillWidth: true
                }
                TextField {
                    id: zipField
                    placeholderText: qsTr("ZIP Code")
                    text: hospitalData.zip
                    Layout.fillWidth: true
                }
                TextField {
                    id: licenseField
                    placeholderText: qsTr("License Number")
                    text: hospitalData.license
                    Layout.fillWidth: true
                }
            }
        }
    }

    Component {
        id: updateInventoryDialog
        Dialog {
            title: qsTr("Update Blood Inventory")
            standardButtons: Dialog.Ok | Dialog.Cancel
            onAccepted: {
                var success = dbManager.hospitalManager().updateBloodInventoryLevels(hospitalEmail, {
                    "A+": aPositiveField.text,
                    "A-": aNegativeField.text,
                    "B+": bPositiveField.text,
                    "B-": bNegativeField.text,
                    "AB+": abPositiveField.text,
                    "AB-": abNegativeField.text,
                    "O+": oPositiveField.text,
                    "O-": oNegativeField.text
                })

                if (success) {
                    // Refresh the inventory display
                    tabBar.currentIndex = 0 // Switch to Blood Inventory tab
                } else {
                    showError(qsTr("Failed to update blood inventory. Please try again."))
                }
            }

            GridLayout {
                columns: 2
                rowSpacing: 10
                columnSpacing: 20

                Label { text: "A+" }
                TextField {
                    id: aPositiveField
                    placeholderText: qsTr("Amount in ml")
                    validator: IntValidator {bottom: 0; top: 100000;}
                }

                Label { text: "A-" }
                TextField {
                    id: aNegativeField
                    placeholderText: qsTr("Amount in ml")
                    validator: IntValidator {bottom: 0; top: 100000;}
                }

                Label { text: "B+" }
                TextField {
                    id: bPositiveField
                    placeholderText: qsTr("Amount in ml")
                    validator: IntValidator {bottom: 0; top: 100000;}
                }

                Label { text: "B-" }
                TextField {
                    id: bNegativeField
                    placeholderText: qsTr("Amount in ml")
                    validator: IntValidator {bottom: 0; top: 100000;}
                }

                Label { text: "AB+" }
                TextField {
                    id: abPositiveField
                    placeholderText: qsTr("Amount in ml")
                    validator: IntValidator {bottom: 0; top: 100000;}
                }

                Label { text: "AB-" }
                TextField {
                    id: abNegativeField
                    placeholderText: qsTr("Amount in ml")
                    validator: IntValidator {bottom: 0; top: 100000;}
                }

                Label { text: "O+" }
                TextField {
                    id: oPositiveField
                    placeholderText: qsTr("Amount in ml")
                    validator: IntValidator {bottom: 0; top: 100000;}
                }

                Label { text: "O-" }
                TextField {
                    id: oNegativeField
                    placeholderText: qsTr("Amount in ml")
                    validator: IntValidator {bottom: 0; top: 100000;}
                }
            }
        }
    }

    Component {
        id: scheduleAppointmentDialog
        Dialog {
            title: qsTr("Schedule Appointment")
            standardButtons: Dialog.Ok | Dialog.Cancel
            onAccepted: {
                if (!validateAppointmentInputs()) {
                    return;
                }

                busyIndicator.running = true
                var success = dbManager.appointmentManager().scheduleAppointment(
                    donorEmailField.text,
                    hospitalEmail,
                    new Date(appointmentDateField.text + " " + appointmentTimeField.text)
                )
                busyIndicator.running = false

                if (success) {
                    // Refresh the appointment list
                    tabBar.currentIndex = 1 // Switch to Appointments tab
                } else {
                    showError(qsTr("Failed to schedule appointment. Please try again."))
                }
            }

            ColumnLayout {
                TextField {
                    id: donorEmailField
                    placeholderText: qsTr("Donor Email")
                    Layout.fillWidth: true
                }

                TextField {
                    id: appointmentDateField
                    placeholderText: qsTr("Appointment Date (YYYY-MM-DD)")
                    Layout.fillWidth: true
                    inputMask: "9999-99-99"
                }

                TextField {
                    id: appointmentTimeField
                    placeholderText: qsTr("Appointment Time (HH:MM)")
                    Layout.fillWidth: true
                    inputMask: "99:99"
                }
            }

            function validateAppointmentInputs() {
                if (donorEmailField.text.trim() === "" || !isValidEmail(donorEmailField.text)) {
                    showError(qsTr("Please enter a valid donor email address."))
                    return false;
                }
                if (appointmentDateField.text.trim() === "" || !isValidDate(appointmentDateField.text)) {
                    showError(qsTr("Please enter a valid appointment date."))
                    return false;
                }
                if (appointmentTimeField.text.trim() === "" || !isValidTime(appointmentTimeField.text)) {
                    showError(qsTr("Please enter a valid appointment time."))
                    return false;
                }
                return true;
            }

            function isValidEmail(email) {
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }

            function isValidDate(date) {
                var dateRegex = /^\d{4}-\d{2}-\d{2}$/;
                if (!dateRegex.test(date)) return false;
                var parts = date.split("-");
                var year = parseInt(parts[0], 10);
                var month = parseInt(parts[1], 10);
                var day = parseInt(parts[2], 10);
                if (year < 2000 || year > 2100 || month == 0 || month > 12) return false;
                var monthLength = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
                if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)) monthLength[1] = 29;
                return day > 0 && day <= monthLength[month - 1];
            }

            function isValidTime(time) {
                var timeRegex = /^([01]\d|2[0-3]):([0-5]\d)$/;
                return timeRegex.test(time);
            }
        }
    }

    function showError(message) {
        var dialog = errorDialog.createObject(hospitalDashboardPage, {errorMessage: message})
        dialog.open()
    }

    Component {
        id: errorDialog
        Dialog {
            property string errorMessage: ""
            title: qsTr("Error")
            standardButtons: Dialog.Ok

            Label {
                text: errorMessage
                wrapMode: Text.Wrap
            }
        }
    }
}
