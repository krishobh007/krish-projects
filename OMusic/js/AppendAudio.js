var appendAudio = function(color){
	
	console.log("appendAudio - "+color);
	var selectorListId=[];
	var musicNodeId=[];
	var audioListId;
	
	switch(color){
	
		case 'red':
			audioListId="#audioList #redList";
			musicId="musicRed-";
			mp3SrcId="mp3srcRed-";
			selectorListId=selectorListIdRed;
			musicNodeId=musicNodeIdRed;
			break;
		case 'yellow':
			audioListId="#audioList #yellowList";
			musicId="musicYellow-";
			mp3SrcId="mp3srcYellow-";
			selectorListId=selectorListIdYellow;
			musicNodeId=musicNodeIdYellow;
			break;
		case 'green':
			audioListId="#audioList #greenList";
			musicId="musicGreen-";
			mp3SrcId="mp3srcGreen-";
			selectorListId=selectorListIdGreen;
			musicNodeId=musicNodeIdGreen;
			break;
		case 'skyblue':
			audioListId="#audioList #skyblueList";
			musicId="musicSkyblue-";
			mp3SrcId="mp3srcSkyblue-";
			selectorListId=selectorListIdSkyblue;
			musicNodeId=musicNodeIdSkyblue;
			break;
		case 'blue':
			audioListId="#audioList #blueList";
			musicId="musicBlue-";
			mp3SrcId="mp3srcBlue-";
			selectorListId=selectorListIdBlue;
			musicNodeId=musicNodeIdBlue;
			break;
		default:
			console.log("case default");
	}
	
	$.ajax({
		url:"html/audioList.html",
		async :false,
		success:function(result){
			$(audioListId).html("");
			for(var i=0;i<16;i++){
				
				if(selectorListId[i]!='0' && selectorListId[i]!=undefined){
					if(musicNodeId[i]!='0' && musicNodeId[i]!=undefined){
						
						$(audioListId).append(result);
						$(audioListId+' audio').last().attr('id', musicId+i);
						$(audioListId+' source').last().attr('id', mp3SrcId+i);
						$(audioListId+' source').last().attr('src', musicNodeId[i]);
					}
				}
			}
		
		}
	});
};
