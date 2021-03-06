import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import OpenCV 1.0
import OSC 1.0
import '.'
import '../Style'
import '../Common'
import 'Camera'

RowLayout {
    id: view
    property var message: console

    QtObject {
        id: levelMaps
        property int num: 5
        property var preStable: null
        property var caches: []
    }

    Storage {
        id: localStorage
        name: 'LegoAnalyzer'
        description: 'Lego Analyzer Settings'
    }

    OSCSender {
        id: osc
        ip: '127.0.0.1'
        port: 4567
    }

    PlainImage {
        id: plainImage
        Layout.maximumWidth: 0
        Layout.maximumHeight: 0
        src: imagePath.text
    }

    Rectangle {
        width: 0
        height: 0
        clip: true
        Camera {
            id: camera
            frameRate: 30
            width: 640
            height: 480
            onImageChanged: {
                camera.isUndistorted = localStorage.get('isUndistorted') || camera.isUndistorted;
                camera.rotation = localStorage.get('rotation') || camera.rotation;
                camera.scale    = localStorage.get('scale')    || camera.scale;
                camera.fx = localStorage.get('fx') || camera.fx;
                camera.fy = localStorage.get('fy') || camera.fy;
                camera.cx = localStorage.get('cx') || camera.cx;
                camera.cy = localStorage.get('cy') || camera.cy;
                camera.k1 = localStorage.get('k1') || camera.k1;
                camera.k2 = localStorage.get('k2') || camera.k2;
                camera.p1 = localStorage.get('p1') || camera.p1;
                camera.p2 = localStorage.get('p2') || camera.p2;

                if (useCamera.checked) {
                    analyzedImage.applyEffects(getImage());
                    if (alwaysAnalyze.checked) analyze();
                }
            }
        }
    }

    function copy(arr) {
        // 1 dim.
        if (arr[0][0] === undefined) {
            return arr.slice(0);
        }

        // 2 dim.
        var copied = [];
        for (var i = 0; i < arr.length; ++i) {
            copied[i] = arr[i].slice(0);
        }
        return copied;
    }

    function getImage() {
        return (useCamera.checked) ? camera.image : plainImage.image;
    }

    function analyze() {
        analyzedImage.numX = meshNumXSlider.value;
        analyzedImage.numY = meshNumYSlider.value;
        analyzedImage.targetX = meshXSlider.value;
        analyzedImage.targetY = meshYSlider.value;
        analyzedImage.targetWidth  = meshWidthSlider.value;
        analyzedImage.targetHeight = meshHeightSlider.value;
        var averageColors = analyzedImage.analyze(analyzedImage.image);

        // calc average color for the whole area
        var wholeAverage = 0;
        for (var i = 0; i < averageColors.length; ++i) {
            for (var j = 0; j < averageColors[0].length; ++j) {
                wholeAverage += averageColors[i][j];
            }
        }
        wholeAverage /= averageColors.length * averageColors[0].length;

        // define level
        var Type = {
            Base   : 0,
            Shadow : -1,
            Block  : 1
        };

        // check the darker / lighter area
        var checkArr = [];
        for (var i = 0; i < averageColors.length; ++i) {
            checkArr[i] = [];
            for (var j = 0; j < averageColors[i].length; ++j) {
                var diff = wholeAverage - averageColors[i][j];
                checkArr[i][j] = (diff >  darkThresholdSlider.value)  ? Type.Shadow :
                                 (diff < -lightThresholdSlider.value) ? Type.Block  : Type.Base;
            }
        }

        // create result array
        var levelMap = [];
        for (var i = 0; i < checkArr.length; ++i) {
            levelMap[i] = [];
            var preValue = Type.Base;
            var level    = 0;
            var error    = 0;
            for (var j = 0; j < checkArr[i].length; ++j) {
                var currentValue = checkArr[i][j];
                switch (preValue) {
                    case Type.Base: // 基板
                        switch (currentValue) {
                            case Type.Base   : break;
                            case Type.Shadow : break;
                            case Type.Block  : ++error; ++level; break;
                            default: ++error; break;
                        }
                        break;
                    case Type.Shadow: // 影
                        switch (currentValue) {
                            case Type.Base   : ++error; level = 0; break;
                            case Type.Shadow : ++level; break;
                            case Type.Block  : ++level; break;
                            default: ++error; break;
                        }
                        break;
                    case Type.Block: // ブロック
                        switch (currentValue) {
                            case Type.Base   : level = 0; break;
                            case Type.Shadow : ++level; break;
                            case Type.Block  : break;
                            default: ++error; break;
                        }
                        break;
                }
                preValue = currentValue;
                levelMap[i][j] = level;
            }
        }

        // set dossun area as darker
        for (var j = 13; j <= 20; ++j) {
            levelMap[15][j] = levelMap[16][j] = 0;
        }

        // set for drawing level
        targetArea.texts = copy(levelMap);

        // check if stable
        var stableFlag = true;
        for (var i = 0; i < levelMaps.num; ++i) {
            for (var j = 0; j < levelMap.length; ++j) {
                for (var k = 0; k < levelMap[j].length; ++k) {
                    if (levelMaps.caches[i]       === undefined ||
                            levelMaps.caches[i][j]    === undefined ||
                            levelMaps.caches[i][j][k] === undefined) {
                        stableFlag = false;
                        break;
                    }
                    if (levelMap[j][k] !== levelMaps.caches[i][j][k]) {
                        stableFlag = false;
                        break;
                    }
                }
                if (!stableFlag) break;
            }
            if (!stableFlag) break;
        }

        // update level map cache
        if (levelMaps.caches.length >= levelMaps.num) {
            levelMaps.caches.pop();
        }
        levelMaps.caches.unshift(copy(levelMap));

        // search change points
        if (stableFlag) {
            var changePointsArr = [];
            var changeFlag = false;
            if (levelMaps.preStable === null) {
                levelMaps.preStable = copy(levelMap);
            } else {
                for (var i = 0; i < levelMap.length; ++i) {
                    changePointsArr[i] = [];
                    for (var j = 0; j < levelMap[i].length; ++j) {
                        var change = levelMap[i][j] - levelMaps.preStable[i][j];
                        changePointsArr[i][j] = change;
                        if (change !== 0) {
                            changeFlag = true;
                            if (change > 0) {
                                oscSender.register('/LegoAnalyzer/AddBlock', i, j);
                            } else if (change < 0) {
                                oscSender.register('/LegoAnalyzer/DeleteBlock', i, j);
                            }
                        }
                    }
                }
                if (changeFlag) {
                    levelMaps.preStable = copy(levelMap);
                    targetArea.changes = copy(changePointsArr);
                }
            }
        }
    }

    // Send osc timer
    Timer {
        id: oscSender
        property int fps: 30
        property var queue: []
        function register() {
            queue.push(Array.prototype.slice.call(arguments, 0));
        }
        repeat: true
        interval: 1000 / fps
        running: true
        onTriggered: {
            var msg = queue.shift();
            if (msg) {
                console.log(msg);
                switch (msg.length) {
                    case 2:
                        osc.send(msg[0], msg[1]);
                        break;
                    case 3:
                        osc.send(msg[0], msg[1], msg[2]);
                        break;
                    default:
                        console.warn("unknown osc message type", msg);
                        break;
                }
            }
        }
    }


    RowLayout {
        ColumnLayout {
            GroupBox {
                id: imageBox
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.maximumWidth: view.width - 250
                Layout.maximumHeight: view.height - 40

                AnalyzedImage {
                    id: analyzedImage
                    anchors.fill: parent
                    clip: true

                    property double ratioX: analyzedImage.width  / analyzedImage.imageWidth
                    property double ratioY: analyzedImage.height / analyzedImage.imageHeight

                    Mesh {
                        id: targetArea
                        lineColor: '#ff0000'
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
                                if (deltaX !== 0 && deltaX % deltaMax == 0) {
                                    var newNumX = meshNumXSlider.value + deltaX/deltaMax;
                                    meshNumXSlider.setValue(newNumX);
                                    deltaX = 0;
                                }
                                if (deltaY !== 0 && deltaY % deltaMax == 0) {
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
                        applyEffects(getImage());
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
            }

            GroupBox {
                id: sourceSelectField
                Layout.fillWidth: true
                Layout.maximumWidth: view.width - 250
                clip: true

                RowLayout {
                    Text {
                        text: 'Use Camera: '
                    }
                    CheckBox {
                        id: useCamera
                        checked: false
                        onCheckedChanged: analyzedImage.applyEffects(getImage())
                    }
                    Item {
                        Layout.preferredWidth: 12
                    }
                    Text {
                        text: 'Always analyze: '
                    }
                    CheckBox {
                        id: alwaysAnalyze
                        checked: false
                        onCheckedChanged: {
                            if (!checked) {
                                targetArea.texts = [];
                            }
                        }
                    }
                    Item {
                        Layout.preferredWidth: 12
                    }
                    Text {
                        text: 'Dummy Image: '
                    }
                    TextField {
                        id: imagePath
                        Layout.minimumWidth: 400
                        text: localStorage.get('imagePath') || '/Users/hecomi/Desktop/dummy_input2.png'
                        onAccepted: {
                            localStorage.set('imagePath', text);
                            plainImage.src = text;
                            if (!useCamera.checked) {
                                analyzedImage.applyEffects(plainImage.image);
                            }
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        ScrollView {
            Layout.fillHeight: true

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    Title {
                        text: 'Effects / Parameters'
                    }

                    GroupBox {
                        id: propertiesBox
                        Layout.minimumWidth: buttons.width

                        ColumnLayout {
                            spacing: 10
                            MySlider {
                                id: blurSlider
                                label: 'Median Blur'
                                defaultValue: localStorage.get('blurSlider');
                                onValueChanged: {
                                    var blur = value;
                                    if (blur % 2 == 0) blur -= 1;
                                    message.log('Blur', blur);
                                    analyzedImage.blur = blur;
                                    analyzedImage.applyEffects(getImage());
                                    localStorage.set('blurSlider', value);
                                }
                            }

                            MySlider {
                                id: darkThresholdSlider
                                label: 'Dark Threashold'
                                min: 0
                                max: 255
                                defaultValue: localStorage.get('darkThresholdSlider') || 0
                                onValueChanged: localStorage.set('darkThresholdSlider', value)
                            }

                            MySlider {
                                id: lightThresholdSlider
                                label: 'Light Threshold'
                                min: 0
                                max: 255
                                defaultValue: localStorage.get('lightThresholdSlider') || 0
                                onValueChanged: localStorage.set('lightThresholdSlider', value)
                            }
                        }
                    }
                }

                ColumnLayout {

                    Title {
                        text: 'Target'
                    }

                    GroupBox {
                        Layout.minimumWidth: buttons.width

                        ColumnLayout {
                            spacing: 10

                            MySlider {
                                id: meshXSlider
                                label: 'Target X'
                                max: analyzedImage.imageWidth
                                defaultValue: localStorage.get('meshXSlider') || analyzedImage.imageWidth/4
                                onValueChanged: localStorage.set('meshXSlider', value)
                            }

                            MySlider {
                                id: meshYSlider
                                label: 'TargetY'
                                max: analyzedImage.imageHeight
                                defaultValue: localStorage.get('meshYSlider') || analyzedImage.imageHeight/4
                                onValueChanged: localStorage.set('meshYSlider', value)
                            }

                            MySlider {
                                id: meshWidthSlider
                                label: 'Target Width'
                                max: analyzedImage.imageWidth
                                defaultValue: localStorage.get('meshWidthSlider') || analyzedImage.imageWidth/2
                                onValueChanged: localStorage.set('meshWidthSlider', value)
                            }

                            MySlider {
                                id: meshHeightSlider
                                label: 'Target Height'
                                max: analyzedImage.imageHeight
                                defaultValue: localStorage.get('meshHeightSlider') || analyzedImage.imageHeight/2
                                onValueChanged: localStorage.set('meshHeightSlider', value)
                            }

                            MySlider {
                                id: meshNumXSlider
                                label: 'Mesh Num X'
                                min: 1
                                max: 50
                                defaultValue: localStorage.get('meshNumXSlider') || 10
                                onValueChanged: localStorage.set('meshNumXSlider', value)
                            }

                            MySlider {
                                id: meshNumYSlider
                                label: 'Mesh Num Y'
                                min: 1
                                max: 50
                                defaultValue: localStorage.get('meshNumYSlider') || 10
                                onValueChanged: localStorage.set('meshNumYSlider', value)
                            }
                        }
                    }

                    Item { Layout.minimumHeight: 10 }

                    RowLayout {
                        id: buttons
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                        Button {
                            text: 'Analyze'
                            onClicked: analyze()
                        }

                        Button {
                            text: 'Reset'
                            onClicked: {
                                analyzedImage.applyEffects(getImage());
                                targetArea.texts = [];
                            }
                        }
                    }


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
    }
}
