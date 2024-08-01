import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components"

Dialog {
    id: root
    title: "Schedule Donation"
    width: 400
    height: 500
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    property string userEmail: ""
    signal donationScheduled()

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        CustomComboBox {
            id: hospitalCombo
            Layout.fillWidth: true
            model: dbManager.hospitalManager().getHospitalList()
            textRole: "name"
            displayText: currentIndex === -1 ? "Select Hospital" : currentText
        }

        CustomTextField {
            id: dateField
            Layout.fillWidth: true
            placeholderText: "Donation Date (YYYY-MM-DD)"
            inputMask: "9999-99-99"
            text: Qt.formatDate(new Date(), "yyyy-MM-dd")  // Set current date as default
        }

        CustomComboBox {
            id: timeCombo
            Layout.fillWidth: true
            model: ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM"]
            displayText: currentIndex === -1 ? "Select Time" : currentText
        }

        CustomTextField {
            id: lastDonationField
            Layout.fillWidth: true
            placeholderText: "Last Donation Date (YYYY-MM-DD)"
            inputMask: "9999-99-99"
        }
    }

    onAccepted: {
        if (validateInputs()) {
            var dateTimeString = dateField.text + " " + timeCombo.currentText
            var success = dbManager.donationManager().scheduleDonation(
                userEmail,
                hospitalCombo.currentValue.email,
                dateTimeString,
                lastDonationField.text
            )
            if (success) {
                donationScheduled()
            } else {
                errorDialog.showError(qsTr("Failed"),qsTr("Failed to schedule donation. Please try again."))
            }
        }
    }

    function validateInputs() {
        if (hospitalCombo.currentIndex === -1) {
            showError(qsTr("No hospital selected"),qsTr("Please select a hospital."))
            return false
        }
        if (!isValidDate(dateField.text)) {
            showError(qsTr("Invalid Date").qsTR("Please enter a valid donation date."))
            return false
        }
        if (timeCombo.currentIndex === -1) {
            showError(qsTr("Invalid time"),qsTr("Please select a time."))
            return false
        }
        if (!isValidDate(lastDonationField.text)) {
            showError(qsTr("Invalid date"),qsTr("Please enter a valid last donation date."))
            return false
        }
        return true
    }

    function isValidDate(dateString) {
        var regex = /^\d{4}-\d{2}-\d{2}$/;
        if (!regex.test(dateString)) return false;

        var parts = dateString.split("-");
        var year = parseInt(parts[0], 10);
        var month = parseInt(parts[1], 10);
        var day = parseInt(parts[2], 10);

        if (year < 2000 || year > 2100 || month == 0 || month > 12) return false;

        var monthLength = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        // Adjust for leap years
        if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)) {
            monthLength[1] = 29;
        }

        return day > 0 && day <= monthLength[month - 1];
    }

    ErrorDialog {
        id: errorDialog
    }
}
