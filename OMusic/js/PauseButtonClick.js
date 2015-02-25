$("#pauseIcon").live("click", function(){
	
	if(play=='1'){
		$("#audio-player")[0].pause();
		clearInterval(controlFlag);
		play=0;
		console.log("Paused..."+play);
	}
	$("#playIcon").show();
	$("#pauseIcon").hide();
});
