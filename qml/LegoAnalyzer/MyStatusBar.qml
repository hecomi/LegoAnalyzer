import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

StatusBar {
    id: statusBar
    property int showMsgTime: 3000

    RowLayout {
        anchors.right: parent.right
        Label {
            id: logLabel
            text: ""
            color: '#ffffffff'
            Timer {
                id: logTimer
                interval: showMsgTime
                running: false
                repeat: false
                onTriggered:  {
                    logLabel.text = '';
                }
            }
        }
        Label {
            id: warnLabel
            text: ""
            color: '#ffff8800'
            Timer {
                id: warnTimer
                interval: showMsgTime
                running: false
                repeat: false
                onTriggered:  {
                    warnLabel.text = '';
                }
            }
        }
        Label {
            id: errorLabel
            text: ""
            color: '#ffff0000'
            Timer {
                id: errorTimer
                interval: showMsgTime
                running: false
                repeat: false
                onTriggered:  {
                    errorLabel.text = '';
                }
            }
        }
    }

    function log() {
        logLabel.text += Array.prototype.join.call(arguments, ',') + '  ';
        console.log(logLabel.text);
        logTimer.start();
    }

    function warn() {
        warnLabel.text += Array.prototype.join.call(arguments, ',') + '  ';
        console.warn(warnLabel.text);
        warnTimer.start();
    }

    function error() {
        errorLabel.text += Array.prototype.join.call(arguments, ',') + '  ';
        console.error(errorLabel.text);
        errorTimer.start();
    }
}
