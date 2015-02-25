var instrumentSkyblueActive = function(that){
	
	$(that).removeClass("instrument-icon-skyblue").addClass("instrument-icon-skyblue-selected");
	
	hideAllSelectorsExcept('skyblue');
	
	showAllIndicatorsExcept('skyblue');
	
};