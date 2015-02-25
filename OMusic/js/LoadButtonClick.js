$("#loadIcon").live("click", function(){
	
	disableControlBtnNotActive();
	
	$(this).removeClass("load-icon-standard").addClass("load-icon-selected");
	
	//hideAllPanelsExcept("load");
	
	//Loading saved elements of music.
	
	var value,that,that2;
	
	//------red(Giutar)-------

	selectorListIdRed=['2','0','3','0','0','4','0','0','0','6','0','0','0','0','0','0'];

	musicNodeIdRed=['assets/Sounds/Guitar/Guitar_1.wav','0','assets/Sounds/Guitar/Guitar_2.wav','0','0','assets/Sounds/Guitar/Guitar_3.wav','0','0','0','assets/Sounds/Guitar/Guitar_5.wav','0','0','0','0','0','0'];

	//------yellow(Drums)-----

	selectorListIdYellow=['0','2','0','0','3','0','0','0','0','0','0','0','5','0','0','0'];

	musicNodeIdYellow=['0','assets/Sounds/Drums/Drum_1.wav','0','0','assets/Sounds/Drums/Drum_2.wav','0','0','0','0','0','0','0','assets/Sounds/Drums/Drum_4.wav','0','0','0'];

	//------green(Flute)------

	selectorListIdGreen=['0','0','0','3','0','0','0','4','0','0','0','0','0','0','5','0'];

	musicNodeIdGreen=['0','0','0','assets/Sounds/Flute/Flute_2.wav','0','0','0','assets/Sounds/Flute/Flute_3.wav','0','0','0','0','0','0','assets/Sounds/Flute/Flute_4.wav','0'];

	//------skyblue(Cello)----

	selectorListIdSkyblue=['0','0','0','0','0','0','4','0','0','0','6','0','0','0','0','3'];

	musicNodeIdSkyblue=['0','0','0','0','0','0','assets/Sounds/Cello/Cello_3.wav','0','0','0','assets/Sounds/Cello/Cello_5.wav','0','0','0','0','assets/Sounds/Cello/Cello_2.wav'];

	//------blue(Brass)-------

	selectorListIdBlue=['0','0','0','0','0','0','0','0','2','0','0','0','0','4','0','0'];

	musicNodeIdBlue=['0','0','0','0','0','0','0','0','assets/Sounds/Brass/brass_1.wav','0','0','0','0','assets/Sounds/Brass/brass_3.wav','0','0'];

	for(var i=0;i<16;i++){
		value= selectorListIdRed[i];
		that='#selectorListRed .icon-red span#'+i;
		that2='#indicatorListRed #node-'+i+'-red span';
		setPlayerCss(value,'red',that,that2);
	}
	for(var i=0;i<16;i++){
		value= selectorListIdYellow[i];
		that='#selectorListYellow .icon-yellow span#'+i;
		that2='#indicatorListYellow #node-'+i+'-yellow span';
		setPlayerCss(value,'yellow',that,that2);
	}
	for(var i=0;i<16;i++){
		value= selectorListIdGreen[i];
		that='#selectorListGreen .icon-green span#'+i;
		that2='#indicatorListGreen #iconContainerIndicator #node-'+i+'-green span';
		setPlayerCss(value,'green',that,that2);
	}
	for(var i=0;i<16;i++){
		value= selectorListIdSkyblue[i];
		that='#selectorListSkyblue .icon-skyblue span#'+i;
		that2='#indicatorListSkyblue #node-'+i+'-skyblue span';
		setPlayerCss(value,'skyblue',that,that2);
	}
	for(var i=0;i<16;i++){
		value= selectorListIdBlue[i];
		that='#selectorListBlue .icon-blue span#'+i;
		that2='#indicatorListBlue #node-'+i+'-blue span';
		setPlayerCss(value,'blue',that,that2);
	}
	
	checkInstrumentStatus('red');
	checkInstrumentStatus('yellow');
	checkInstrumentStatus('green');
	checkInstrumentStatus('skyblue');
	checkInstrumentStatus('blue');
});	
