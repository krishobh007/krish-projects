$("#saveIcon").live("click", function(){
	
	disableControlBtnNotActive();
	
	$(this).removeClass("save-icon-standard").addClass("save-icon-selected");
	save=1;
	
	//hideAllPanelsExcept("save");
	
	saveMusic();
});	

var saveMusic = function(){
	
	//generate array
	
	var sRed="'"+selectorListIdRed[0]+"'";
	var mRed="'"+musicNodeIdRed[0]+"'";
	
	var sYellow="'"+selectorListIdYellow[0]+"'";
	var mYellow="'"+musicNodeIdYellow[0]+"'";
	
	var sGreen="'"+selectorListIdGreen[0]+"'";
	var mGreen="'"+musicNodeIdGreen[0]+"'";
	
	var sSkyblue="'"+selectorListIdSkyblue[0]+"'";
	var mSkyblue="'"+musicNodeIdSkyblue[0]+"'";
	
	var sBlue="'"+selectorListIdBlue[0]+"'";
	var mBlue="'"+musicNodeIdBlue[0]+"'";
	
	for(var i=1;i<16;i++){
		
		sRed +=",'"+selectorListIdRed[i]+"'";
		mRed +=",'"+musicNodeIdRed[i]+"'";
		
		sYellow +=",'"+selectorListIdYellow[i]+"'";
		mYellow +=",'"+musicNodeIdYellow[i]+"'";
		
		sGreen +=",'"+selectorListIdGreen[i]+"'";
		mGreen +=",'"+musicNodeIdGreen[i]+"'";
		
		sSkyblue +=",'"+selectorListIdSkyblue[i]+"'";
		mSkyblue +=",'"+musicNodeIdSkyblue[i]+"'";
		
		sBlue +=",'"+selectorListIdBlue[i]+"'";
		mBlue +=",'"+musicNodeIdBlue[i]+"'";
	}
	
	console.log(
		"//------red(Giutar)-------\n\nselectorListIdRed=["+sRed+"];\n\nmusicNodeIdRed=["+mRed+"];\n\n" +
		"//------yellow(Drums)-----\n\nselectorListIdYellow=["+sYellow+"];\n\nmusicNodeIdYellow=["+mYellow+"];\n\n" +
		"//------green(Flute)------\n\nselectorListIdGreen=["+sGreen+"];\n\nmusicNodeIdGreen=["+mGreen+"];\n\n" +
		"//------skyblue(Cello)----\n\nselectorListIdSkyblue=["+sSkyblue+"];\n\nmusicNodeIdSkyblue=["+mSkyblue+"];\n\n"+
		"//------blue(Brass)-------\n\nselectorListIdBlue=["+sBlue+"];\n\nmusicNodeIdBlue=["+mBlue+"];\n\n"
	);
	alert(
		"//------red(Giutar)-------\n\nselectorListIdRed=["+sRed+"];\n\nmusicNodeIdRed=["+mRed+"];\n\n" +
		"//------yellow(Drums)-----\n\nselectorListIdYellow=["+sYellow+"];\n\nmusicNodeIdYellow=["+mYellow+"];\n\n" +
		"//------green(Flute)------\n\nselectorListIdGreen=["+sGreen+"];\n\nmusicNodeIdGreen=["+mGreen+"];\n\n" +
		"//------skyblue(Cello)----\n\nselectorListIdSkyblue=["+sSkyblue+"];\n\nmusicNodeIdSkyblue=["+mSkyblue+"];\n\n"+
		"//------blue(Brass)-------\n\nselectorListIdBlue=["+sBlue+"];\n\nmusicNodeIdBlue=["+mBlue+"];\n\n"
	);
	
};
