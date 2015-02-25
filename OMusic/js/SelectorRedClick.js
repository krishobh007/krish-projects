/* Clicking on music-selector icon list red */

var selectorRedClick = function(that){
	
	hideAllPanelsExcept("switch");
	
	index=$(that).attr('id');
	countRed=selectorListIdRed[index];
	selectorIndicator='#iconContainerIndicator #node-'+(index)+'-red span';
	
	// Selecting music file from the list : manually selecting.
	
	$("#musicListRed li").click(function() {
		
		var value=$(this).children("input").attr("value");
		var title=$(this).children("input").attr("id");
		$('#musicListRed input:radio[name=radio-choice]')[value].checked = true;
		
		musicNodeIdRed[index]=title;
		selectorListIdRed[index]=value;
				
		setPlayerCss(value,'red',that,selectorIndicator);
		checkInstrumentStatus('red');
		appendAudio('red');
		countRed=value-1;
	});
	
	// Selecting music file from the list : by clicking selector icon repeatedly.
	
	if(countRed == LENGTH_GUITAR_LIST+1) {
		countRed=0;
	}
	setPlayerCss(countRed,'red',that,selectorIndicator);
	
	if(countRed == '0'){
		title='0';
	}
	else{
		$('#musicListRed input:radio[name=radio-choice]')[countRed].checked = true;
		
		title=$("input[name=radio-choice]:radio:checked").attr("id");
	}
	
	countRed++;
	musicNodeIdRed[index]=title;
	selectorListIdRed[index]=countRed;
	checkInstrumentStatus('red');
	appendAudio('red');
};

