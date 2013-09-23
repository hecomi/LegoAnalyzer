import QtQuick 2.1
import OpenCV 1.0

Rectangle {
    property int frameRate: 30

    function start() {
        timer.running = true;
    }

    function stop() {
        timer.running = false;
    }

    Camera {
        id: camera
        anchors.fill: parent
    }

    Timer {
        id: timer
        interval: 1000 / frameRate
        running: true
        repeat: true
        onTriggered:  {
            camera.update();
        }
    }
}
