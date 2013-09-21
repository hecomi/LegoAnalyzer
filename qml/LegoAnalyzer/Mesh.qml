import QtQuick 2.0

Rectangle {
    color: 'transparent'

    property alias lineColor : canvas.lineColor
    property alias numX      : canvas.numX
    property alias numY      : canvas.numY

    Canvas {
        id: canvas
        anchors.fill: parent

        property color lineColor : '#ff0000'
        property int   numX      : 10
        property int   numY      : 10

        renderTarget   : Canvas.Image
        renderStrategy : Canvas.Immediate

        onNumXChanged: canvas.requestPaint();
        onNumYChanged: canvas.requestPaint();

        onPaint: {
            var ctx = canvas.getContext('2d');
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            ctx.strokeStyle = lineColor;

            var grid = {
                width  : canvas.width  / numX,
                height : canvas.height / numY
            }

            ctx.beginPath(); {
                for (var i = 0; i < numX; ++i) {
                    ctx.moveTo(grid.width * i, 0);
                    ctx.lineTo(grid.width * i, canvas.height);
                }
                for (var i = 0; i < numY; ++i) {
                    ctx.moveTo(0, grid.height * i);
                    ctx.lineTo(canvas.width, grid.height * i);
                }
            } ctx.stroke();
        }
    }
}
