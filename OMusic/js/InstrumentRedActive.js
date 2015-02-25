var instrumentRedActive = function(that){
	
	$(that).removeClass("instrument-icon-red").addClass("instrument-icon-red-selected");
	
	hideAllSelectorsExcept('red');
	
	showAllIndicatorsExcept('red');
	
};