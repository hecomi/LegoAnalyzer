import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0
import OpenCV 1.0
import '.'

Rectangle {
    id: window
    width: 1280
    height: 720
    color: '#888'

    MyMenuBar {
        id: menu_bar
    }

    TabView {
        id: tabs
        frameVisible: true
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 20
        height: parent.height - 40

        Tab {
            id: cameraView
            title: "Camera"
            CameraView {}
        }

        Tab {
            id: analyzedImageView
            title: "Analyzed"
            AnalyzedImageView {
                message: statusBar
            }
        }

        Rectangle {
            anchors.fill: parent
            border.width: 8
            border.color: '#999'
            color: '#00000000'
        }

        Rectangle {
            anchors.fill: parent
            border.width: 4
            border.color: '#ccc'
            color: '#00000000'
        }
    }

    MyStatusBar {
        id: statusBar
        width: parent.width
        height: 20
        anchors.bottom: parent.bottom
    }
}
