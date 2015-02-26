var RoomassignmentErrorModal = function(callBack) {
	BaseModal.call(this);
	var that = this;
	this.url = "ui/roomAssignmentFailureModal";

	this.delegateEvents = function() {
		
		that.myDom.find('#close').on('click',that.closeButtonClicked);
	};
	this.closeButtonClicked = function(){
	//	 {"closeButtonCall": that.fetchRoomList, "initialRoomType": that.initialRoomType, "reservationId": that.reservation_id};
		var reloadRoomAssignmentFilter = that.params.closeButtonCall;
		reloadRoomAssignmentFilter(that.params.initialRoomType, true);
		that.hide();
	};
	
	
};