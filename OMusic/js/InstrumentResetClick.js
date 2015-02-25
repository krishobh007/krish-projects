// Reset Status of each instrument.

$("#instrumentIconRed span.instrument-reset").live("click", function(){

	if($("#instrumentIconRed span").hasClass("instrument-include-on")){
		selector="#instrumentIconRed span.instrument-left";
		toggleStatusIcon(0,selector);
		for(var i=0;i<16;i++){
			musicNodeIdRed[i]='0';
			selectorListIdRed[i]='0';
			selectorIndicator='#iconContainerIndicator #node-'+i+'-red span';
			setPlayerCss('0','red','.icon-red span',selectorIndicator);
		}
	}
});

$("#instrumentIconYellow span.instrument-reset").live("click", function(){
	if($("#instrumentIconYellow span").hasClass("instrument-include-on")){
		selector="#instrumentIconYellow span.instrument-left";
		
		toggleStatusIcon(0,selector);
		for(var i=0;i<16;i++){
			musicNodeIdYellow[i]='0';
			selectorListIdYellow[i]='0';
			selectorIndicator='#iconContainerIndicator #node-'+i+'-yellow span';
			setPlayerCss('0','yellow','.icon-yellow span',selectorIndicator);
		}
	}
});

$("#instrumentIconGreen span.instrument-reset").live("click", function(){
	
	if($("#instrumentIconGreen span").hasClass("instrument-include-on")){
		selector="#instrumentIconGreen span.instrument-left";
		
		toggleStatusIcon(0,selector);
		for(var i=0;i<16;i++){
			musicNodeIdGreen[i]='0';
			selectorListIdGreen[i]='0';
			selectorIndicator='#iconContainerIndicator #node-'+i+'-green span';
			setPlayerCss('0','green','.icon-green span',selectorIndicator);
		}
	}
});

$("#instrumentIconSkyblue span.instrument-reset").live("click", function(){
	
	if($("#instrumentIconSkyblue span").hasClass("instrument-include-on")){
		selector="#instrumentIconSkyblue span.instrument-left";
		
		toggleStatusIcon(0,selector);
		for(var i=0;i<16;i++){
			musicNodeIdSkyblue[i]='0';
			selectorListIdSkyblue[i]='0';
			selectorIndicator='#iconContainerIndicator #node-'+i+'-skyblue span';
			setPlayerCss('0','skyblue','.icon-skyblue span',selectorIndicator);
		}
	}
});

$("#instrumentIconBlue span.instrument-reset").live("click", function(){
	
	if($("#instrumentIconBlue span").hasClass("instrument-include-on")){
		selector="#instrumentIconBlue span.instrument-left";
		
		toggleStatusIcon(0,selector);
		for(var i=0;i<16;i++){
			musicNodeIdBlue[i]='0';
			selectorListIdBlue[i]='0';
			selectorIndicator='#iconContainerIndicator #node-'+i+'-blue span';
			setPlayerCss('0','blue','.icon-blue span',selectorIndicator);
		}
	}
});
