import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: customButton
    
    property color buttonColor: theme.accentColor
    property color textColor: "white"
    
    contentItem: Text {
        text: customButton.text
        font: theme.buttonFont
        color: textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    background: Rectangle {
        color: customButton.down ? Qt.darker(buttonColor, 1.2) : buttonColor
        radius: 5
    }
}
