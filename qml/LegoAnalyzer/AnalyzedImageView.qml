import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import OpenCV 1.0
import '.'

RowLayout {
    id: view
    property var message: console

    PlainImage {
        id: originalImage
        width: 0
        height: 0
        src: "/Users/hecomi/tmp/dummy_input.png"
    }

    RowLayout {
        AnalyzedImage {
            id: analyzedImage
            Layout.fillWidth: true
            Layout.fillHeight: true

            Mesh {
                id: targetArea
                numX: meshNumXSlider.value
                numY: meshNumYSlider.value
                x: 100
                y: 100
                width: meshWidthSlider.value
                height: meshHeightSlider.value
                Rectangle {
                    border.color: targetArea.lineColor
                    anchors.fill: parent
                    color: '#44000000'
                }
                MouseArea {
                    id: dragMouseArea
                    anchors.fill: parent
                    drag.target: targetArea
                    drag.axis: Drag.XAndYAxis
                    cursorShape: Qt.PointingHandCursor
                }
                MouseArea {
                    id: expandMouseArea
                    width: 10
                    height: 10
                    cursorShape: Qt.SizeFDiagCursor
                    anchors.right: dragMouseArea.right
                    anchors.bottom: dragMouseArea.bottom
                    property int baseX: 0
                    property int baseY: 0
                    onClicked: {
                        baseX = mouse.x;
                        baseY = mosue.y;
                    }
                    onPositionChanged: {
                        var newWidth  = meshWidthSlider.value + (mouse.x - baseX);
                        var newHeight = meshHeightSlider.value + (mouse.y - baseY);
                        meshWidthSlider.setValue(newWidth);
                        meshHeightSlider.setValue(newHeight);
                    }
                }
            }

            Component.onCompleted: {
                applyEffects(originalImage.image);
            }

            onSrcLoaded: {
                if (!success) {
                    message.error('No such file:', src);
                }
            }

            onApplied: {
                if (!success) {
                    message.error('Apply effects failed.');
                }
            }

            onAnalyzed: {
                if (!success) {
                    message.error('Analysis failed.', msg);
                }
            }
        }

        ColumnLayout {
            spacing: 20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            GroupBox {
                ColumnLayout {
                    spacing: 16
                    MySlider {
                        id: blurSlider
                        label: 'Blur'
                        defaultValue: 0
                        onValueChanged: {
                            var blur = value;
                            if (blur % 2 == 0) blur -= 1;
                            message.log('Blur', blur);
                            analyzedImage.blur = blur;
                            analyzedImage.applyEffects(originalImage.image);
                        }
                    }
                    MySlider {
                        id: meshNumXSlider
                        width: parent.width
                        label: 'Mesh Num X'
                        max: 50
                        defaultValue: 10
                    }
                    MySlider {
                        id: meshNumYSlider
                        label: 'Mesh Num Y'
                        max: 50
                        defaultValue: 10
                    }
                    MySlider {
                        id: meshWidthSlider
                        label: 'Width'
                        max: analyzedImage.width
                        defaultValue: 100
                    }
                    MySlider {
                        id: meshHeightSlider
                        label: 'Height'
                        max: analyzedImage.height
                        defaultValue: 100
                    }
                }
            }

            Button {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                text: 'Analyze'
                onClicked: {
                    analyzedImage.analyze(analyzedImage.image);
                }
            }
        }
    }
}
