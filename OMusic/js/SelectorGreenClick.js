/* Clicking on music-selector icon list Green */

var selectorGreenClick = function(that){
	
	hideAllPanelsExcept("switch");
	
	index=$(that).attr('id');
	
	countGreen=selectorListIdGreen[index];
	selectorIndicator='#iconContainerIndicator #node-'+(index)+'-green span';
	
	// Selecting music file from the list : manually selecting.
	
	$("#musicListGreen li").click(function() {
		
		var value=$(this).children("input").attr("value");
		var title=$(this).children("input").attr("id");
		$('#musicListGreen input:radio[name=radio-choice]')[value].checked = true;
		
		musicNodeIdGreen[index]=title;
		selectorListIdGreen[index]=value;
		setPlayerCss(value,'green',that,selectorIndicator);
		checkInstrumentStatus('green');
		appendAudio('green');
		countGreen=value-1;
	});
	
	// Selecting music file from the list : by clicking selector icon repeatedly.
	
	if(countGreen == LENGTH_FLUTE_LIST+1) {
		countGreen=0;
	}
	setPlayerCss(countGreen,'green',that,selectorIndicator);
	if(countGreen == '0'){
		title='0';
	}
	else{
		$('#musicListGreen input:radio[name=radio-choice]')[countGreen].checked = true;
		
		title=$("input[name=radio-choice]:radio:checked").attr("id");
	}
	countGreen++;
	musicNodeIdGreen[index]=title;
	selectorListIdGreen[index]=countGreen;
	
	checkInstrumentStatus('green');
	appendAudio('green');
};
