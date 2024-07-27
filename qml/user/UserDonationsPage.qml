import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    property string userEmail: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label { 
            text: "Donation History"
            font.pixelSize: 20
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: dbManager.donationManager().getUserDonationHistory(userEmail)
            delegate: ItemDelegate {
                text: modelData.date + " - " + modelData.amount + "ml"
            }
        }
    }
}
