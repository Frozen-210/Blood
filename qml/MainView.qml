import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    background: Rectangle {
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 100
            color: theme.primaryColor

            Label {
                anchors.centerIn: parent
                text: "BloodBound"
                font: theme.headerFont
                color: "white"
            }
        }

        // Main content
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Left side with image
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.4
                color: theme.primaryColor

                Image {
                    source: "../../Pictures/blood-donation-background.jpg"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.2
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 20
                    width: parent.width * 0.8

                    Image {
                        source: "../../Pictures/Logo.png"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: Math.min(parent.width * 0.6, 180)
                        Layout.preferredHeight: Layout.preferredWidth
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        text: qsTr("Connecting donors and hospitals")
                        font: theme.bodyFont
                        color: "white"
                        opacity: 0.9
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            // Right side with tabs and buttons
            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: theme.backgroundColor

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 30
                    width: Math.min(parent.width * 0.8, 400)

                    Label {
                        text: qsTr("Welcome to BloodBound")
                        font: theme.subHeaderFont
                        color: theme.textColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    TabBar {
                        id: tabBar
                        Layout.fillWidth: true
                        background: Rectangle {
                            color: "transparent"
                        }

                        TabButton {
                            text: qsTr("Donor")
                            width: implicitWidth
                            font: theme.buttonFont
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                opacity: parent.checked ? 1.0 : 0.7
                                color: parent.checked ? theme.primaryColor : theme.textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: "transparent"
                                Rectangle {
                                    width: parent.width
                                    height: 3
                                    anchors.bottom: parent.bottom
                                    color: parent.checked ? theme.primaryColor : "transparent"
                                }
                            }
                        }

                        TabButton {
                            text: qsTr("Hospital")
                            width: implicitWidth
                            font: theme.buttonFont
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                opacity: parent.checked ? 1.0 : 0.7
                                color: parent.checked ? theme.accentColor : theme.textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: "transparent"
                                Rectangle {
                                    width: parent.width
                                    height: 3
                                    anchors.bottom: parent.bottom
                                    color: parent.checked ? theme.accentColor : "transparent"
                                }
                            }
                        }
                    }

                    StackLayout {
                        currentIndex: tabBar.currentIndex
                        Layout.fillWidth: true

                        // Donor options
                        ColumnLayout {
                            spacing: 15
                            CustomButton {
                                text: qsTr("Donor Login")
                                buttonColor: theme.primaryColor
                                onClicked: stackView.push("../auth/UserLoginPage.qml")
                                Layout.fillWidth: true
                            }
                            CustomButton {
                                text: qsTr("Donor Sign Up")
                                buttonColor: "transparent"
                                textColor: theme.primaryColor
                                onClicked: stackView.push("../auth/UserSignupPage.qml")
                                Layout.fillWidth: true
                            }
                        }

                        // Hospital options
                        ColumnLayout {
                            spacing: 15
                            CustomButton {
                                text: qsTr("Hospital Login")
                                buttonColor: theme.accentColor
                                onClicked: stackView.push("../auth/HospitalLoginPage.qml")
                                Layout.fillWidth: true
                            }
                            CustomButton {
                                text: qsTr("Hospital Sign Up")
                                buttonColor: "transparent"
                                textColor: theme.accentColor
                                onClicked: stackView.push("../auth/HospitalSignupPage.qml")
                                Layout.fillWidth: true
                            }
                        }
                    }

                    CustomButton {
                        text: qsTr("Learn More")
                        buttonColor: "#4CAF50"
                        onClicked: stackView.push("../common/LearnMorePage.qml")
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
