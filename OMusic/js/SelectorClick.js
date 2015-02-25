
var countRed=0;
var countYellow= 0 ;
var countGreen= 0 ;
var countSkyblue= 0 ;
var countBlue= 0 ;
var index=0;
var title=0;

$('.icon-red span').live("click", function(event){
	
	hideAllMusicListExcept('red');
	instrumentRedActive();
	hideAllInstrumentsExcept('red');
	$("#instrument-icon-red div").removeClass("instrument-icon-red").addClass("instrument-icon-red-selected");
	selectorRedClick(this);
	
});	

$('.icon-yellow span').live("click", function(event){
	
	hideAllMusicListExcept('yellow');
	instrumentYellowActive();
	hideAllInstrumentsExcept('yellow');
	selectorYellowClick(this);
	
});	

$('.icon-green span').live("click", function(event){
	
	hideAllMusicListExcept('green');
	instrumentGreenActive();
	hideAllInstrumentsExcept('green');
	selectorGreenClick(this);
	
});	

$('.icon-skyblue span').live("click", function(event){
	
	hideAllMusicListExcept('skyblue');
	instrumentSkyblueActive();
	hideAllInstrumentsExcept('skyblue');
	selectorSkyblueClick(this);
	
});

$('.icon-blue span').live("click", function(event){
	
	hideAllMusicListExcept('blue');
	instrumentBlueActive();
	hideAllInstrumentsExcept('blue');
	selectorBlueClick(this);
	
});	






