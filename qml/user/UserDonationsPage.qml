import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    property string userEmail: ""

    background: Rectangle {
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Label {
            text: "Donation History"
            font: theme.headerFont
            color: theme.primaryColor
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: dbManager.donationManager().getUserDonationHistory(userEmail)
            delegate: ItemDelegate {
                width: parent.width
                contentItem: RowLayout {
                    Label { text: modelData.date; Layout.preferredWidth: 100 }
                    Label { text: modelData.amount + " ml"; Layout.preferredWidth: 100 }
                    Label { text: modelData.hospitalName; Layout.fillWidth: true }
                }
            }
        }

        CustomButton {
            text: "Schedule New Donation"
            onClicked: scheduleNewDonation()
        }
    }

    function scheduleNewDonation() {
        // Implement schedule new donation functionality
        console.log("Schedule new donation clicked")
    }
}
