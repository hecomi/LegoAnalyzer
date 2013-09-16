import QtQuick 2.1
import OpenCV 1.0

AnalyzedImage {
    id: analyzer
    src: "/Users/hecomi/tmp/dummy_input.png"
    property var message: console

    Component.onCompleted: {
        analyze(image);
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
