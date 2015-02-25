/* Clicking on music-selector icon list yellow */

var selectorYellowClick = function(that){
	
	hideAllPanelsExcept("switch");
	
	index=$(that).attr('id');
	
	countYellow=selectorListIdYellow[index];
	selectorIndicator='#iconContainerIndicator #node-'+(index)+'-yellow span';
	
	// Selecting music file from the list : manually selecting.
	
	$("#musicListYellow li").click(function() {
		
		var value=$(this).children("input").attr("value");
		var title=$(this).children("input").attr("id");
		$('#musicListYellow input:radio[name=radio-choice]')[value].checked = true;
		
		musicNodeIdYellow[index]=title;
		selectorListIdYellow[index]=value;
		setPlayerCss(value,'yellow',that,selectorIndicator);
		checkInstrumentStatus('yellow');
		appendAudio('yellow');
		countYellow=value-1;
	});
	
	// Selecting music file from the list : by clicking selector icon repeatedly.
	
	if(countYellow == LENGTH_DRUMS_LIST+1) {
		countYellow=0;
	}
	setPlayerCss(countYellow,'yellow',that,selectorIndicator);

	if(countYellow == '0'){
		title='0';
	}
	else{
		$('#musicListYellow input:radio[name=radio-choice]')[countYellow].checked = true;
		
		title=$("input[name=radio-choice]:radio:checked").attr("id");
		
	}
	
	countYellow++;
	musicNodeIdYellow[index]=title;
	selectorListIdYellow[index]=countYellow;
	checkInstrumentStatus('yellow');
	appendAudio('yellow');
};	