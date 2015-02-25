
var processJson = function(jsonPath,musicListId){
	
$.ajax({
	url:"html/musicList.html",
	async :false,
	success:function(result){
	
		$.getJSON(jsonPath, function(obj) {
			
			$(musicListId).append(result);
			
			$('li').last().attr('id','0');
			$('li').last().attr('value','0');
			
			$('input').last().attr('id','0');
			$('input').last().attr('value','0');
			$('label').last().attr('for', '0');
			$("label").last().append("Off");
			
			for(var i=0 ; i<obj.data.length; i++){
				
				$(musicListId).append(result);
				
				$('li').last().attr('id',obj.data[i].music_path);
				$('li').last().attr('value',obj.data[i].id);
				
				$('input').last().attr('id', obj.data[i].music_path);
				$('input').last().attr('value', obj.data[i].id);
				$('label').last().attr('for', obj.data[i].category);
				$("label").last().append(obj.data[i].title);
				
			}	
			//$("#audio").trigger('pagecreate');
			
			var category=obj.data[1].category;
			
			switch (category){
				case "guitar":
					LENGTH_GUITAR_LIST = obj.data.length;
					break;
				case "drums" :
					LENGTH_DRUMS_LIST = obj.data.length;
					break;
				case "flute" :
					LENGTH_FLUTE_LIST = obj.data.length;
					break;
				case "cello" :
					LENGTH_CELLO_LIST = obj.data.length;
					break;
				case "brass" :
					LENGTH_BRASS_LIST = obj.data.length;
					break;
			}
		});
	}
});
};