import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components"

Dialog {
    id: root
    title: qsTr("Book New Appointment")
    width: 400
    height: 500
    modal: true
    closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

    property string userEmail: ""
    signal appointmentBooked()

    Material.theme: Material.Light
    Material.accent: theme.accentColor
    Material.primary: theme.primaryColor

    background: Rectangle {
        color: "white"
        radius: 10
        border.color: Qt.lighter(theme.primaryColor, 1.5)
        border.width: 1
    }

    header: Rectangle {
        color: theme.primaryColor
        height: 60
        radius: 10
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 10
            color: parent.color
        }

        Label {
            anchors.centerIn: parent
            text: root.title
            color: "white"
            font.pixelSize: 18
            font.weight: Font.Medium
        }
    }

    contentItem: ColumnLayout {
        spacing: 20
        anchors.margins: 20

        Label {
            text: qsTr("Please fill in the appointment details")
            font.pixelSize: 14
            color: theme.textColor
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }

        ComboBox {
            id: hospitalCombo
            model: dbManager.hospitalManager().getHospitalList()
            textRole: "name"
            Layout.fillWidth: true
            Material.foreground: theme.textColor
            Material.accent: theme.accentColor
            
            background: Rectangle {
                color: hospitalCombo.pressed ? Qt.darker(theme.backgroundColor, 1.05) : theme.backgroundColor
                border.color: hospitalCombo.activeFocus ? theme.accentColor : theme.lightTextColor
                border.width: hospitalCombo.activeFocus ? 2 : 1
                radius: 5
            }

            popup.background: Rectangle {
                color: theme.backgroundColor
                border.color: theme.lightTextColor
                radius: 5
            }
        }

        TextField {
            id: dateField
            placeholderText: qsTr("Date (YYYY-MM-DD)")
            Layout.fillWidth: true
            inputMask: "9999-99-99"
            Material.foreground: theme.textColor
            Material.accent: theme.accentColor

            background: Rectangle {
                color: dateField.enabled ? (dateField.activeFocus ? Qt.lighter(theme.backgroundColor, 1.1) : theme.backgroundColor) : theme.disabledColor
                border.color: dateField.activeFocus ? theme.accentColor : theme.lightTextColor
                border.width: dateField.activeFocus ? 2 : 1
                radius: 5
            }
        }

        ComboBox {
            id: timeCombo
            model: ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM"]
            Layout.fillWidth: true
            Material.foreground: theme.textColor
            Material.accent: theme.accentColor

            background: Rectangle {
                color: timeCombo.pressed ? Qt.darker(theme.backgroundColor, 1.05) : theme.backgroundColor
                border.color: timeCombo.activeFocus ? theme.accentColor : theme.lightTextColor
                border.width: timeCombo.activeFocus ? 2 : 1
                radius: 5
            }

            popup.background: Rectangle {
                color: theme.backgroundColor
                border.color: theme.lightTextColor
                radius: 5
            }
        }

        TextField {
            id: notesField
            placeholderText: qsTr("Additional Notes (Optional)")
            Layout.fillWidth: true
            Material.foreground: theme.textColor
            Material.accent: theme.accentColor

            background: Rectangle {
                color: notesField.enabled ? (notesField.activeFocus ? Qt.lighter(theme.backgroundColor, 1.1) : theme.backgroundColor) : theme.disabledColor
                border.color: notesField.activeFocus ? theme.accentColor : theme.lightTextColor
                border.width: notesField.activeFocus ? 2 : 1
                radius: 5
            }
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                text: qsTr("Cancel")
                Layout.fillWidth: true
                Material.background: "white"
                Material.foreground: theme.primaryColor
                onClicked: root.reject()

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.down ? Qt.darker(parent.Material.background, 1.05) : parent.Material.background
                    border.color: theme.primaryColor
                    border.width: 1
                    radius: 5
                }
            }

            Button {
                text: qsTr("Book Appointment")
                Layout.fillWidth: true
                Material.background: theme.primaryColor
                Material.foreground: "white"
                onClicked: bookAppointment()

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.down ? Qt.darker(parent.Material.background, 1.1) : parent.Material.background
                    radius: 5
                }
            }
        }
    }

    function bookAppointment() {
        if (validateInputs()) {
            var selectedDate = dateField.text
            var selectedTime = timeCombo.currentText
            var dateTimeString = selectedDate + " " + selectedTime

            var success = dbManager.appointmentManager().scheduleAppointment(
                userEmail,
                hospitalCombo.currentValue.email,
                dateTimeString,
                notesField.text
            )

            if (success) {
                appointmentBooked()
                root.accept()
            } else {
                showError("Failed to book appointment. Please try again.")
            }
        }
    }

    function validateInputs() {
        if (hospitalCombo.currentIndex === -1) {
            showError("Please select a hospital.")
            return false
        }
        if (!isValidDate(dateField.text)) {
            showError("Please enter a valid date.")
            return false
        }
        if (timeCombo.currentIndex === -1) {
            showError("Please select a time.")
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

        if (year < new Date().getFullYear() || year > 2100 || month === 0 || month > 12) return false;

        var monthLength = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        // Adjust for leap years
        if (year % 400 === 0 || (year % 100 !== 0 && year % 4 === 0)) {
            monthLength[1] = 29;
        }

        return day > 0 && day <= monthLength[month - 1];
    }

    function showError(message) {
        errorDialog.errorMessage = message
        errorDialog.open()
    }

    ErrorDialog {
        id: errorDialog
    }
}

