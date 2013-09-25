import '..'

MySlider {
    property double baseValue: defaultValue
    defaultValue: 1.0;
    min: baseValue - Math.abs(baseValue)/2
    max: baseValue + Math.abs(baseValue)/2
    textWidth: 100
}
