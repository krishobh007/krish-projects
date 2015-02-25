
//display table employee

var baseURL = "http://djangostaging.qburst.com/learningdjango_api/"
var count,total_count,displaying_count,htmlContent;
var json_path = baseURL+"employees/";

$(document).ready(function() {
	console.log("document ready");
	$.getJSON(json_path,{offset:0},function(obj){
		total_count=obj.total_count; 
		displaying_count=obj.displaying_count;
		count=Math.ceil(total_count/displaying_count);
		console.log("displaying_count="+displaying_count+"\t"+"total_count="+total_count+"\t count="+count);
		nextPage(0);
		renderPage(0);
		$("#inputSearch").bind("keydown",function(e){
			if (e.keyCode === 13) {
				searchDetails();
				return false;
			}
		});
		$("#searchBtn").bind("click",function(){
			searchDetails();
			return false;
		});
	});
});

var renderPage = function(pageNo){
	
	if(pageNo<0){
		pageNo=0;
	}
	else if(pageNo>=count){
		pageNo=count;
	}
	else{
		choice=pageNo*100;
	
		$.ajax({
			url: json_path,
			data: {offset:choice},
			async:false,
			success: function(obj) {
	    				obj=JSON.parse(obj);
	    				fetchHTML();
	    	 			$('#viewDetails').empty().append(""); 
		    				for(var i=0; i<obj.displaying_count; i++){
		    					$('#viewDetails').append(htmlContent); 
		    					addContents(obj.data[i]);
		    				}
		    				if ( $(window).width() < 590) {
								$("td").not(".listCheckbox").click(getEmployee);
		    				}
			    			$('#resultPage').html("Showing results "+(choice+1)+" - "+(choice+obj.displaying_count)+" of "+obj.total_count+" , Page "+(pageNo+1)+" of "+count)+"  "+obj.time_taken;
	    			}
	    });//ajax
	}
};

var cheked = function(){
	    var selection_count = $("input[type='checkbox']:checked").length ;
	    if(selection_count > 0){
	    	$("#edit-btn").show();
    		$("#delete-btn").show();
    		if(selection_count>1){
    			$("#edit-btn").hide();
    		}
	    } 
	    else{
	    	$("#edit-btn").hide();
    		$("#delete-btn").hide();
	    }
};

var nextPage = function (pageNo){
	console.log("page no"+pageNo);
	if(pageNo<0){
		pageNo=0;
		
	}
	else if(pageNo>=count){
		pageNo=count;
	}
		var list="<li><a href='#' onclick='renderPage(0),nextPage(0);'>&laquo;</a></li>"+
					"<li id='pageBack' class=''><a href='#' onclick='renderPage("+(pageNo-1)+"),nextPage("+(pageNo-1)+");'>&lt;</a></li>";
		var i=pageNo;
		
		if(pageNo>0){
			if((i+2)>=count){
				i-=2;
				
			}
		}
		
		if(pageNo>=count ){
			
			for(j=0;j<5 && i<count; i++,j++){
				list+="<li><a href='#' onclick='renderPage("+i+")'>"+(i+1)+"</a></li>";
			}
			list+="<li id='pageNext' class=''><a href='#' onclick='renderPage("+(pageNo+1)+"),nextPage("+(pageNo+1)+");'>&gt;</a></li>"+
			"<li><a href='#' onclick='renderPage("+(count-1)+"),nextPage("+(count-1)+");'>&raquo;</a></li>";
		}
		else {
			for(j=0;j<5 && i<count;i++,j++){
				
				list+="<li><a href='#' onclick='renderPage("+i+"),nextPage("+i+")'>"+(i+1)+"</a></li>";
			}
			list+="<li id='pageNext' class=''><a href='#' onclick='renderPage("+(pageNo+1)+"),nextPage("+(pageNo+1)+");'>&gt;</a></li>"+
			"<li><a href='#' onclick='renderPage("+(count-1)+"),nextPage("+(count-1)+");'>&raquo;</a></li>";
		}
		$('#pageList').empty().append(list);
		
		if(pageNo==0)
		{
			$('li#pageBack').addClass('disabled');
		}
		if(pageNo==count){
			$('li#pageNext').addClass('disabled');
		}
};

//fetch the row
var fetchHTML = function(){
	$.ajax({
			url: "html/populate_list_employee.html",
			async:false,
			success: function(html) {
				htmlContent = html;
			}
	});
};

//add the contents from the json to the table
var addContents = function(data){
	$("input[name=selected]").last().attr("id",data.id);
	$('tr').last().attr("id",data.id);
	$('tr:last-child #first_name').html(data.first_name);
	$('tr:last-child #last_name').html(data.last_name);
	$('tr:last-child #designation').html(data.designation);
	$('tr:last-child #sal').html(data.sal);
	$('tr:last-child #email_id').html(data.email_id);
	$('tr:last-child #office_address').html(data.office_address);
	$('tr:last-child #phone_no').html(data.phone_no);
	$('input[name=selected]').last().click(cheked);
};




