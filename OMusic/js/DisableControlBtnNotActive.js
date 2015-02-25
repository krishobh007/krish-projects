var disableControlBtnNotActive = function(){
	
	if(!$("#controlBlock #switch div").hasClass('switch-icon-standard')) {
		$("#controlBlock #switch div").removeClass("switch-icon-selected").addClass("switch-icon-standard");	
	}
	if(!$("#controlBlock #save div").hasClass('save-icon-standard')) {
		$("#controlBlock #save div").removeClass("save-icon-selected").addClass("save-icon-standard");	
	}
	if(!$("#controlBlock #load div").hasClass('load-icon-standard')) {
		$("#controlBlock #load div").removeClass("load-icon-selected").addClass("load-icon-standard");	
	}
	if(!$("#controlBlock #volume div").hasClass('volume-icon-standard')) {
		$("#controlBlock #volume div").removeClass("volume-icon-selected").addClass("volume-icon-standard");	
	}
	if(!$("#controlBlock #bars div").hasClass('bars-icon-standard')) {
		$("#controlBlock #bars div").removeClass("bars-icon-selected").addClass("bars-icon-standard");	
	}
	if(!$("#controlBlock #tempo div").hasClass('tempo-icon-standard')) {
		$("#controlBlock #tempo div").removeClass("tempo-icon-selected").addClass("tempo-icon-standard");	
	}
	
};