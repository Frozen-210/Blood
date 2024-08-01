import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components"

Dialog {
    id: root
    title: "Message"
    width: 300
    height: 200
    modal: true
    standardButtons: Dialog.Ok

    property alias text: messageLabel.text

    background: Rectangle {
        color: theme.backgroundColor
        border.color: theme.accentColor
        border.width: 2
        radius: 10
    }

    header: Rectangle {
        color: theme.accentColor
        height: 50
        width: parent.width

        Label {
            anchors.centerIn: parent
            text: root.title
            color: "white"
            font: theme.headerFont
        }
    }

    Label {
        id: messageLabel
        anchors.fill: parent
        wrapMode: Text.Wrap
        font: theme.bodyFont
        color: theme.accentColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
