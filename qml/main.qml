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

    Component.onCompleted: {
        if (!dbManager.isDatabaseConnected()) {
            showError(qsTr("Database Connection Error"), 
                      qsTr("Failed to connect to the database. Please check your configuration."));
        }
    }
}
