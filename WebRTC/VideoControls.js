
// Controls on video.
function goFullscreen(id) {
		console.log("full screen");
    	var element = document.getElementById(id);

    	if (element.mozRequestFullScreen) {
      		element.mozRequestFullScreen();
    	}
		else if (element.webkitRequestFullScreen){
	      		element.webkitRequestFullScreen();
	   	}
}

function muteUnmute(id){
	console.log("Mute/Unmute"+id);
	var myVideo=document.getElementById(id); 
	var vol=$('.volume');
	if(myVideo.muted){
		myVideo.muted=false; 
		vol.css('background-position', '0 -39px');
	}
	else {
		myVideo.muted=true; 
		vol.css('background-position', '0 0');
		$("#slider a").css('left', 0).text("");
		$("#slider div").css('width','0px');	
	}
}

function volumeControl(vol){
	console.log("@volumeControl"+vol);
	var video=document.getElementById("vid2"); 
	video.volume= Math.round((vol*0.1)*10)/10;
}

function minimize(){
	$("#min_btn").toggleClass("hide-minimise-btn",100);
	console.log("toggle");
	$("#selfVideo").toggleClass("hide-self",100);
	$("#vid1").toggle();
}

function videoControl(){
	$("#videoControl").toggleClass("video-disable",100);
	toggleVideoMute();
}
function micControl(){
	$("#micControl").toggleClass("mic-disable",100);
	toggleAudioMute();
}





