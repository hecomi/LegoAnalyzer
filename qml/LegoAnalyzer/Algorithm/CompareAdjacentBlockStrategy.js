// calc average color for the whole area
var wholeAverage = 0;
for (var i = 0; i < averageColors.length; ++i) {
	for (var j = 0; j < averageColors[0].length; ++j) {
		wholeAverage += averageColors[i][j];
	}
}
wholeAverage /= averageColors.length * averageColors[0].length;

// define level
var Difference = {
	Same    :  0,
	Darker  : -1,
	Lighter :  1
};

// check the darker / lighter area
var checkArr = [];
for (var i = 0; i < averageColors.length; ++i) {
	checkArr[i] = [];
	for (var j = 0; j < averageColors[i].length; ++j) {
		// calculate adjacent four area
		var diff = 0;
		if (j - 1 >= 0) {
			diff = averageColors[i][j - 1] - averageColors[i][j];
		}
		checkArr[i][j] = (diff >  darkThresholdSlider.value)  ? Difference.Darker  :
						 (diff < -lightThresholdSlider.value) ? Difference.Lighter : Difference.Same;
	}
}

// create result array
var levelMap = [];
for (var i = 0; i < checkArr.length; ++i) {
	levelMap[i] = [];
	var preValue = Difference.Same;
	var level    = 0;
	var error    = 0;
	for (var j = 0; j < checkArr[i].length; ++j) {
		var currentValue = checkArr[i][j];
		switch (preValue) {
			case Difference.Same: // 基板
				switch (currentValue) {
					case Difference.Same    : break;
					case Difference.Darker  : break;
					case Difference.Lighter : ++error; ++level; break;
					default: ++error; break;
				}
				break;
			case Difference.Darker: // 影
				switch (currentValue) {
					case Difference.Same    : ++error; ++level; break; // (++implicit_level)
					case Difference.Darker  : ++error; ++level; break;
					case Difference.Lighter : ++level; break;
					default: ++error; break;
				}
				break;
			case Difference.Lighter: // ブロック
				switch (currentValue) {
					case Difference.Same    : break;
					case Difference.Darker  : break;
					case Difference.Lighter : ++error; break;
					default: ++error; break;
				}
				break;
		}
		preValue = currentValue;
		levelMap[i][j] = level;
	}
}
