import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    property string hospitalEmail: ""
    property var hospitalData: ({})

    background: Rectangle {
        color: theme.backgroundColor
    }

    Component.onCompleted: {
        hospitalData = dbManager.hospitalManager().getHospitalData(hospitalEmail)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: theme.accentColor

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Label {
                    text: "Welcome, " + (hospitalData.name || "")
                    font: theme.headerFont
                    color: "white"
                }

                Item { Layout.fillWidth: true }

                CustomButton {
                    text: "Logout"
                    buttonColor: "white"
                    textColor: theme.accentColor
                    onClicked: logout()
                }
            }
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabButton {
                text: qsTr("Profile")
            }
            TabButton {
                text: qsTr("Inventory")
            }
            TabButton {
                text: qsTr("Appointments")
            }
        }

        StackLayout {
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            HospitalProfilePage {
                hospitalData: hospitalData
            }

            HospitalInventoryPage {
                hospitalEmail: hospitalEmail
            }

            HospitalAppointmentsPage {
                hospitalEmail: hospitalEmail
            }
        }
    }

    function logout() {
        // Implement logout logic here
        stackView.pop(null)
    }
}
