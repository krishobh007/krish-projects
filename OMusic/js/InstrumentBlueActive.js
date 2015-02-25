var instrumentBlueActive = function(that){
	
	$(that).removeClass("instrument-icon-blue").addClass("instrument-icon-blue-selected");
	
	hideAllSelectorsExcept('blue');
	
	showAllIndicatorsExcept('blue');
	
};