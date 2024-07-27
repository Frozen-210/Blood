import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: learnMorePage

    property color primaryColor: "#E53935"
    property color accentColor: "#1E88E5"
    property color backgroundColor: "#FFFFFF"
    property color textColor: "#333333"
    property color lightTextColor: "#757575"

    background: Rectangle {
        color: backgroundColor
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: parent.width
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 0

            // Header
            Rectangle {
                Layout.fillWidth: true
                height: 200
                color: primaryColor

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "BloodBound"
                            font.pixelSize: 36
                            font.weight: Font.Bold
                            color: "white"
                        }

                        Text {
                            text: "Learn More About Blood Donation"
                            font.pixelSize: 24
                            color: "white"
                            opacity: 0.9
                        }
                    }

                    Rectangle {
                        width: 100
                        height: 100
                        radius: 50
                        color: "white"

                        Text {
                            anchors.centerIn: parent
                            text: "BB"
                            font.pixelSize: 40
                            font.weight: Font.Bold
                            color: primaryColor
                        }
                    }
                }
            }

            // Content
            ColumnLayout {
                Layout.fillWidth: true
                Layout.margins: 40
                spacing: 40

                // Why Donate Blood?
                ContentSection {
                    title: "Why Donate Blood?"
                    content: "Blood donation is a vital way to help save lives. When you donate blood, you're giving someone another chance at life. One donation can save up to three lives! Your contribution can make a significant difference in emergency situations, surgeries, and for patients with chronic illnesses."
                }

                // Who Can Donate?
                ContentSection {
                    title: "Who Can Donate?"
                    content: "In general, to donate blood you must be:
• In good health
• At least 17 years old in most states
• Weigh at least 110 pounds
• Have not donated blood in the last 56 days

It's important to note that eligibility criteria may vary. Some medical conditions or medications may affect your ability to donate. Always consult with the donation center or your healthcare provider if you have any concerns."
                }

                // The Donation Process
                ContentSection {
                    title: "The Donation Process"
                    content: "The blood donation process is simple and safe. Here's what you can expect:

1. Registration: Sign in and show identification.
2. Medical History and Mini-Physical: Answer questions about your health and undergo a quick check of your temperature, pulse, blood pressure, and hemoglobin levels.
3. Donation: The actual blood donation typically takes about 8-10 minutes.
4. Refreshments and Rest: Enjoy some snacks and drinks while resting for about 15 minutes before leaving.

The entire process usually takes about an hour, with the actual donation only a small part of that time."
                }

                // After Donating
                ContentSection {
                    title: "After Donating"
                    content: "To ensure a smooth recovery after donating:
• Drink extra fluids for the next day or two
• Avoid strenuous physical activity or heavy lifting for about five hours
• If you feel lightheaded, lie down with your feet up until the feeling passes
• Keep the bandage on your arm for a few hours
• Eat well-balanced meals for the next few days

Remember, your body will replenish the fluid loss within 24 hours, but it takes about 4-6 weeks to fully replace the donated red blood cells."
                }

                // Call to Action
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    color: accentColor
                    radius: 10

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: "Ready to Make a Difference?"
                            font.pixelSize: 24
                            font.weight: Font.Bold
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Button {
                            text: "Sign Up to Donate"
                            Layout.preferredWidth: 350
                            Layout.preferredHeight: 50
                            font.pixelSize: 18
                            font.weight: Font.Medium
                            onClicked: stackView.push("../auth/UserSignupPage.qml")
                            background: Rectangle {
                                color: "white"
                                radius: 25
                            }
                        }
                    }
                }

                // Back to Main Menu
                Button {
                    text: "Back to Main Menu"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 40
                    font.pixelSize: 16
                    onClicked: stackView.pop()
                    background: Rectangle {
                        color: "transparent"
                        border.color: primaryColor
                        border.width: 2
                        radius: 15
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: parent.font.pixelSize
                        color: primaryColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // Footer
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "#F5F5F5"

                Text {
                    text: "© 2024 BloodBound. All rights reserved."
                    font.pixelSize: 14
                    color: lightTextColor
                    anchors.centerIn: parent
                }
            }
        }
    }

    // Custom component for content sections
    component ContentSection: ColumnLayout {
        property string title
        property string content

        Layout.fillWidth: true
        spacing: 15

        Text {
            text: title
            font.pixelSize: 28
            font.weight: Font.Bold
            color: primaryColor
        }

        Text {
            text: content
            font.pixelSize: 16
            color: textColor
            wrapMode: Text.Wrap
            lineHeight: 1.4
            Layout.fillWidth: true
        }
    }
}
