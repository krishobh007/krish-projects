var loadJson = function (category)	{
	var jsonPath;
	var musicListId;
	
	switch(category){
		
		case 'guitar':
			jsonPath="json/playListGuitar.json";
			musicListId="#musicListRed";
			processJson(jsonPath,musicListId);
			break;
		case 'drums':
			jsonPath="json/playListDrums.json";
			musicListId="#musicListYellow";
			processJson(jsonPath,musicListId);
			break;
		case 'flute':
			jsonPath="json/playListFlute.json";
			musicListId="#musicListGreen";
			processJson(jsonPath,musicListId);
			break;
		case 'cello':
			jsonPath="json/playListCello.json";
			musicListId="#musicListSkyblue";
			processJson(jsonPath,musicListId);
			break;
		case 'brass':
			jsonPath="json/playListBrass.json";
			musicListId="#musicListBlue";
			processJson(jsonPath,musicListId);
			break;
		case 'songs':
			jsonPath="json/backgroundSongs.json";
			musicListId="#backgroundSongs";
			appendSongs(jsonPath,musicListId);
			break;
		default:
			console.log("case default");
		}
};

