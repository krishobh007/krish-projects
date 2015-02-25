$("#volumeIcon").live("click", function(){
	
	disableControlBtnNotActive();
	
	$(this).removeClass("volume-icon-standard").addClass("volume-icon-selected");
	
	hideAllPanelsExcept("volume");
	
	
	
	
});	
