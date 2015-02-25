/* circular path creating using jQuery */
function drawCircle(selector, center, radius, angle, x, y) {
	
    var total = $(selector).length;
    var alpha = Math.PI * 2 / total;
           
    $(selector).each(function(index)
    {
        var theta = alpha * index;
        var pointx  =  Math.floor(Math.cos( theta ) * radius);
        var pointy  = Math.floor(Math.sin( theta ) * radius );
		
        $(this).css('margin-left', pointx + x + 'px');
        $(this).css('margin-top', pointy  + y  + 'px');
    });
}







