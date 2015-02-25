var setPlayerCss = function(value,color,that,selectorIndicator){

	var id='#musicList'+color[0].toUpperCase()+color.slice(1);	
	
	if(value == '0'){
		
		$(that).removeClass("selector-list-"+color+"-bg-selected").addClass("selector-list-"+color+"-bg-off");
		$(selectorIndicator).removeClass('beat-indicator-'+color+'-on').addClass('beat-indicator-'+color+'-off');
		$(id+' input:radio[name=radio-choice]')[0].checked = true;
	}
	else{
		$(that).removeClass("selector-list-"+color+"-bg-off").addClass("selector-list-"+color+"-bg-selected");
		$(selectorIndicator).removeClass('beat-indicator-'+color+'-off').addClass('beat-indicator-'+color+'-on');
		
	}
};