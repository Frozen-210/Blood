import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    id: root
    property string userEmail: ""
    property var userData: ({})

    background: Rectangle {
        color: "#36393f"  // Discord dark background
    }

    Component.onCompleted: {
        userData = dbManager.userManager().getUserData(userEmail)
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left sidebar (Server list in Discord)
        Rectangle {
            Layout.preferredWidth: 70
            Layout.fillHeight: true
            color: "#202225"  // Discord darker sidebar

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 10
                    width: 50
                    height: 50
                    radius: 25
                    color: theme.primaryColor

                    Label {
                        anchors.centerIn: parent
                        text: userData.name ? userData.name[0].toUpperCase() : "U"
                        font.pixelSize: 24
                        color: "white"
                    }
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 50
                    height: 50
                    radius: 25
                    color: "#40444b"

                    Label {
                        anchors.centerIn: parent
                        text: "+"
                        font.pixelSize: 24
                        color: "#43b581"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Add new action clicked")
                    }
                }
            }
        }

        // Channel list and content area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Channel list
            Rectangle {
                Layout.preferredWidth: 240
                Layout.fillHeight: true
                color: "#2f3136"  // Discord channel list background

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
                        color: "#292b2f"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10

                            Label {
                                text: userData.name || "User"
                                font.pixelSize: 16
                                color: "white"
                            }

                            Item { Layout.fillWidth: true }

                            CustomButton {
                                text: "Logout"
                                buttonColor: "#40444b"
                                textColor: "white"
                                onClicked: logout()
                            }
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: ["Profile", "Donations", "Appointments"]
                        delegate: ItemDelegate {
                            width: parent.width
                            height: 40
                            
                            contentItem: RowLayout {
                                Image {
                                    source: "qrc:/images/" + modelData.toLowerCase() + "_icon.png"
                                    Layout.preferredWidth: 20
                                    Layout.preferredHeight: 20
                                }
                                Label {
                                    text: modelData
                                    color: "white"
                                    font.pixelSize: 16
                                }
                            }
                            
                            background: Rectangle {
                                color: tabBar.currentIndex === index ? "#40444b" : "transparent"
                            }
                            
                            onClicked: tabBar.currentIndex = index
                        }
                    }
                }
            }

            // Content area
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    color: "#36393f"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10

                        Label {
                            text: ["Profile", "Donations", "Appointments"][tabBar.currentIndex]
                            font.pixelSize: 16
                            color: "white"
                        }
                    }
                }

                TabBar {
                    id: tabBar
                    Layout.fillWidth: true
                    visible: false  // Hidden, but used for state management
                }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: tabBar.currentIndex

                    UserProfilePage {
                        userData: userData
                    }

                    UserDonationsPage {
                        userEmail: userEmail
                    }

                    UserAppointmentsPage {
                        userEmail: userEmail
                    }
                }
            }
        }
    }

    function logout() {
        // Implement logout logic here
        stackView.pop(null)
    }
}
