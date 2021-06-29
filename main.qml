import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Tabs")
    background: Rectangle {
        color: "black"
    }

    SwipeView {
        background: Rectangle {
            color: "black"
        }
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page1Form {
        }

        Page2Form {
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        background: Rectangle {
            color: "black"
        }

        TabButton {
            text: qsTr("Календарь")
            id: control

            implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                    implicitContentWidth + leftPadding + rightPadding)
            implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                     implicitContentHeight + topPadding + bottomPadding)

            padding: 6
            spacing: 6

            icon.width: 24
            icon.height: 24
            icon.color: checked ? control.palette.windowText : control.palette.brightText

            contentItem: IconLabel {
                spacing: control.spacing
                mirrored: control.mirrored
                display: control.display

                icon: control.icon
                text: control.text
                font: control.font
                color: control.checked ? "yellow" : "#333"
            }

            background: Rectangle {
                implicitHeight: 40
                color: Color.blend(control.checked ? "#333" : "#f2f20d",
                                                     control.palette.mid, control.down ? 0.5 : 0.0)
            }
        }
        TabButton {
            text: qsTr("Расписание")
            id: control1

            implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                    implicitContentWidth + leftPadding + rightPadding)
            implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                     implicitContentHeight + topPadding + bottomPadding)

            padding: 6
            spacing: 6

            icon.width: 24
            icon.height: 24
            icon.color: checked ? control1.palette.windowText : control1.palette.brightText

            contentItem: IconLabel {
                spacing: control1.spacing
                mirrored: control1.mirrored
                display: control1.display

                icon: control1.icon
                text: control1.text
                font: control1.font
                color: control1.checked ? "yellow" : "#333"
            }

            background: Rectangle {
                implicitHeight: 40
                color: Color.blend(control1.checked ? "#333" : "#f2f20d",
                                                     control1.palette.mid, control1.down ? 0.5 : 0.0)
            }
        }
    }
}
