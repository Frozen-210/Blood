import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    property var userData: ({})
    signal editProfile()

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label { text: "Name: " + (userData ? userData.name : "") }
        Label { text: "Email: " + (userData ? userData.email : "") }
        Label { text: "Blood Group: " + (userData ? userData.bloodGroup : "") }
        Label { text: "Health Info: " + (userData ? userData.healthInfo : "") }

        Button {
            text: "Edit Profile"
            onClicked: editProfile()
        }
    }
}
