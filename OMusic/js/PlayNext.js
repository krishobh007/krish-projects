
var playNext = function(){
	
	//Case Guitar
	if(selectorListIdRed[ogenCount]!='0'){
		if(musicNodeIdRed[ogenCount]!='0'){
			playSource(ogenCount,'red');
		}
	}
	//Case Drums
	if(selectorListIdYellow[ogenCount]!='0'){
		if(musicNodeIdYellow[ogenCount]!='0'){
			playSource(ogenCount,'yellow');
		}
	}
	//Case Flute
	if(selectorListIdGreen[ogenCount]!='0'){
		if(musicNodeIdGreen[ogenCount]!='0'){
			playSource(ogenCount,'green');
		}
	}
	//Case Cello
	if(selectorListIdSkyblue[ogenCount]!='0'){
		if(musicNodeIdSkyblue[ogenCount]!='0'){
			playSource(ogenCount,'skyblue');
		}
	}
	//Case Brass
	if(selectorListIdBlue[ogenCount]!='0'){
		if(musicNodeIdBlue[ogenCount]!='0'){
			playSource(ogenCount,'blue');
		}
	}
	
};
