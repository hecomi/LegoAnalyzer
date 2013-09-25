import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import '.'
import '../Common'
import 'Camera'

RowLayout {

    Storage {
        id: localStorage
        name: 'LegoAnalyzer'
        description: 'Lego Analyzer Settings'
    }

    Camera {
        id: camera
        frameRate: 30
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        Title {
            text: 'Flags'
        }

        GroupBox {
            Layout.preferredWidth: cameraParameters.width

            ColumnLayout {

                CheckBox {
                    text: 'Apply undistortion'
                    checked: localStorage.get(text) || false
                    onCheckedChanged: {
                        localStorage.set(text, checked);
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
