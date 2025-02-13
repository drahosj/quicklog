import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "."
import "../helpers.js" as Helpers

Window {
    id: root
    width: 1400
    height: 45
    visible: true
    title: qsTr("Minimal Logger")

    default property alias fields: logFields.data

    property alias callIn: callIn
    property alias modeOut: modeOut
    property alias bandOut: bandOut
    property alias frequencyOut: frequencyOut

    signal submit
    signal clear

    function populateRigData(band, mode, freq) {
        bandOut.text = band;
        modeOut.text = mode;
        frequencyOut.text = freq;
    }

    function setup(operator) {
        mycallOut.text = operator;
        callIn.focus = true;
        rig.refreshRigData();
    }

    function setStatus(text) {
        Helpers.addStatusMessage(text);
        root.updateStatus();
    }

    function clearStatus(text) {
        Helpers.deleteStatusMessage(text);
        root.updateStatus();
    }

    function updateStatus() {
        var st = Helpers.getCurrentStatus()
        if (st != "") {
            statusOut.text = st;
            statusBox.visible = true;
        } else {
            statusBox.visible = false;
        }
    }

    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: rig.refreshRigData()
    }


    RowLayout {
        spacing: 0

        OutputField {
            color: 'green'
            id: modeOut
            text: 'SSB'
        }

        OutputField {
            color: 'plum'
            id: bandOut
            text: '20'
        }

        OutputField {
            color: 'teal'
            id: frequencyOut
            text: '14100000'
        }

        OutputField {
            color: 'darkgrey'
            Layout.rightMargin: 20
            id: mycallOut
            text: 'MYCALL'
        }

        LogField {
            id: callIn
            Layout.minimumWidth: 200
            placeholderText: 'CALL'
            backgroundColor: 'grey'

            onTextEdited: function() {
                logger.checkDupe(callIn.text, bandOut.text, modeOut.text);
            }
        }

        RowLayout {
            spacing: 0
            id: logFields
        }

        Rectangle {
            id: statusBox
            color: 'red'
            Layout.minimumHeight: 45
            Layout.minimumWidth: 240
            Layout.maximumWidth: 240
            Layout.margins: 0
            Layout.leftMargin: 20
            visible: false
            Text {
                id: statusOut
                font.pointSize: 12
                font.family: 'monospace'
                anchors.centerIn: parent
                text: ''
            }
        }

        Keys.onPressed: (event) => {
            console.log("Key press passed to layout " + event.key);
            if (event.key == Qt.Key_Return) {
                root.submit()
            }
            if (event.key == Qt.Key_Escape) {
                root.clear()
            }
        }
    }
}
