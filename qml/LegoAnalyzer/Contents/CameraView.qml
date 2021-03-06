import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import '.'
import '../Common'
import 'Camera'

RowLayout {
    property alias camera: camera

    Storage {
        id: localStorage
        name: 'LegoAnalyzer'
        description: 'Lego Analyzer Settings'
    }

    GroupBox {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        Camera {
            id: camera
            frameRate: 24
            anchors.fill: parent
        }
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        Layout.minimumWidth: 280
        Layout.fillHeight: true

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                Layout.preferredWidth: parent.width
                Layout.fillHeight: true

                Title {
                    text: 'Flags'
                }

                GroupBox {
                    Layout.preferredWidth: cameraParameters.width

                    ColumnLayout {

                        CheckBox {
                            property string name: 'isUndistorted'
                            text: 'Apply undistortion'
                            checked: localStorage.get(name) || false
                            onCheckedChanged: {
                                localStorage.set(name, checked);
                                camera.isUndistorted = checked;
                            }
                        }
                    }
                }

                Item { Layout.minimumHeight: 10 }

                Title {
                    text: 'Camera Parameters'
                }

                GroupBox {
                    id: cameraParameters

                    ColumnLayout {
                        spacing: 10

                        CameraParameterSlider {
                            id: rotation
                            label: 'rotation'
                            min: -5.0
                            max: 5.0
                            defaultValue: localStorage.get(label) || 0.0
                            onValueChanged: { camera.rotation = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: scale
                            label: 'scale'
                            min: 0.8
                            max: 1.5
                            defaultValue: localStorage.get(label) || 1.0
                            onValueChanged: { camera.scale = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: fx
                            label: 'fx'
                            baseValue: camera.fx;
                            defaultValue: localStorage.get(label) || baseValue
                            onValueChanged: { camera.fx = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: fy
                            label: 'fy'
                            baseValue: camera.fy
                            defaultValue: localStorage.get(label) || baseValue
                            onValueChanged: { camera.fy = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: cx
                            label: 'cx'
                            baseValue: camera.cx
                            defaultValue: localStorage.get(label) || baseValue
                            onValueChanged: { camera.cx = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: cy
                            label: 'cy'
                            baseValue: camera.cy
                            defaultValue: localStorage.get(label) || baseValue
                            onValueChanged: { camera.cy = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: k1
                            label: 'k1'
                            baseValue: camera.k1
                            defaultValue: localStorage.get(label) || baseValue
                            onValueChanged: { camera.k1 = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: k2
                            label: 'k2'
                            baseValue: camera.k2;
                            defaultValue: localStorage.get(label) || baseValue
                            onValueChanged: { camera.k2 = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: p1
                            label: 'p1'
                            baseValue: camera.p1;
                            defaultValue: localStorage.get(label) || baseValue
                            onValueChanged: { camera.p1 = value; localStorage.set(label, value); }
                        }

                        CameraParameterSlider {
                            id: p2
                            label: 'p2'
                            baseValue: camera.p2;
                            defaultValue: localStorage.get(label) || baseValue
                            onValueChanged: { camera.p2 = value; localStorage.set(label, value); }
                        }
                    }
                }
            }
        }
    }
}
