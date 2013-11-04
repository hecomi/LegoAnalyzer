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
