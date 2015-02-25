
var instrumentYellowActive = function(that){
	
	$(that).removeClass("instrument-icon-yellow").addClass("instrument-icon-yellow-selected");
	
	hideAllSelectorsExcept('yellow');
	
	showAllIndicatorsExcept('yellow');
	
};



