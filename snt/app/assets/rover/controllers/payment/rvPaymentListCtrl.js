sntRover.controller('RVShowPaymentListCtrl',['$rootScope', '$scope', '$state', 'RVPaymentSrv','ngDialog', function($rootScope, $scope, $state, RVPaymentSrv, ngDialog){
	BaseCtrl.call(this, $scope);
	$scope.showNoValues = false;
	$scope.paymentListSuccess = function(data){
		$scope.$emit('hideLoader');
		$scope.paymentListData = data;
		
		//To remove non cc payments
		angular.forEach($scope.paymentListData.existing_payments, function(obj, index){
			if (!obj.is_credit_card) {
	 		 	$scope.paymentListData.existing_payments.splice(index, 1);
	  			return;
			};
		});

		$scope.paymentListLength = $scope.paymentListData.existing_payments.length;
		if($scope.paymentListLength == 0){
			$scope.showNoValues = true;
		}
	};

	// return false;
	var reservationId = "";
	if($scope.dataToPaymentList.currentView == "billCard"){
		reservationId = $scope.dataToPaymentList.reservation_id;
	} else {
		reservationId =  $scope.dataToPaymentList.reservation_card.reservation_id;
	}
	$scope.invokeApi(RVPaymentSrv.getPaymentList, reservationId, $scope.paymentListSuccess);  
	
	$scope.clickPaymentItem = function(paymentId, cardCode, cardNumberEndingWith, expiryDate){
		var data = {
			"reservation_id":	reservationId,
			"user_payment_type_id":	paymentId
		};
		if($scope.dataToPaymentList.currentView == "billCard"){
			data.bill_number = $scope.dataToPaymentList.bills[$scope.dataToPaymentList.currentActiveBill].bill_number;
		}

		
		
		var paymentMapFailure = function(errorMessage){
			$scope.$emit('hideLoader');
			$scope.errorMessage = errorMessage;
		};
		var paymentMapSuccess = function(){
			$scope.$emit('hideLoader');
			ngDialog.close();
			
			if($scope.dataToPaymentList.currentView == "billCard"){
				var billIndex = $scope.dataToPaymentList.currentActiveBill;
				$scope.dataToPaymentList.bills[billIndex].credit_card_details.card_code = cardCode.toLowerCase();
				$scope.dataToPaymentList.bills[billIndex].credit_card_details.card_number = cardNumberEndingWith;
				$scope.dataToPaymentList.bills[billIndex].credit_card_details.card_expiry = expiryDate;
				// CICO-9739 : To update on reservation card payment section while updating from bill#1 credit card type.
				if(billIndex === 0){
					$rootScope.$emit('UPDATEDPAYMENTLIST', $scope.dataToPaymentList.bills[billIndex].credit_card_details );
				}
			} else {
				$scope.dataToPaymentList.reservation_card.payment_details.card_type_image = cardCode.toLowerCase()+".png";
				$scope.dataToPaymentList.reservation_card.payment_details.card_number = cardNumberEndingWith;
				$scope.dataToPaymentList.reservation_card.payment_details.card_expiry = expiryDate;
				$scope.dataToPaymentList.reservation_card.payment_method_used = "CC";
				$scope.dataToPaymentList.reservation_card.payment_method_description = "Credit Card";
			}
		};
		$scope.invokeApi(RVPaymentSrv.mapPaymentToReservation, data, paymentMapSuccess, paymentMapFailure);  
	};
	
	
	
	$scope.$parent.myScrollOptions = {		
	    'paymentList': {
	    	scrollbars: true,
	        snap: false,
	        hideScrollbar: false,
	        preventDefault: false
	    }
	};

	
	
	$scope.$on('$viewContentLoaded', function() {
		setTimeout(function(){
			$scope.$parent.myScroll['paymentList'].refresh();
			}, 
		3000);
		
     });
	
}]);