import QtQuick 2.15


QtObject {
    id: theme
    property color primaryColor: "#E53935"
    property color accentColor: "#1E88E5"
    property color backgroundColor: "#FFFFFF"
    property color textColor: "#212121"
    property color lightTextColor: "#000000"
    property color cardColor: "#FFFFFF"
    property color cardBorderColor: "#E0E0E0"
    property font headerFont: Qt.font({ family: "Noto Serif Tibetan", pixelSize: 32, weight: Font.Bold })
    property font subHeaderFont: Qt.font({ family: "Bitter", pixelSize: 24, weight: Font.DemiBold })
    property font bodyFont: Qt.font({ family: "Noto Serif Tibetan", pixelSize: 16 })
    property font buttonFont: Qt.font({ family: "Bitter", pixelSize: 16, weight: Font.Medium })
}
