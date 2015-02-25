var selectorListIdRed=new Array();
var selectorListIdYellow=new Array();
var selectorListIdGreen=new Array();
var selectorListIdSkyblue=new Array();
var selectorListIdBlue=new Array();

var musicNodeIdRed=new Array();
var musicNodeIdYellow=new Array();
var musicNodeIdGreen=new Array();
var musicNodeIdSkyblue=new Array();
var musicNodeIdBlue=new Array();

for(var i=0;i<16;i++){
	
	selectorListIdRed[i]='0';
	selectorListIdYellow[i]='0';
	selectorListIdGreen[i]='0';
	selectorListIdSkyblue[i]='0';
	selectorListIdBlue[i]='0';
	
	musicNodeIdRed[i]='0';
	musicNodeIdYellow[i]='0';
	musicNodeIdGreen[i]='0';
	musicNodeIdSkyblue[i]='0';
	musicNodeIdBlue[i]='0';
}

var INTERVAL=500;//Player delay between two nodes.

var LENGTH_GUITAR_LIST=0;
var LENGTH_DRUMS_LIST=0;
var LENGTH_FLUTE_LIST=0;
var LENGTH_CELLO_LIST=0;
var LENGTH_BRASS_LIST=0;

var ogenCount=0; // The value of the counter rotates from 0 to 16.

//	Flags for control play|pause function.

var controlFlag;
var play=0;
var save=0;