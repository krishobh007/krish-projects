var disableInstrumentsNotActive = function(){
	
	if(!$("#instrumentIconYellow div").hasClass('instrument-icon-yellow')) {
		$("#instrumentIconYellow div").removeClass("instrument-icon-yellow-selected").addClass("instrument-icon-yellow");	
	}
	
	if(!$("#instrumentIconRed div").hasClass('instrument-icon-red')) {
		$("#instrumentIconRed div").removeClass("instrument-icon-red-selected").addClass("instrument-icon-red");	
	}
	
	if(!$("#instrumentIconGreen div").hasClass('instrument-icon-green')) {
		$("#instrumentIconGreen div").removeClass("instrument-icon-green-selected").addClass("instrument-icon-green");	
	}
	if(!$("#instrumentIconSkyblue div").hasClass('instrument-icon-skyblue')) {
		$("#instrumentIconSkyblue div").removeClass("instrument-icon-skyblue-selected").addClass("instrument-icon-skyblue");	
	}
	if(!$("#instrumentIconBlue div").hasClass('instrument-icon-blue')) {
		$("#instrumentIconBlue div").removeClass("instrument-icon-blue-selected").addClass("instrument-icon-blue");	
	}
};