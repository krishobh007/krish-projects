sntRover.controller('reservationRoomStatus',[ '$state','$rootScope','$scope','ngDialog', 'RVKeyPopupSrv',  function($state, $rootScope, $scope, ngDialog, RVKeyPopupSrv){
	BaseCtrl.call(this, $scope);
	$scope.encoderTypes = [];
	$scope.getRoomClass = function(reservationStatus){
		var reservationRoomClass = '';
		if(reservationStatus == 'CANCELED'){
			reservationRoomClass ='overlay';
		}
		else if( !$rootScope.isStandAlone && reservationStatus != 'NOSHOW' && reservationStatus != 'CHECKEDOUT' && reservationStatus != 'CANCELED' && reservationStatus != 'CHECKEDIN' && reservationStatus != 'CHECKING_OUT'){
			reservationRoomClass = 'has-arrow hover-hand';
		}
		else if($rootScope.isStandAlone && reservationStatus != 'NOSHOW' && reservationStatus != 'CHECKEDOUT' && reservationStatus != 'CANCELED'){
			reservationRoomClass = 'has-arrow hover-hand';
		}
		return reservationRoomClass;
	};
	
	$scope.getRoomStatusClass = function(reservationStatus, roomStatus, foStatus, roomReadyStatus, checkinInspectedOnly){
		
		var reservationRoomStatusClass = "";
		if(reservationStatus == 'CHECKING_IN'){
			
			if(roomReadyStatus!=''){
				if(foStatus == 'VACANT'){
					switch(roomReadyStatus) {

						case "INSPECTED":
							reservationRoomStatusClass = ' room-green';
							break;
						case "CLEAN":
							if (checkinInspectedOnly == "true") {
								reservationRoomStatusClass = ' room-orange';
								break;
							} else {
								reservationRoomStatusClass = ' room-green';
								break;
							}
							break;
						case "PICKUP":
							reservationRoomStatusClass = " room-orange";
							break;
			
						case "DIRTY":
							reservationRoomStatusClass = " room-red";
							break;

		        }
				
				} else {
					reservationRoomStatusClass = "room-red";
				}
				
			}
		} 
		return reservationRoomStatusClass;
	};
	
	$scope.showUpgradeButton = function(reservationStatus,  isUpsellAvailable){
		var showUpgrade = false;
		if((isUpsellAvailable == 'true') && $scope.isFutureReservation(reservationStatus)){
			showUpgrade = true;
		}
		return showUpgrade;
	};
	$scope.isFutureReservation = function(reservationStatus){
		return (reservationStatus == 'RESERVED' || reservationStatus == 'CHECKING_IN');
	};
	$scope.showKeysButton = function(reservationStatus){
		var showKey = false;
		if((reservationStatus == 'CHECKING_IN' && $scope.reservationData.reservation_card.room_number != '')|| reservationStatus == 'CHECKING_OUT' || reservationStatus == 'CHECKEDIN'){
			showKey = true;
		}
		return showKey;
	};
	$scope.addHasButtonClass = function(reservationStatus,  isUpsellAvailable){
		var hasButton = "";
		if($scope.showKeysButton(reservationStatus) && $scope.showUpgradeButton(reservationStatus,  isUpsellAvailable)){
			hasButton = "has-buttons";
		}
		else if($scope.showKeysButton(reservationStatus) || $scope.showUpgradeButton(reservationStatus,  isUpsellAvailable)){
			hasButton = "has-button";
		}
		return hasButton;
	};
	
	// To handle click of key icon.
	$scope.clickedIconKey = function(event){
		event.stopPropagation();
		var keySettings = $scope.reservationData.reservation_card.key_settings;
		$scope.viewFromBillScreen = false;
		if(keySettings === "email"){
			
			ngDialog.open({
				 template: '/assets/partials/keys/rvKeyEmailPopup.html',
				 controller: 'RVKeyEmailPopupController',
				 className: '',
				 scope: $scope
			});
		}
		else if(keySettings === "qr_code_tablet"){

			//Fetch and show the QR code in a popup
			var	reservationId = $scope.reservationData.reservation_card.reservation_id;

			var successCallback = function(data){
				$scope.$emit('hideLoader');
				$scope.data = data;
				ngDialog.open({
					 template: '/assets/partials/keys/rvKeyQrcodePopup.html',
					 controller: 'RVKeyQRCodePopupController',
					 className: '',
					 scope: $scope
				});	
			}

			$scope.invokeApi(RVKeyPopupSrv.fetchKeyQRCodeData,{ "reservationId": reservationId }, successCallback);  

			
			
		}
		
		//Display the key encoder popup
		else if(keySettings === "encode"){
			if($scope.reservationData.reservation_card.hotel_selected_key_system == 'SAFLOK_MSR' && $scope.encoderTypes !== undefined && $scope.encoderTypes.length <= 0){
				fetchEncoderTypes();
			} else {
				openKeyEncodePopup();
			}
		}
	};

	var openKeyEncodePopup = function(){
		ngDialog.open({
		    template: '/assets/partials/keys/rvKeyEncodePopup.html',
		    controller: 'RVKeyEncodePopupCtrl',
		    className: '',
		    scope: $scope
		});
	}

	//Fetch encoder types for SAFLOK_MSR
	var fetchEncoderTypes = function(){

		var encoderFetchSuccess = function(data){
			$scope.$emit('hideLoader');
			$scope.encoderTypes = data;

			openKeyEncodePopup();
		};

	    $scope.invokeApi(RVKeyPopupSrv.fetchActiveEncoders, {}, encoderFetchSuccess);
	};
	
	/**
	* function for close activity indicator.
	*/
	$scope.closeActivityIndication = function(){
		$scope.$emit('hideLoader');
	};
	/**
	* function to trigger room assignment.
	*/
	$scope.goToroomAssignment = function(){
		if($scope.reservationData.reservation_card.is_hourly_reservation){
			$state.go('rover.diary', { reservation_id: $scope.reservationData.reservation_card.reservation_id });
		} else if($scope.isFutureReservation($scope.reservationData.reservation_card.reservation_status)){
			$state.go("rover.reservation.staycard.roomassignment", {reservation_id:$scope.reservationData.reservation_card.reservation_id, room_type:$scope.reservationData.reservation_card.room_type_code, "clickedButton": "roomButton"});
		}
		
	};

	
}]);