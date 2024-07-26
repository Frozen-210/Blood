import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: customTextField
    
    color: theme.textColor
    font: theme.bodyFont
    
    background: Rectangle {
        color: "#F8F8F8"
        radius: 5
        border.color: customTextField.activeFocus ? theme.accentColor : "#DDDDDD"
        border.width: customTextField.activeFocus ? 2 : 1
    }
    
    selectByMouse: true
}
