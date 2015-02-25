//search details
function searchDetails (){
	var search_item = $("#inputSearch").val();
		$.ajax({
				url: baseURL+"search/?offset=0",
				method:"GET",
				data :{search_term : search_item},
				async:false,
				success: function(object){
					object=JSON.parse(object);
					if(object.displaying_count==0)
						$("#notFound").show();
					else
						$("#notFound").hide();
					console.log(object);
					$("#pageDetails").hide();
					
						$('#viewDetails').empty().append(""); 
	    				for(var i=0; i<object.displaying_count; i++){
	    					$('#viewDetails').append(htmlContent); 
	    					addContents(object.data[i]);
	    				}
	    			}
	    });//ajax
}