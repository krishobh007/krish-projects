var playSource = function(count,color)  { 
	
	var musicId;
	
	switch(color){
		case 'red':
			musicId="musicRed-"+count;
			break;
		case 'yellow':
			musicId="musicYellow-"+count;
			break;
		case 'green':
			musicId="musicGreen-"+count;
			break;
		case 'skyblue':
			musicId="musicSkyblue-"+count;
			break;
		case 'blue':
			musicId="musicBlue-"+count;
			break;
		default:
			console.log("case default");
	}
	
	if(play==0){
		document.getElementById(musicId).pause();
	}
	else{
	 	document.getElementById(musicId).currentTime = 0;
	 	$('#'+musicId).attr('autoplay', false);
	 	document.getElementById(musicId).play();
	 	
	 	setTimeout(function(){document.getElementById(musicId).pause();}, INTERVAL);
	}
};
