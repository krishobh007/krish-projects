/* Clicking on music-selector icon list Skyblue */

var selectorSkyblueClick = function(that){
	
	hideAllPanelsExcept("switch");
	
	index=$(that).attr('id');
	
	countSkyblue=selectorListIdSkyblue[index];
	selectorIndicator='#iconContainerIndicator #node-'+(index)+'-skyblue span';
	
	// Selecting music file from the list : manually selecting.
	
	$("#musicListSkyblue li").click(function() {
		
		var value=$(this).children("input").attr("value");
		var title=$(this).children("input").attr("id");
		$('#musicListSkyblue input:radio[name=radio-choice]')[value].checked = true;
		
		musicNodeIdSkyblue[index]=title;
		selectorListIdSkyblue[index]=value;
		setPlayerCss(value,'skyblue',that,selectorIndicator);
		checkInstrumentStatus('skyblue');
		appendAudio('skyblue');
		countSkyblue=value-1;
	});
	
	// Selecting music file from the list : by clicking selector icon repeatedly.
	
	if(countSkyblue == LENGTH_CELLO_LIST+1) {
		countSkyblue=0;
	}
	setPlayerCss(countSkyblue,'skyblue',that,selectorIndicator);
	
	if(countSkyblue == '0'){
		title='0';
	}
	else{
		$('#musicListSkyblue input:radio[name=radio-choice]')[countSkyblue].checked = true;
		
		title=$("input[name=radio-choice]:radio:checked").attr("id");
	}
	countSkyblue++;
	musicNodeIdSkyblue[index]=title;
	selectorListIdSkyblue[index]=countSkyblue;
	checkInstrumentStatus('skyblue');
	appendAudio('skyblue');
};