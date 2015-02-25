var value;
//fetch details from the table and fill in the form

var fetchDetails=function(){
	console.log("fetch details");
	var isOneChecked = $("input[type='checkbox']:checked").length ;
	if(isOneChecked==1){
		$("input:checkbox").each(function(){
		    var $this = $(this);
		    if($this.is(":checked")){
		    	value = $this.attr("id");
		    	console.log("checkd "+value);
		    }
		});
		
		$.ajax({
			url: baseURL+"editDetails/",
			method:"POST",
			data :{'id': value },
			async:true,
			success: function(object){
				object = JSON.parse(object);
				$("#editFname").val(object.first_name);
				$("#editLname").val(object.last_name);
				$("#editDesig").val(object.designation);
				$("#editSalary").val(object.sal);
				$("#editEmail").val(object.email_id);
				$("#editAddress").val(object.office_address);
				$("#editMobile").val(object.phone_no);
				$('#editDetails').modal('show');
			}
		});
	}
	else{
		console.log("more than one selection");
	}
};

//update the table
var updateDetails=function(){
	
	console.log("edit details");
	var fname = $("#editFname").val();
	var lname = $("#editLname").val();
	var designation = $("#editDesig").val();
	var salary =  $("#editSalary").val();
	var email =  $("#editEmail").val();
	var address =  $("#editAddress").val();
	var phone_no =  $("#editMobile").val();
	console.log(fname+lname+designation+salary+email+address+phone_no);
	var empDetails = {	
			firstname : fname,
			lastname : lname,
			designation : designation,
			emailid : email,
			phone : phone_no,
			address : address,
			sal : salary,
			id : value
	}
	//post data
	$.ajax({
		  type: 'POST',
		  dataType:"JSON",
		  url: baseURL+"editemployees/",
		  data: empDetails,
		  success: function(result){
			 console.log("success posting");
			 $('#editDetails').modal('hide');
			 renderPage(0);
			 $("#edit-btn").hide();
			 $("#delete-btn").hide();
		  }
	});
};