//delete details
var idvalue
var deleteDetails = function(){
	var value=[];
	$("input:checkbox").each(function(){
	    var $this = $(this);
	    if($this.is(":checked")){
	    	value.push($this.attr("id"));
	    }
	});
	console.log("checkd buttns "+value);
	
	idvalue=value[0];
	for(var i=1;i<value.length;i++){
		idvalue += ","+value[i];
	}
	deleteItem(idvalue);
};

//delete the specified employee details
function deleteItem(value){
	
	console.log("deleteItem"+value);
	$.ajax({
		url: baseURL+"deleteemployee/",
		method:"POST",
		data :{'ids': value},
		async:true,
		success: function(object){
			console.log("deleted"+value);
			$('#deleteDetails').modal('hide');
			renderPage(0);
			$("#delete-btn").hide();
		}
	});
}