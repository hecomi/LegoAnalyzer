import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

GroupBox {
    property int    max   : 100
    property bool   isInt : true
    property int    value : isInt ? parseInt(slider.value * max) : slider.value
    property string label : 'No Name'

    property int    defaultValue : 0

    ColumnLayout {
        Text {
            text: label
        }
        RowLayout {
            Slider {
                id: slider
                value: defaultValue / max
                width: parent.width
            }
            GroupBox {
                Text {
                    text: value
                }
            }
        }
    }
}
