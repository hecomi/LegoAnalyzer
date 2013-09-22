import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import OpenCV 1.0
import '.'

Rectangle {
    id: window
    width: 1280
    height: 720

    SystemPalette { id: syspal }
    color: syspal.window

    MyMenuBar {
        id: menuBar
    }

    TabView {
        id: tabs
        frameVisible: true
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: statusBar.top
        anchors.margins: 12
        clip: true

        Tab {
            id: cameraView
            title: "Camera"
            anchors.margins: 16
            CameraView {}
        }

        Tab {
            id: analyzedImageView
            title: "Analyzed"
            anchors.margins: 16
            AnalyzedImageView {
                message: statusBar
            }
        }
    }

    MyStatusBar {
        id: statusBar
        width: parent.width
        height: 20
        anchors.bottom: parent.bottom
    }

    Component.onCompleted: {
        tabs.moveTab(0, 1);
    }
}
