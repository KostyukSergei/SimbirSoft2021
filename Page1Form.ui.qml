import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls 2.5

Page {
    width: 600
    height: 400
    background: Rectangle {
        color: "#555"
    }

    Connections {
        target: connector
    }

    Component.onCompleted: {
        connector.fromCalendar(calen.selectedDate)
    }

    Calendar {
        id: calen
        x: 203
        y: 0
        width: 599
        height: 400
        anchors.fill: parent
        locale: Qt.locale("ru_RU")

        onClicked: {
            connector.fromCalendar(calen.selectedDate)
        }

        style: CalendarStyle {
            property date temp: new Date()
            property date currentDate: new Date(temp.getFullYear(),
                                                temp.getMonth(),
                                                temp.getDate(), 12, 0, 0, 0)
            gridVisible: false
            gridColor: "transparent"

            dayDelegate: Rectangle {
                gradient: Gradient {
                    GradientStop {
                        position: 0.00
                        color: styleData.selected ? "#111111" : (styleData.visibleMonth ? "#444" : "#555")
                    }
                    GradientStop {
                        position: 1.00
                        color: styleData.selected ? "#b3b300" : (styleData.visibleMonth ? "#111" : "#555")
                    }
                    GradientStop {
                        position: 1.00
                        color: styleData.selected ? "#ffff00" : (styleData.visibleMonth ? "#111" : "#555")
                    }
                }

                Label {
                    text: styleData.date.getDate()
                    anchors.centerIn: parent
                    color: "yellow"
                }

                Rectangle {
                    width: parent.width
                    height: 0.5
                    color: (styleData.date.toString() === currentDate.toString(
                                )) ? "yellow" : "#333"
                    anchors.bottom: parent.bottom
                }
                Rectangle {
                    width: parent.width
                    height: 1
                    color: (styleData.date.toString() === currentDate.toString(
                                )) ? "yellow" : "#333"
                    anchors.top: parent.top
                }
                Rectangle {
                    width: 0.5
                    height: parent.height
                    color: (styleData.date.toString() === currentDate.toString(
                                )) ? "yellow" : "#333"
                    anchors.right: parent.right
                }
                Rectangle {
                    width: 1
                    height: parent.height
                    color: (styleData.date.toString() === currentDate.toString(
                                )) ? "yellow" : "#333"
                    anchors.left: parent.left
                }
            }

            background: Rectangle {
                color: "#f2f20d"
            }

            navigationBar: Rectangle {
                height: Math.round(TextSingleton.implicitHeight * 2.73)
                color: "#333"

                HoverButton {
                    id: previousMonth
                    width: parent.height
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    source: "Arrow_Left.gif"
                    onClicked: control.showPreviousMonth()
                }
                Label {
                    id: dateText
                    text: styleData.title
                    color: "yellow"
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: TextSingleton.implicitHeight * 1.25
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: previousMonth.right
                    anchors.leftMargin: 2
                    anchors.right: nextMonth.left
                    anchors.rightMargin: 2
                }
                HoverButton {
                    id: nextMonth
                    width: parent.height
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    source: "Arrow_Right.gif"
                    onClicked: control.showNextMonth()
                }
            }
        }
    }
}
