
$("#playIcon").live("click", function(){
		
	if(play=='0'){
		
		play=1;
		console.log("Play..."+play);
		
		//$("#audio-player")[0].play(); // Playing Background song.
		
		//Append audio content to the HTML.
		appendAudio('red');
		appendAudio('yellow');
		appendAudio('green');
		appendAudio('skyblue');
		appendAudio('blue');
		
		controlFlag = setInterval(function() {
				
			if(ogenCount=='16'){
				
				ogenCount=0;
			}
			
			playNext();
			
			beatIndicatorFlow('red');
			beatIndicatorFlow('yellow');
			beatIndicatorFlow('green');
			beatIndicatorFlow('skyblue');
			beatIndicatorFlow('blue');
			
			ogenCount++;
				
		}, INTERVAL);
		
	}
	$("#playIcon").hide();
	$("#pauseIcon").show();
});

