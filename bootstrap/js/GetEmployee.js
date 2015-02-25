function getEmployee(){
	var that=this;
	var value = jQuery(that).parent().attr("id");
	console.log("clicked. "+value);
		
		$.ajax({
			url: baseURL+"editDetails/",
			method:"POST",
			data :{'id': value },
			async:true,
			success: function(object){
				object = JSON.parse(object);
				console.log(object);
				$("#viewFname").html(object.first_name);
				$("#viewLname").html(object.last_name);
				$("#viewDesig").html(object.designation);
				$("#viewSalary").html(object.sal);
				$("#viewEmail").html(object.email_id);
				$("#viewAddress").html(object.office_address);
				$("#viewMobile").html(object.phone_no);
				$('#viewDetailsMob').modal('show');
			}
		});
}
