import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    property var hospitalData: ({})

    background: Rectangle {
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Label {
            text: "Hospital Profile"
            font: theme.headerFont
            color: theme.accentColor
        }

        GridLayout {
            columns: 2
            rowSpacing: 10
            columnSpacing: 20

            Label { text: "Name:"; font.bold: true }
            Label { text: hospitalData.name || "" }

            Label { text: "Email:"; font.bold: true }
            Label { text: hospitalData.email || "" }

            Label { text: "Contact Number:"; font.bold: true }
            Label { text: hospitalData.contactNumber || "" }

            Label { text: "Address:"; font.bold: true }
            Label { text: hospitalData.address || "" }

            Label { text: "City:"; font.bold: true }
            Label { text: hospitalData.city || "" }

            Label { text: "State:"; font.bold: true }
            Label { text: hospitalData.state || "" }

            Label { text: "Country:"; font.bold: true }
            Label { text: hospitalData.country || "" }

            Label { text: "ZIP Code:"; font.bold: true }
            Label { text: hospitalData.zip || "" }

            Label { text: "License Number:"; font.bold: true }
            Label { text: hospitalData.license || "" }
        }

        CustomButton {
            text: "Edit Profile"
            onClicked: editProfile()
        }
    }

    function editProfile() {
        // Implement edit profile functionality
        console.log("Edit profile clicked")
    }
}
