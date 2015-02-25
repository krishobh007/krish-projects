/* Clicking on music-selector icon list Blue */

var selectorBlueClick = function(that){
	
	hideAllPanelsExcept("switch");
	
	index=$(that).attr('id');
	
	countBlue=selectorListIdBlue[index];
	selectorIndicator='#iconContainerIndicator #node-'+(index)+'-blue span';
	
	// Selecting music file from the list : manually selecting.
	
	$("#musicListBlue li").click(function() {
	
		var value=$(this).children("input").attr("value");
		var title=$(this).children("input").attr("id");
		$('#musicListBlue input:radio[name=radio-choice]')[value].checked = true;
		
		musicNodeIdBlue[index]=title;
		selectorListIdBlue[index]=value;
		setPlayerCss(value,'blue',that,selectorIndicator);
		checkInstrumentStatus('blue');
		appendAudio('blue');
		countBlue=value-1;
	});
	
	// Selecting music file from the list : by clicking selector icon repeatedly.
	
	if(countBlue == LENGTH_BRASS_LIST+1) {
		countBlue=0;
	}
	
	setPlayerCss(countBlue,'blue',that,selectorIndicator);
	
	if(countBlue == '0'){
		title='0';
	}
	else{
		$('#musicListBlue input:radio[name=radio-choice]')[countBlue].checked = true;
		
		title=$("input[name=radio-choice]:radio:checked").attr("id");
		
	}
	
	countBlue++;
	musicNodeIdBlue[index]=title;
	selectorListIdBlue[index]=countBlue;
	checkInstrumentStatus('blue');
	appendAudio('blue');
};	