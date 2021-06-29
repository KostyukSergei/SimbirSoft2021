import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    id: page
    width: 600
    height: 400
    background: Rectangle {
        color: "#555"
    }

    property string today
    property string currentID: null

    Connections {
        target: connector
        onToLabel: {
            label.text = date
            listModel.clear()
        }
        onToDate: {
            dateStart.text = date
            dateFinish.text = date
            today = date
        }
        onToEvents: {
            listModel.append({
                                 "id": obj["id"].toString(),
                                 "name": obj["name"].toString(),
                                 "description": obj["description"].toString(),
                                 "dateStart": obj["date_start"].toString(),
                                 "dateFinish": obj["date_finish"].toString()
                             })
        }
        onToEvent: {
            name.text = obj["name"].toString()
            description.text = obj["description"].toString()
            dateStart.text = obj["date_start"].toString()
            dateFinish.text = obj["date_finish"].toString()
            currentID = obj["id"].toString()
            addEvent.visible = false
            frame.visible = false
            frame1.visible = true
            save.visible = true
            deleteEvent.visible = true
            cancel.visible = true
        }
    }

    header: Label {
        id: label
        font.pixelSize: Qt.application.font.pixelSize * 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
        bottomPadding: 0
        padding: 10
        color: "yellow"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }

    Pane {
        background: Rectangle {
            color: "transparent"
        }
        id: frame
        visible: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: addEvent.top
        bottomPadding: 6
        topPadding: 6
        anchors.rightMargin: 6
        anchors.leftMargin: 0
        anchors.bottomMargin: 6
        anchors.topMargin: 0

        ListView {
            id: listView
            anchors.fill: parent
            model: ListModel {
                id: listModel
            }
            delegate: Item {
                x: 5
                width: listView.width
                height: 75
                Row {
                    id: row1
                    spacing: 10
                    Rectangle {
                        width: listView.width
                        height: 75
                        color: "#333"
                        border.color: "black"
                        Text {
                            padding: 6
                            color: "yellow"
                            text: name + "\n" + "с " + dateStart + "\nпо " + dateFinish
                            anchors.verticalCenter: parent.verticalCenter

                            font.bold: true
                            font.pixelSize: Qt.application.font.pixelSize * 1.25
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        connector.selectEvent(listModel.get(index).id)
                        listView.currentIndex = index
                        deleteEvent.enabled = true
                    }
                }
            }
        }
    }

    Button {
        id: addEvent
        x: 450
        y: 294
        height: 40
        visible: true
        background: Rectangle {
            color: "#f2f20d"
            border.color: "#333"
        }
        text: qsTr("Добавить")
        palette.buttonText: "#555"
        anchors.left: parent.horizontalCenter
        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.rightMargin: -50
        anchors.leftMargin: -50

        onClicked: {
            addEvent.visible = false
            frame.visible = false
            frame1.visible = true
            save.visible = true
            deleteEvent.visible = true
            cancel.visible = true
            currentID = null
        }
    }

    Button {
        id: save
        y: 304
        width: page.width / 3.5
        height: 40
        visible: false
        text: qsTr("Сохранить")
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 24
        anchors.bottomMargin: 9
        palette.buttonText: "#555555"
        background: Rectangle {
            color: "#f2f20d"
            border.color: "#333333"
        }

        onClicked: {
            connector.addJSON(name.text, dateStart.text, dateFinish.text,
                              description.text, currentID)
            addEvent.visible = true
            frame.visible = true
            frame1.visible = false
            save.visible = false
            deleteEvent.visible = false
            cancel.visible = false
            deleteEvent.enabled = false
            listModel.clear()
            connector.loadJSON(today)
            currentID = null
        }
    }

    Button {
        id: cancel
        x: 420
        y: 0
        width: page.width / 3.5
        height: 40
        visible: false
        text: qsTr("Отмена")
        anchors.right: parent.right
        anchors.top: frame1.bottom
        anchors.bottom: parent.bottom
        anchors.rightMargin: 24
        anchors.bottomMargin: 9
        anchors.topMargin: 6
        padding: 6
        palette.buttonText: "#555555"
        background: Rectangle {
            color: "#f2f20d"
            border.color: "#333333"
        }

        onClicked: {
            addEvent.visible = true
            frame.visible = true
            frame1.visible = false
            save.visible = false
            deleteEvent.visible = false
            cancel.visible = false
            deleteEvent.enabled = false
            currentID = null
        }
    }

    Button {
        id: deleteEvent
        x: 192
        y: 313
        width: page.width / 3.5
        height: 40
        visible: false
        enabled: false
        text: qsTr("Удалить")
        anchors.top: frame1.bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 9
        anchors.topMargin: 6
        palette.buttonText: "#555555"
        background: Rectangle {
            color: deleteEvent.enabled ? "#f2f20d" : "#aaaa09"
            border.color: "#333333"
        }

        onClicked: {
            connector.deleteEvent(listModel.get(listView.currentIndex).id)
            addEvent.visible = true
            frame.visible = true
            frame1.visible = false
            save.visible = false
            deleteEvent.visible = false
            cancel.visible = false
            deleteEvent.enabled = false
            listModel.clear()
            connector.loadJSON(today)
            currentID = null
        }
    }

    Pane {
        background: Rectangle {
            color: "transparent"
        }
        id: frame1
        visible: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: save.top
        bottomPadding: 6
        topPadding: 6
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 6
        anchors.topMargin: 0

        TextField {
            id: name
            width: 485
            height: Qt.application.font.pixelSize * 2.5
            color: "#ffff00"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 6
            anchors.topMargin: 6
            font.pixelSize: Qt.application.font.pixelSize * 1.25
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            anchors.leftMargin: 6
            placeholderTextColor: "#80ffff00"
            background: Rectangle {
                color: "#333"
            }

            placeholderText: qsTr("Название события")
        }

        TextField {
            id: dateStart
            height: Qt.application.font.pixelSize * 2.5
            color: "#ffff00"
            anchors.right: parent.right
            anchors.top: name.bottom
            anchors.rightMargin: 6
            anchors.topMargin: 12
            font.pixelSize: Qt.application.font.pixelSize * 1.25
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            anchors.leftMargin: 6
            placeholderTextColor: "#80ffff00"
            background: Rectangle {
                color: "#333"
            }
            text: "01-01-2000"
            anchors.left: label1.right

            inputMask: "99-99-9999 99:99"

            validator: RegExpValidator {
                regExp: /^(?:(?:31(-)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(-)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(-)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(-)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})(\s)(0[0-9]|1[0-9]|2[0-3]|[0-9]):[0-5][0-9]$/
            }
        }

        TextField {
            id: dateFinish
            height: Qt.application.font.pixelSize * 2.5
            color: "#ffff00"
            text: "01-01-2000"
            anchors.left: label2.right
            anchors.right: parent.right
            anchors.top: dateStart.bottom
            font.pixelSize: Qt.application.font.pixelSize * 1.25
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            anchors.leftMargin: 6

            validator: RegExpValidator {
                regExp: /^(?:(?:31(-)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(-)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(-)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(-)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})(\s)(0[0-9]|1[0-9]|2[0-3]|[0-9]):[0-5][0-9]$/
            }
            anchors.topMargin: 12
            background: Rectangle {
                color: "#333333"
            }
            anchors.rightMargin: 6
            inputMask: "99-99-9999 99:99"
            placeholderTextColor: "#80ffff00"
        }

        Label {
            id: label1
            width: Qt.application.font.pixelSize * 7
            height: Qt.application.font.pixelSize * 2.5
            text: qsTr("Начало")
            anchors.left: parent.left
            anchors.top: name.bottom
            anchors.topMargin: 13
            anchors.leftMargin: 6
            font.pixelSize: Qt.application.font.pixelSize * 1.25
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: "yellow"
        }

        Label {
            id: label2
            height: Qt.application.font.pixelSize * 2.5
            width: Qt.application.font.pixelSize * 7
            text: qsTr("Окончание")
            anchors.left: parent.left
            anchors.top: label1.bottom
            anchors.topMargin: 12
            anchors.leftMargin: 6
            font.pixelSize: Qt.application.font.pixelSize * 1.25
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: "yellow"
        }

        TextArea {
            id: description
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: label2.bottom
            anchors.bottom: parent.bottom
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            anchors.topMargin: 12
            anchors.rightMargin: 6
            anchors.leftMargin: 6
            anchors.bottomMargin: 0
            color: "#ffff00"
            background: Rectangle {
                color: "#333333"
            }
            placeholderTextColor: "#80ffff00"
            placeholderText: qsTr("Описание")
            font.pixelSize: Qt.application.font.pixelSize * 1.25
        }
    }
}
