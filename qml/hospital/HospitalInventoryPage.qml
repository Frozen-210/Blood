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
            text: "Blood Inventory"
            font: theme.headerFont
            color: theme.accentColor
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

        CustomButton {
            text: "Update Inventory"
            onClicked: updateInventory()
        }
    }

    function updateInventory() {
        // Implement update inventory functionality
        console.log("Update inventory clicked")
    }
}
