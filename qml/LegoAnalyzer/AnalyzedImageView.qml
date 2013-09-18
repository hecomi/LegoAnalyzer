import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import OpenCV 1.0

RowLayout {
    property var message: console

    ColumnLayout {
        RowLayout {

            PlainImage {
                id: originalImage
                src: "/Users/hecomi/tmp/dummy_input.png"
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            AnalyzedImage {
                id: analyzedImage
                Layout.fillWidth: true
                Layout.fillHeight: true

                Component.onCompleted: {
                    analyze(originalImage.image);
                }

                onSrcLoaded: {
                    if (!success) {
                        message.error('No such file:', src);
                    }
                }

                onAnalyzed: {
                    if (!success) {
                        message.error('Analysis failed.');
                    }
                }
            }
        }

        RowLayout {
            Text {
                text: 'blur'
            }
            Slider {
                id: blur2
                property int blurMax: 50
                value: 0
                width: 400
                onValueChanged: {
                    var blur = value * blurMax;
                    if (blur % 2 == 0) blur -= 1;
                    message.log('Blur', blur);
                    analyzedImage.blur = blur;
                    analyzedImage.analyze(originalImage.image);
                }
            }
        }
    }
}
