import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    property string userEmail: ""
    signal bookAppointment()

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label { 
            text: "Upcoming Appointments"
            font.pixelSize: 20
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: dbManager.appointmentManager().getUserAppointments(userEmail)
            delegate: ItemDelegate {
                text: modelData.date + " - " + modelData.hospitalName
                trailing: Button {
                    text: "Cancel"
                    onClicked: cancelAppointment(modelData.id)
                }
            }
        }

        Button {
            text: "Book New Appointment"
            onClicked: bookAppointment()
        }
    }

    function cancelAppointment(appointmentId) {
        dbManager.appointmentManager().cancelAppointment(appointmentId)
        // Refresh the appointment list
        model = dbManager.appointmentManager().getUserAppointments(userEmail)
    }
}
