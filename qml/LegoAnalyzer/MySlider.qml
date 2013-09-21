import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
    property int    max   : 100
    property int    value : slider.value * max
    property string label : 'No Name'

    property int    defaultValue : 0

    Text {
        text: label
    }

    RowLayout {
        Slider {
            id: slider
            value: defaultValue / max
        }
        Text {
            text: value.toString().length < 3 ? ' ' + value + ' ' : value
        }
    }

    function setValue(newValue) {
        slider.value = newValue / max;
    }
}
