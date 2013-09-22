import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
    property int    min   : 0
    property int    max   : 100
    property int    value : min + slider.value * (max - min)
    property string label : 'No Name'
    property int    defaultValue : 0
    property alias  sliderWidth  : slider.width_
    property alias  textWidth    : input.width_

    Text {
        text: label
    }

    RowLayout {
        Slider {
            id: slider
            property int width_: 150
            Layout.preferredWidth: width_
            value: (defaultValue - min) / (max - min)
        }
        TextField {
            id: input
            property int width_: 50
            Layout.preferredWidth: width_
            text: value
            onAccepted: {
                if (text > max) text = max;
                setValue(text);
            }
        }
    }

    function setValue(newValue) {
        slider.value = newValue / (max - min);
    }
}
