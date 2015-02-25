var beatIndicatorFlow = function(color){
	
	var nodeIdCurrent = ogenCount;
	var nodeIdPrev=(ogenCount=='0') ? 15 : ogenCount-1 ;
	 
	var idCurrentIndicator='#iconContainerIndicator #node-'+nodeIdCurrent+'-'+color+' span';
	var idPreviousIndicator='#iconContainerIndicator #node-'+nodeIdPrev+'-'+color+' span';
	var idCurrentSelector='#iconContainerSelector #node-'+nodeIdCurrent+' span';
	var idPreviousSelector='#iconContainerSelector #node-'+nodeIdPrev+' span';
	
	if(!$(idCurrentIndicator).hasClass('padd-ring-indicator')) {
		$(idCurrentIndicator).addClass('padd-ring-indicator');
	}
	if ($(idPreviousIndicator).hasClass('padd-ring-indicator')) {
	    $(idPreviousIndicator).removeClass('padd-ring-indicator');
	}
	
	if(!$(idCurrentSelector).hasClass('padd-ring-selector')) {
		$(idCurrentSelector).addClass('padd-ring-selector');
	}
	if ($(idPreviousSelector).hasClass('padd-ring-selector')) {
	    $(idPreviousSelector).removeClass('padd-ring-selector');
	}
	
};


