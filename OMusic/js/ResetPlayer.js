/*** 
File	: ResetPlayer
Author  : Krishobh
Purpose : Reset the Music player
***/

var resetPlayer = function(){
	
	$.mobile.changePage("#audio");
	$('#pause-icon').hide();
	$('#play-icon').show();
	play=0;
	
};
