var appendSongs = function(jsonPath,musicListId){
	$.ajax({
		url:"html/audioList.html",
		async :false,
		success:function(result){
			$.getJSON(jsonPath, function(obj) {
				
				for(var i=0 ; i<obj.data.length; i++){
					
					$(musicListId).append(result);
					$('audio').last().attr('id', "audio-player");
					$('source').last().attr('id', "songSrcId-"+i);
					$('source').last().attr('src', obj.data[i].music_path);
					
				}	
				$("#audio").trigger('pagecreate');
			});
		}
	});
};