// main.qml
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Window {
    id: mainWindow
    width: 1024
    height: 768
    visible: true
    title: qsTr("BloodBound")

    ThemeColors {
        id: theme
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainView
    }

    Component {
        id: mainView
        MainView {}
    }

    Dialog {
        id: errorDialog
        title: qsTr("Error")
        standardButtons: Dialog.Ok

        Label {
            text: errorDialog.text
            wrapMode: Text.Wrap
            color: theme.textColor
        }

        background: Rectangle {
            color: theme.backgroundColor
            border.color: theme.primaryColor
            border.width: 1
            radius: 5
        }
    }

    function showError(message) {
        errorDialog.text = message;
        errorDialog.open();
    }

    Component.onCompleted: {
        if (!dbManager.isDatabaseConnected()) {
            showError(qsTr("Failed to connect to the database. Please check your configuration."));
        }
    }
}
