import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    property var userData: ({})

    background: Rectangle {
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Label {
            text: "User Profile"
            font: theme.headerFont
            color: theme.primaryColor
        }

        GridLayout {
            columns: 2
            rowSpacing: 10
            columnSpacing: 20

            Label { text: "Name:"; font.bold: true }
            Label { text: userData.name || "" }

            Label { text: "Email:"; font.bold: true }
            Label { text: userData.email || "" }

            Label { text: "Blood Group:"; font.bold: true }
            Label { text: userData.bloodGroup || "" }

            Label { text: "Health Info:"; font.bold: true }
            Label { text: userData.healthInfo || "N/A" }
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
