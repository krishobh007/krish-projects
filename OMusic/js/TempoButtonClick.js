$("#tempoIcon").live("click", function(){
	
	disableControlBtnNotActive();
	
	$(this).removeClass("tempo-icon-standard").addClass("tempo-icon-selected");
	
	hideAllPanelsExcept("tempo");
	
	
	
});	
