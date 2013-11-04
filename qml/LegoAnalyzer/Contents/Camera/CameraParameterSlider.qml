import '..'
import '../../Common'

MySlider {
    property double baseValue: defaultValue
    defaultValue: 1.0;
    min: baseValue - Math.abs(baseValue)/1.5
    max: baseValue + Math.abs(baseValue)/1.5
    textWidth: 100
}
