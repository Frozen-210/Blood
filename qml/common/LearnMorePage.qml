import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Page {
    background: Rectangle {
        color: theme.backgroundColor
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            width: parent.width
            spacing: 20

            Label {
                text: "Learn More About Blood Donation"
                font: theme.headerFont
                color: theme.primaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: "Why Donate Blood?"
                font.pixelSize: 18
                font.bold: true
                color: theme.accentColor
            }

            Label {
                text: "Blood donation is a vital way to help save lives. When you donate blood, you're giving someone another chance at life. One donation can save up to three lives!"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Label {
                text: "Who Can Donate?"
                font.pixelSize: 18
                font.bold: true
                color: theme.accentColor
            }

            Label {
                text: "Most people can donate blood if they are in good health and:\n• Are at least 17 years old\n• Weigh at least 110 pounds\n• Have not donated blood in the last 56 days"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Label {
                text: "The Donation Process"
                font.pixelSize: 18
                font.bold: true
                color: theme.accentColor
            }

            Label {
                text: "1. Registration\n2. Medical History and Mini-Physical\n3. Donation\n4. Refreshments and Rest"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            CustomButton {
                text: "Back to Main Menu"
                onClicked: stackView.pop()
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
