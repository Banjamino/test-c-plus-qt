// Main.qml
// Minimal, clean QML so qmllint has real input to validate. This file should
// PASS qmllint --strict. A deliberately-broken counterpart lives in
// validation-fixtures/ to prove the qmllint gate BLOCKS on errors.

import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: root
    visible: true
    width: 400
    height: 300
    title: qsTr("App Skeleton")

    property int clickCount: 0

    Column {
        anchors.centerIn: parent
        spacing: 12

        Label {
            text: qsTr("Clicks: %1").arg(root.clickCount)
        }

        Button {
            text: qsTr("Increment")
            onClicked: root.clickCount += 1
        }
    }
}
