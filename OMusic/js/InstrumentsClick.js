// Each instrument click with different view.

$("#instrumentIconRed div").live("click", function(){
	
	indicatorView('red','yellow','green','skyblue','blue');
	
	disableInstrumentsNotActive();
	
	instrumentRedActive(this);
	
});

$("#instrumentIconYellow div").live("click", function(){
	
	indicatorView('yellow','red','green','skyblue','blue');
	
	disableInstrumentsNotActive();
	
	instrumentYellowActive(this);
	
});

$("#instrumentIconGreen div").live("click", function(){
	
	indicatorView('green','yellow','red','skyblue','blue');
	
	disableInstrumentsNotActive();
	
	instrumentGreenActive(this);
	
});

$("#instrumentIconSkyblue div").live("click", function(){
	
	indicatorView('skyblue','green','yellow','red','blue');
	
	disableInstrumentsNotActive();
	
	instrumentSkyblueActive(this);
	
});

$("#instrumentIconBlue div").live("click", function(){
	
	indicatorView('blue','skyblue','green','yellow','red');
	
	disableInstrumentsNotActive();
	
	instrumentBlueActive(this);
	
});

