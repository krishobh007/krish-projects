var checkInstrumentStatus = function(color){
	
	var array,selector;
	
	switch(color){
	
		case 'red':
			array=musicNodeIdRed;
			selector="#instrumentIconRed span.instrument-left";
			break;
		case 'yellow':
			array=musicNodeIdYellow;
			selector="#instrumentIconYellow span.instrument-left";
			break;
		case 'green':
			array=musicNodeIdGreen;
			selector="#instrumentIconGreen span.instrument-left";
			break;
		case 'blue':
			array=musicNodeIdBlue;
			selector="#instrumentIconBlue span.instrument-left";
			break;
		case 'skyblue':
			array=musicNodeIdSkyblue;
			selector="#instrumentIconSkyblue span.instrument-left";
			break;
		default:
			console.log("case default");
	}
	
	for(var i=0,status=0;i<16;i++){
		if(array[i]!='0'){
			status=1;
		}		
	}
	toggleStatusIcon(status,selector);
};

var toggleStatusIcon = function(status,selector){
	if(status=='0'){
		$(selector).removeClass("instrument-include-on").addClass("instrument-include-off");
	}
	else{
		$(selector).removeClass("instrument-include-off").addClass("instrument-include-on");
	}
};