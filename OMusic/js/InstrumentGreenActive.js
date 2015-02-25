var instrumentGreenActive = function(that){
	
	$(that).removeClass("instrument-icon-green").addClass("instrument-icon-green-selected");
	
	hideAllSelectorsExcept('green');
	
	showAllIndicatorsExcept('green');
	
};