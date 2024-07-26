import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    property string hospitalEmail: ""

    background: Rectangle {
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Label {
            text: "Upcoming Appointments"
            font: theme.headerFont
            color: theme.accentColor
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: dbManager.appointmentManager().getHospitalAppointments(hospitalEmail)
            delegate: ItemDelegate {
                width: parent.width
                contentItem: RowLayout {
                    Label { text: modelData.date; Layout.preferredWidth: 150 }
                    Label { text: modelData.userName; Layout.preferredWidth: 200 }
                    Label { text: "Blood Group: " + modelData.bloodGroup; Layout.fillWidth: true }
                    CustomButton {
                        text: "Cancel"
                        onClicked: cancelAppointment(modelData.id)
                    }
                }
            }
        }

        CustomButton {
            text: "Schedule New Appointment"
            onClicked: scheduleNewAppointment()
        }
    }

    function cancelAppointment(appointmentId) {
        busyIndicator.running = true
        var success = dbManager.appointmentManager().cancelAppointment(appointmentId)
        busyIndicator.running = false

        if (success) {
            // Refresh the appointments list
            model = dbManager.appointmentManager().getHospitalAppointments(hospitalEmail)
        } else {
            showError("Failed to cancel appointment. Please try again.")
        }
    }

    function scheduleNewAppointment() {
        // Implement schedule new appointment functionality
        console.log("Schedule new appointment clicked")
    }
}
