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
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth : true
            Layout.maximumHeight: view.height
            Layout.maximumWidth:  view.width - propertiesBox.width
            clip: true

            property double ratioX: analyzedImage.width  / analyzedImage.imageWidth
            property double ratioY: analyzedImage.height / analyzedImage.imageHeight

            Mesh {
                id: targetArea
                lineColor: '#ccff0000'
                numX: meshNumXSlider.value
                numY: meshNumYSlider.value
                x: meshXSlider.value * analyzedImage.ratioX;
                y: meshYSlider.value * analyzedImage.ratioY;
                width: meshWidthSlider.value * analyzedImage.ratioX;
                height: meshHeightSlider.value * analyzedImage.ratioY;

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
                    property int deltaX: 0
                    property int deltaY: 0
                    property int deltaMax: 20
                    onPositionChanged: {
                        meshXSlider.setValue(targetArea.x / analyzedImage.ratioX);
                        meshYSlider.setValue(targetArea.y / analyzedImage.ratioY);
                    }
                    onWheel: {
                        deltaX += wheel.pixelDelta.x;
                        deltaY += wheel.pixelDelta.y;
                        if (deltaX != 0 && deltaX % deltaMax == 0) {
                            var newNumX = meshNumXSlider.value + deltaX/deltaMax;
                            meshNumXSlider.setValue(newNumX);
                            deltaX = 0;
                        }
                        if (deltaY != 0 && deltaY % deltaMax == 0) {
                            var newNumY = meshNumYSlider.value + deltaY/deltaMax;
                            meshNumYSlider.setValue(newNumY);
                            deltaY = 0;
                        }
                    }
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
                        baseY = mouse.y;
                    }
                    onPositionChanged: {
                        var newWidth  = meshWidthSlider.value + (mouse.x - baseX) / analyzedImage.ratioX;
                        var newHeight = meshHeightSlider.value + (mouse.y - baseY) / analyzedImage.ratioX;
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

        Item {
            Layout.fillWidth: true
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            Text {
                text: 'Effects'
                font.bold: true
            }

            GroupBox {
                id: propertiesBox
                Layout.minimumWidth: buttons.width

                ColumnLayout {
                    spacing: 10
                    MySlider {
                        id: blurSlider
                        label: 'Median Blur'
                        defaultValue: 0
                        onValueChanged: {
                            var blur = value;
                            if (blur % 2 == 0) blur -= 1;
                            message.log('Blur', blur);
                            analyzedImage.blur = blur;
                            analyzedImage.applyEffects(originalImage.image);
                        }
                    }
                }
            }

            Item { Layout.minimumHeight: 10 }

            Text {
                text: 'Target'
                font.bold: true
            }

            GroupBox {
                ColumnLayout {
                    spacing: 10

                    MySlider {
                        id: meshXSlider
                        label: 'Target X'
                        max: analyzedImage.imageWidth
                        defaultValue: 10
                    }

                    MySlider {
                        id: meshYSlider
                        label: 'TargetY'
                        max: analyzedImage.imageHeight
                        defaultValue: 10
                    }

                    MySlider {
                        id: meshWidthSlider
                        label: 'Target Width'
                        max: analyzedImage.imageWidth
                        defaultValue: 100
                    }

                    MySlider {
                        id: meshHeightSlider
                        label: 'Target Height'
                        max: analyzedImage.imageHeight
                        defaultValue: 100
                    }

                    MySlider {
                        id: meshNumXSlider
                        label: 'Mesh Num X'
                        min: 1
                        max: 50
                        defaultValue: 10
                    }

                    MySlider {
                        id: meshNumYSlider
                        label: 'Mesh Num Y'
                        min: 1
                        max: 50
                        defaultValue: 10
                    }
                }
            }

            Item { Layout.minimumHeight: 10 }

            RowLayout {
                id: buttons
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                Button {
                    text: 'Analyze'
                    onClicked: {
                        analyzedImage.numX = meshNumXSlider.value;
                        analyzedImage.numY = meshNumYSlider.value;
                        analyzedImage.targetX = meshXSlider.value;
                        analyzedImage.targetY = meshYSlider.value;
                        analyzedImage.targetWidth  = meshWidthSlider.value;
                        analyzedImage.targetHeight = meshHeightSlider.value;
                        var result = analyzedImage.analyze(analyzedImage.image);

                        for (var x in result) console.log(result[x]);
                    }
                }

                Button {
                    text: 'Reset'
                    onClicked: {
                        analyzedImage.applyEffects(originalImage.image);
                    }
                }
            }

            Item {  Layout.fillHeight: true }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: 'Quit'
                    onClicked: Qt.quit();
                }
            }
        }
    }
}
