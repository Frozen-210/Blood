import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: learnMorePage

    property color primaryColor: "#E53935"
    property color accentColor: "#1E88E5"
    property color backgroundColor: "#F5F5F5"
    property color cardColor: "#FFFFFF"
    property color textColor: "#333333"
    property color lightTextColor: "#757575"
    property color cardBorderColor: "#E0E0E0"

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
                gradient: Gradient {
                    GradientStop { position: 0.0; color: primaryColor }
                    GradientStop { position: 1.0; color: Qt.darker(primaryColor, 1.2) }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "Learn About Blood Donation"
                        font.pixelSize: 32
                        font.weight: Font.Bold
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Discover how you can make a life-saving difference"
                        font.pixelSize: 18
                        color: "white"
                        opacity: 0.9
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Content
            ColumnLayout {
                Layout.fillWidth: true
                Layout.margins: 20
                spacing: 30

                InfoCard {
                    title: "The Importance of Blood Donation"
                    icon: "icons/heart.svg"
                    content: "Blood donation is a critical lifeline for millions of people worldwide. Every day, countless lives are saved through the generosity of blood donors. Here's why your donation matters:

• Emergency situations: Accidents, natural disasters, and medical emergencies often require large quantities of blood.
• Chronic conditions: Patients with diseases like sickle cell anemia and thalassemia need regular transfusions.
• Surgeries: Many complex medical procedures rely on blood donations.
• Cancer treatments: Chemotherapy can deplete blood cells, making transfusions necessary.
• Childbirth complications: Some pregnancies require blood transfusions to save both mother and child.

By donating blood, you become an unsung hero, directly contributing to saving lives in your community and beyond."
                }

                InfoCard {
                    title: "Types of Blood Donations"
                    icon: "icons/blood-drop.svg"
                    content: "There are several ways to donate blood, each serving different medical needs:

1. Whole Blood Donation
   • Most common type of donation
   • Takes about 10 minutes
   • Donatable every 56 days

2. Platelet Donation (Apheresis)
   • Crucial for cancer patients and trauma victims
   • Takes about 2-3 hours
   • Donatable every 7 days, up to 24 times a year

3. Plasma Donation
   • Used for patients with liver failure, severe infections, and burn victims
   • Takes about 1-2 hours
   • Donatable every 28 days

4. Power Red Donation
   • Allows you to donate two units of red blood cells
   • Takes about 30 minutes longer than whole blood donation
   • Donatable every 112 days, up to 3 times a year

Each type of donation is valuable and can help different patients in need. Consult with your local blood center to determine which type of donation is best for you."
                }

                InfoCard {
                    title: "Eligibility and Preparation"
                    icon: "icons/checklist.svg"
                    content: "To ensure the safety of both donors and recipients, there are some eligibility requirements for blood donation. While these may vary slightly depending on your location, general guidelines include:

• Age: Usually 17 or older (16 with parental consent in some areas)
• Weight: At least 110 pounds (50 kg)
• Health: Generally good health and feeling well
• Identification: Valid ID required

Before donating:
• Get a good night's sleep
• Eat a healthy meal
• Drink extra water
• Bring a list of medications you're taking

Some factors that might temporarily disqualify you:
• Recent travel to certain countries
• Certain medications
• Recent tattoos or piercings
• Pregnancy or recent childbirth

Remember, these guidelines are for your safety and the safety of potential recipients. Always be honest about your health history when donating blood."
                }

                InfoCard {
                    title: "The Donation Process"
                    icon: "icons/process.svg"
                    content: "Donating blood is a simple and rewarding process. Here's what you can expect:

1. Registration (5-10 minutes)
   • Sign in and show identification
   • Review basic eligibility requirements

2. Health History and Mini-Physical (10-15 minutes)
   • Complete a confidential questionnaire about your health history
   • Undergo a quick check of temperature, blood pressure, pulse, and hemoglobin levels

3. The Donation (8-10 minutes for whole blood)
   • A sterile needle is inserted for the blood draw
   • You'll be seated comfortably during the process
   • Staff will ensure you're feeling well throughout

4. Refreshments and Recovery (10-15 minutes)
   • Enjoy snacks and drinks
   • Rest for a short period before leaving

5. Post-Donation Care
   • Follow staff instructions for self-care after donation
   • Resume normal activities, avoiding strenuous exercise for 24 hours

The entire process usually takes about an hour, with the actual blood draw only lasting about 10 minutes. Your comfort and safety are priorities throughout the donation process."
                }

                InfoCard {
                    title: "Blood Types and Compatibility"
                    icon: "icons/blood-types.svg"
                    content: "Understanding blood types is crucial for effective transfusions. There are eight main blood types, determined by the presence or absence of A and B antigens on red blood cells and the Rh factor:

• A positive (A+)
• A negative (A-)
• B positive (B+)
• B negative (B-)
• O positive (O+)
• O negative (O-)
• AB positive (AB+)
• AB negative (AB-)

Key facts:
• O negative is the universal donor for red blood cells
• AB positive is the universal recipient
• O positive is the most common blood type
• AB negative is the rarest blood type

Compatibility:
• Type O can donate red blood cells to all types
• Type AB can receive red blood cells from all types
• For plasma donation, the situation is reversed

Your blood type is valuable regardless of its rarity. Blood centers need a diverse supply to meet all patient needs effectively."
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    color: accentColor
                    radius: 10

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 20

                        Text {
                            text: "Ready to save lives?"
                            font.pixelSize: 24
                            font.weight: Font.Bold
                            color: "white"
                        }

                        Button {
                            text: "Schedule a Donation"
                            font.pixelSize: 18
                            padding: 15

                            background: Rectangle {
                                color: "white"
                                radius: 5
                            }

                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: accentColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                // Navigate to donation scheduling page or open external link
                            }
                        }
                    }
                }
            }

            // Footer
            Rectangle {
                Layout.fillWidth: true
                height: 80
                color: Qt.darker(backgroundColor, 1.05)

                Text {
                    text: "© 2024 BloodBound. Empowering communities through blood donation."
                    font.pixelSize: 14
                    color: lightTextColor
                    anchors.centerIn: parent
                }
            }
        }
    }

    // Custom component for information cards
    component InfoCard: Rectangle {
        property string title
        property string icon
        property string content

        Layout.fillWidth: true
        height: cardContent.height + 40
        color: cardColor
        radius: 10
        border.color: cardBorderColor
        border.width: 1

        ColumnLayout {
            id: cardContent
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
            spacing: 15

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: icon
                    sourceSize.width: 24
                    sourceSize.height: 24
                }

                Text {
                    text: title
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: primaryColor
                }
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
}
