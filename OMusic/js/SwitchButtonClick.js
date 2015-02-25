$("#switchIcon").live("click", function(){
	
	disableControlBtnNotActive();
	
	$(this).removeClass("switch-icon-standard").addClass("switch-icon-selected");
	
	hideAllPanelsExcept("switch");
	
	
	showAllInstruments();
	hideAllMusicList();
	
});	
