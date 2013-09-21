import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import OpenCV 1.0
import '.'

RowLayout {
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
                numX: meshNumSlider.value
                numY: meshNumSlider.value
                x: 100; y: 100
                width: 100; height: 100
                Rectangle {
                    border.color: targetArea.lineColor
                    anchors.fill: parent
                    color: '#44000000'
                }
                MouseArea {
                    anchors.fill: parent
                    drag.target: targetArea
                    drag.axis: Drag.XAndYAxis
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

        GroupBox {
            ColumnLayout {
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
                    id: meshNumSlider
                    label: 'Mesh Num'
                    max: 50
                    defaultValue: 10
                }
                MySlider {
                    id: meshWidthSlider
                    label: 'Width'
                    max: 50
                    defaultValue: 10
                }
                Button {
                    text: 'Analyze'
                    onClicked: {
                        analyzedImage.analyze(analyzedImage.image);
                    }
                }
            }
        }
    }
}
