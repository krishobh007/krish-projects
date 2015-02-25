//Add employee details
var addDetails=function(){
	console.log("add details");
	var fname = $("#fname").val();
	var lname = $("#lname").val();
	var designation = $("#inputDesig").val();
	var salary =  $("#salary").val();
	var email =  $("#email").val();
	var address =  $("#address").val();
	var phone_no =  $("#mobile").val();
	
	var empDetails = {	
			firstname : fname,
			lastname : lname,
			designation : designation,
			emailid : email,
			phone : phone_no,
			address : address,
			sal : salary
	}
	//post data
	$.ajax({
		  type: 'POST',
		  dataType:"JSON",
		  url: baseURL+"createemployee/",
		  data: empDetails,
		  success: function(result){
			 console.log("success posting");
			 $('#addDetails').modal('hide');
		  }
	});
};


