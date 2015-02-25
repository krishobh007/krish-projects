
$(document).ready(function(){
	
	var x1=200,x2=200;
	var y1=210,y2=215;
	
	
	drawCircle('.box-red-selector'		, 0, 185, 180, x1, y1);
	drawCircle('.box-yellow-selector'	, 0, 185, 180, x1, y1);
	drawCircle('.box-green-selector'	, 0, 185, 180, x1, y1);
	drawCircle('.box-skyblue-selector'	, 0, 185, 180, x1, y1);
	drawCircle('.box-blue-selector'		, 0, 185, 180, x1, y1);
	
	indicatorView('red','yellow','green','skyblue','blue');
	
	drawCircle('.box-play'				, 0, 0, 0, x2, y2);
	drawCircle('.box-paused'			, 0, 0, 0, x2, y2);
	
	/* Control Elements */
	$("#pauseIcon").hide();
	
	loadJson('songs');	// Load background songs manually. TODO : Load songs on selection list
	loadJson('guitar');	// Load playList of Guitar.
	loadJson('drums');	// Load playList of Drums.
	loadJson('flute');	// Load playList of Flute.
	loadJson('cello');	// Load playList of Cello.
	loadJson('brass');	// Load playList of Brass.
	
	$("#audioList").hide();
	$("#backgroundSongs").hide();
	
	hideAllSelectorsExcept('red');
	
	showAllIndicatorsExcept('red');
	
	hideAllMusicList();
	
	showAllInstruments();
	
	hideAllPanelsExcept("switch");
	
	$('#saveIcon').unbind('click');
	
});

var indicatorView = function(color1,color2,color3,color4,color5){
	
	var x2=210,y2=225;
	
	drawCircle('.box-'+color1+'-indicator'	, 0, 145, 180, x2, y2);
	drawCircle('.box-'+color2+'-indicator'	, 0, 125, 180, x2, y2);
	drawCircle('.box-'+color3+'-indicator'	, 0, 100, 180, x2, y2);
	drawCircle('.box-'+color4+'-indicator'	, 0, 75, 180, x2, y2);
	drawCircle('.box-'+color5+'-indicator'	, 0, 50, 180, x2, y2);
};

var hideAllSelectorsExcept = function(id){
	
	id=id[0].toUpperCase()+id.slice(1);	
	$("#selectorListRed").hide();
	$("#selectorListYellow").hide();
	$("#selectorListGreen").hide();
	$("#selectorListSkyblue").hide();
	$("#selectorListBlue").hide();
	
	$("#selectorList"+id).show();
	
};
var showAllIndicatorsExcept = function(id){
	id=id[0].toUpperCase()+id.slice(1);	
	$("#indicatorListRed").show();
	$("#indicatorListYellow").show();
	$("#indicatorListGreen").show();
	$("#indicatorListSkyblue").show();
	$("#indicatorListBlue").show();
	
	$("#indicatorList"+id).hide();
};
var hideAllMusicList = function(){
	
	$("#musicListRed").hide();
	$("#musicListYellow").hide();
	$("#musicListGreen").hide();
	$("#musicListSkyblue").hide();
	$("#musicListBlue").hide();
	
};
var hideAllMusicListExcept = function(id){
	
	id=id[0].toUpperCase()+id.slice(1);	
	hideAllMusicList();
	
	$("#musicList"+id).show();
};

var showAllInstruments = function(){
	
	$("#instrumentIconYellow").show();
	$("#instrumentIconRed").show();
	$("#instrumentIconGreen").show();
	$("#instrumentIconSkyblue").show();
	$("#instrumentIconBlue").show();
	
};
var hideAllInstruments = function(){
	
	$("#instrumentIconYellow").hide();
	$("#instrumentIconRed").hide();
	$("#instrumentIconGreen").hide();
	$("#instrumentIconSkyblue").hide();
	$("#instrumentIconBlue").hide();
	
};
var hideAllInstrumentsExcept = function(id){
	
	id=id[0].toUpperCase()+id.slice(1);	
	
	hideAllInstruments();
	
	$("#instrumentIcon"+id).show();
};

var hideAllPanels = function(){
	
	$("#panelViewSwitch").hide();
	$("#panelViewSave").hide();
	$("#panelViewLoad").hide();
	$("#panelViewVolume").hide();
	$("#panelViewBars").hide();
	$("#panelViewTempo").hide();
};

var hideAllPanelsExcept = function(id){
	
	id=id[0].toUpperCase()+id.slice(1);	
	
	hideAllPanels();
	
	$("#panelView"+id).show();
};


