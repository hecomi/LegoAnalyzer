import QtQuick 2.1
import OpenCV 1.0
import '../../Common'

Camera {
    id: camera

    property int frameRate: 30
    property bool updated: false

    function start() {
        timer.running = true;
    }

    function stop() {
        timer.running = false;
    }

    Timer {
        id: timer
        interval: 1000 / frameRate
        running: true
        repeat: true
        onTriggered:  {
            if (updated) {
                updated = false;
                camera.update();
            }
        }
    }

    onImageChanged: {
        updated = true;
    }

    Mesh {
        anchors.fill: parent
        lineColor: '#ff0000'
        numX: 24
        numY: 24
    }
}
