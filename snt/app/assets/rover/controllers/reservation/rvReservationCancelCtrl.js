	sntRover.controller('RVCancelReservation', ['$rootScope', '$scope', '$stateParams', 'RVPaymentSrv', '$timeout', 'RVReservationCardSrv', '$state', '$filter',
		function($rootScope, $scope, $stateParams, RVPaymentSrv, $timeout, RVReservationCardSrv, $state, $filter) {

			BaseCtrl.call(this, $scope);
			$scope.errorMessage = '';
			$scope.showCancelCardSelection =true;
			$scope.showAddtoGuestCard = true;
			$scope.addmode = false;
			$scope.showCC = false;
			$scope.referanceText = "";
			$scope.isDisplayReference = false;
			$scope.newCardAdded = false;

			$scope.cancellationData = {
				selectedCard: -1,
				reason: "",
				viewCardsList: false,
				existingCard: false,
				cardId: "",
				cardNumber:"",
				expiry_date:"",
				card_type:"",
				addToGuestCard : false
			};

			$scope.cancellationData.paymentType = "";


			$scope.ngDialogData.penalty = $filter("number")($scope.ngDialogData.penalty,2);
			if($scope.ngDialogData.penalty > 0){
				$scope.$emit("UPDATE_CANCEL_RESERVATION_PENALTY_FLAG", true);
			};

			$scope.setScroller('cardsList');

			var checkReferencetextAvailableForCC = function(){
				if($scope.cancellationData.paymentType !=="CC"){

					angular.forEach($scope.passData.details.paymentTypes, function(value, key) {
						
						if(value.name == $scope.cancellationData.paymentType){
							$scope.isDisplayReference = (value.is_display_reference)? true:false;

							// To handle fees details on reservation cancel,
							// While we change payment methods
							// Handling Credit Cards seperately.
							if(value.name != "CC"){
								$scope.feeData.feesInfo = value.charge_code.fees_information;
							}
							$scope.setupFeeData();
						}
					});			
				}
				else
				{
					angular.forEach($scope.passData.details.creditCardTypes, function(value, key) {
						if($scope.cancellationData.card_type.toUpperCase() === value.cardcode){
							$scope.isDisplayReference = (value.is_display_reference)? true:false;
						};					
					});		
				}
			};

			


			$scope.changeOnsiteCallIn = function(){
				$scope.isManual ? $scope.showCC = true : "";
			};


			$scope.showHideCreditCard = function(){
				if($scope.cancellationData.paymentType ==="CC"){
					($rootScope.paymentGateway === 'sixpayments')  ? "": $scope.showCC = true;
				}
				else{
					checkReferencetextAvailableForCC();
				};
			};

			$scope.feeData = {};
			var zeroAmount = parseFloat("0.00");

			// CICO-11591 : To show or hide fees calculation details.
			$scope.isShowFees = function(){
				var isShowFees = false;
				var feesData = $scope.feeData;
				if(typeof feesData == 'undefined' || typeof feesData.feesInfo == 'undefined' || feesData.feesInfo == null){
					isShowFees = false;
				}
				else if((feesData.defaultAmount  >= feesData.minFees) && $scope.isStandAlone && feesData.feesInfo.amount){
					isShowFees = true;
				}
				return isShowFees;
			};
	

			// CICO-9457 : To calculate fee - for standalone only
			$scope.calculateFee = function() {

				if ($scope.isStandAlone) {
					var feesInfo = $scope.feeData.feesInfo;
					var amountSymbol = "";
					var feePercent  = zeroAmount;
					var minFees = zeroAmount;

					if (typeof feesInfo != 'undefined' && feesInfo != null){
						amountSymbol = feesInfo.amount_symbol;
						feePercent  = feesInfo.amount ? parseFloat(feesInfo.amount) : zeroAmount;
						minFees = feesInfo.minimum_amount_for_fees ? parseFloat(feesInfo.minimum_amount_for_fees) : zeroAmount;
					}
					var totalAmount = ($scope.ngDialogData.penalty == "") ? zeroAmount :
					parseFloat($scope.ngDialogData.penalty);

					$scope.feeData.minFees = minFees;
					$scope.feeData.defaultAmount = totalAmount;

					if($scope.isShowFees()){
						if (amountSymbol == "percent") {
							var calculatedFee = parseFloat(totalAmount * (feePercent / 100));
							$scope.feeData.calculatedFee = parseFloat(calculatedFee).toFixed(2);
							$scope.feeData.totalOfValueAndFee = parseFloat(calculatedFee + totalAmount).toFixed(2);
						}
						else {
							$scope.feeData.calculatedFee = parseFloat(feePercent).toFixed(2);
							$scope.feeData.totalOfValueAndFee = parseFloat(totalAmount + feePercent).toFixed(2);
						}
					}
				}
			};

			// CICO-9457 : Data for fees details.
			$scope.setupFeeData = function(){

				var feesInfo = $scope.feeData.feesInfo ? $scope.feeData.feesInfo : {};
				var defaultAmount = $scope.ngDialogData ?
				parseFloat($scope.ngDialogData.penalty) : zeroAmount;

				var minFees = feesInfo.minimum_amount_for_fees ? parseFloat(feesInfo.minimum_amount_for_fees) : zeroAmount;
				$scope.feeData.minFees = minFees;
				$scope.feeData.defaultAmount = defaultAmount;

				if($scope.isShowFees()){
					if(typeof feesInfo.amount != 'undefined' && feesInfo!= null){

						var amountSymbol = feesInfo.amount_symbol;
						var feesAmount = feesInfo.amount ? parseFloat(feesInfo.amount) : zeroAmount;
						$scope.feeData.actualFees = feesAmount;

						if(amountSymbol == "percent") $scope.calculateFee();
						else{
							$scope.feeData.calculatedFee = parseFloat(feesAmount).toFixed(2);
							$scope.feeData.totalOfValueAndFee = parseFloat(feesAmount + defaultAmount).toFixed(2);
						}
					}
				}
			};

	// CICO-12408 : To calculate Total of fees and amount to pay.
	$scope.calculateTotalAmount = function(amount) {
		
		var feesAmount  = (typeof $scope.feeData.calculatedFee == 'undefined' || $scope.feeData.calculatedFee == '' || $scope.feeData.calculatedFee == '-') ? zeroAmount : parseFloat($scope.feeData.calculatedFee);
		var amountToPay = (typeof amount == 'undefined' || amount =='') ? zeroAmount : parseFloat(amount);
		
		$scope.feeData.totalOfValueAndFee = parseFloat(amountToPay + feesAmount).toFixed(2);
	};

	var refreshCardsList = function() {
		$timeout(function() {
			$scope.refreshScroller('cardsList');
		}, 2000);
	};

	var retrieveCardtype = function(){
		var cardType = $scope.newPaymentInfo.tokenDetails.isSixPayment?
		getSixCreditCardType($scope.newPaymentInfo.tokenDetails.card_type).toLowerCase():
		getCreditCardType($scope.newPaymentInfo.cardDetails.cardType).toLowerCase();
		return cardType;
	};

	var retrieveCardNumber = function(){
		var cardNumber = $scope.newPaymentInfo.tokenDetails.isSixPayment?
		$scope.newPaymentInfo.tokenDetails.token_no.substr($scope.newPaymentInfo.tokenDetails.token_no.length - 4):
		$scope.newPaymentInfo.cardDetails.cardNumber.slice(-4);
		return cardNumber;
	};

	var retrieveExpiryDate = function(){
		var expiryMonth =  $scope.newPaymentInfo.tokenDetails.isSixPayment ? $scope.newPaymentInfo.tokenDetails.expiry.substring(2, 4) :$scope.newPaymentInfo.cardDetails.expiryMonth;
		var expiryYear  =  $scope.newPaymentInfo.tokenDetails.isSixPayment ? $scope.newPaymentInfo.tokenDetails.expiry.substring(0, 2) :$scope.newPaymentInfo.cardDetails.expiryYear;
		var expiryDate = expiryMonth+" / "+expiryYear;
		return expiryDate;
	};

	var retrieveName = function(){
		var cardName = $scope.newPaymentInfo.tokenDetails.isSixPayment?
		'':$scope.newPaymentInfo.cardDetails.userName;
		return cardName;
	};


	var savePayment = function() {

		var expiryMonth = $scope.newPaymentInfo.tokenDetails.isSixPayment ? $scope.newPaymentInfo.tokenDetails.expiry.substring(2, 4) :$scope.newPaymentInfo.cardDetails.expiryMonth;
		var expiryYear  = $scope.newPaymentInfo.tokenDetails.isSixPayment ? $scope.newPaymentInfo.tokenDetails.expiry.substring(0, 2) :$scope.newPaymentInfo.cardDetails.expiryYear;
		var cardExpiry  = (expiryMonth && expiryYear )? ("20"+expiryYear+"-"+expiryMonth+"-01"):"";

		var cardToken = !$scope.newPaymentInfo.tokenDetails.isSixPayment ? $scope.newPaymentInfo.tokenDetails.session:$scope.newPaymentInfo.tokenDetails.token_no;	
		var onSaveSuccess = function(data) {
			$scope.$emit('hideLoader');
			$scope.cancellationData.selectedCard = data.id;
			$scope.cancellationData.cardNumber = retrieveCardNumber();
			$scope.cancellationData.expiry_date = retrieveExpiryDate();
			$scope.cancellationData.card_type = retrieveCardtype();
			checkReferencetextAvailableForCC();
			$scope.showCC = false;
			$scope.newCardAdded = true;
		};
		var paymentData = {
			add_to_guest_card: $scope.newPaymentInfo.cardDetails.addToGuestCard,
			name_on_card: retrieveName(),
			payment_type: "CC",
			reservation_id: $scope.passData.reservationId,
			token: cardToken
		};
		paymentData.card_code = $scope.newPaymentInfo.tokenDetails.isSixPayment?
								getSixCreditCardType($scope.newPaymentInfo.tokenDetails.card_type).toLowerCase():
								$scope.newPaymentInfo.cardDetails.cardType;
		if(!$scope.newPaymentInfo.tokenDetails.isSixPayment){
			paymentData.card_expiry = cardExpiry;
		};
		
		$scope.invokeApi(RVPaymentSrv.savePaymentDetails, paymentData, onSaveSuccess);
	};

	var onFetchPaymentsSuccess = function(data) {
		$scope.$emit('hideLoader');
		
		$scope.cardsList = _.where(data.existing_payments, {
			is_credit_card: true
		});
		
		$scope.cardsList.forEach(function(card) {
			card.mli_token = card.ending_with;
			delete card.ending_with;    
			card.card_expiry = card.expiry_date;
			delete card.expiry_date; 
		});
		$scope.addmode = $scope.cardsList.length>0 ? false :true;
		refreshCardsList();
		$scope.ngDialogData.state = 'PENALTY';
	};


	var cancelReservation = function() {
		var onCancelSuccess = function(data) {
			$state.go('rover.reservation.staycard.reservationcard.reservationdetails', {
				"id": $scope.reservationData.reservationId || $scope.reservationParentData.reservationId,
				"confirmationId": $scope.reservationData.confirmNum ||  $scope.reservationParentData.confirmNum,
				"isrefresh": false
			});
			$scope.closeReservationCancelModal();
			$scope.$emit('hideLoader');
		};
		var onCancelFailure = function(data) {
			$scope.$emit('hideLoader');
			$scope.errorMessage = data;
		};
		var cancellationParameters = {
			reason: $scope.cancellationData.reason,
			payment_method_id: parseInt($scope.cancellationData.selectedCard) == -1 ? null : parseInt($scope.cancellationData.selectedCard),
			id: $scope.reservationData.reservationId || $scope.reservationParentData.reservationId || $scope.passData.reservationId
		};
		if($scope.ngDialogData.isDisplayReference){
			cancellationParameters.reference_text = $scope.referanceText;
		};
		$scope.invokeApi(RVReservationCardSrv.cancelReservation, cancellationParameters, onCancelSuccess, onCancelFailure);
	};

	var successPayment = function(data){
		$scope.$emit('hideLoader');
		if($scope.cancellationData.addToGuestCard){
			var cardCode = $scope.cancellationData.card_type;
			var cardNumber = $scope.cancellationData.cardNumber;
			var dataToGuestList = {
				"card_code": cardCode,
				"mli_token": cardNumber,
				"card_expiry": $scope.cancellationData.expiry_date,
				"card_name": $scope.newPaymentInfo.cardDetails.userName,
				"id": data.id,
				"isSelected": true,
				"is_primary":false,
				"payment_type":"CC",
				"payment_type_id": 1
			};
			$scope.cardsList.push(dataToGuestList);
			$rootScope.$broadcast('ADDEDNEWPAYMENTTOGUEST', dataToGuestList);
		}
		$scope.depositPaidSuccesFully = true;
		$scope.authorizedCode = data.authorization_code;
		
	};

	$scope.cancelReservation = function(){
		cancelReservation();
	};
	/*
	* Action - On click submit payment button
	*/
	$scope.submitPayment = function(){


		$scope.errorMessage = "";
		$scope.depositInProcess = true;	
		var dataToSrv = {
			"postData": {
				"bill_number": 1,
				"payment_type": $scope.cancellationData.paymentType,
				"amount": $scope.ngDialogData.penalty,
				"payment_type_id":($scope.cancellationData.paymentType === 'CC' && $scope.cancellationData.selectedCard !== -1) ? $scope.cancellationData.selectedCard :null
			},
			"reservation_id":$scope.passData.reservationId
		};
		if($scope.isShowFees()){
			if($scope.feeData.calculatedFee)
				dataToSrv.postData.fees_amount = $scope.feeData.calculatedFee;
			if($scope.feeData.feesInfo)
				dataToSrv.postData.fees_charge_code_id = $scope.feeData.feesInfo.charge_code_id;
		}
		// add to guest card only if new card is added and checkbox is selected
		if($scope.newCardAdded){
			dataToSrv.postData.add_to_guest_card =  $scope.cancellationData.addToGuestCard;
		}
		else{
			dataToSrv.postData.add_to_guest_card =  false;
		};
		if($scope.isDisplayReference){
			dataToSrv.postData.reference_text = $scope.referanceText;
		};
		if($rootScope.paymentGateway == "sixpayments" && !$scope.isManual && $scope.cancellationData.paymentType === 'CC'){
			dataToSrv.postData.is_emv_request = true;
			$scope.shouldShowWaiting = true;
			RVPaymentSrv.submitPaymentOnBill(dataToSrv).then(function(response) {
				$scope.shouldShowWaiting = false;
				successPayment(response);
			},function(error){
				$scope.errorMessage = error;
				$scope.shouldShowWaiting = false;
			});
			
		} else {
			$scope.invokeApi(RVPaymentSrv.submitPaymentOnBill, dataToSrv, successPayment);
		}
		//$scope.invokeApi(RVPaymentSrv.submitPaymentOnBill, dataToSrv,successPayment);
	};

	$scope.applyPenalty = function() {
		var reservationId = $scope.passData.reservationId;
		$scope.ngDialogData.applyPenalty = true;
	    $scope.invokeApi(RVPaymentSrv.getPaymentList, reservationId, onFetchPaymentsSuccess);
	
	};

	$scope.onCardClick = function(){
		$scope.showCC = true;
		$scope.addmode = $scope.cardsList.length>0 ?false:true;
	};
	var setCreditCardFromList = function(index){
		$scope.cancellationData.selectedCard = $scope.cardsList[index].value;
		$scope.cancellationData.cardNumber = $scope.cardsList[index].mli_token;
		$scope.cancellationData.expiry_date = $scope.cardsList[index].card_expiry;
		$scope.cancellationData.card_type = $scope.cardsList[index].card_code;
		checkReferencetextAvailableForCC();
		$scope.showCC = false;
	// CICO-9457 : Data for fees details - standalone only.	
	if($scope.isStandAlone)	{
		$scope.feeData.feesInfo = $scope.cardsList[index].fees_information;
		$scope.setupFeeData();
	}
	$scope.newCardAdded = false;
	};

	$scope.$on("TOKEN_CREATED", function(e,data){
		$scope.newPaymentInfo = data;
		$scope.showCC = false;
		savePayment();
	});

	$scope.$on("MLI_ERROR", function(e,data){
		$scope.errorMessage = data;
	});

	$scope.$on('cancelCardSelection',function(e,data){
		$scope.showCC = false;
		$scope.cancellationData.paymentType = "";
		$scope.isManual = false;
	});

	$scope.$on('cardSelected',function(e,data){
		setCreditCardFromList(data.index);
	});

	$scope.$on("SHOW_SWIPED_DATA_ON_CANCEL_RESERVATION_PENALTY_SCREEN", function(e, swipedCardDataToRender){

		$scope.$broadcast("RENDER_SWIPED_DATA", swipedCardDataToRender);
		$scope.ngDialogData.state = 'PENALTY';
		$scope.showCC = true;
		$scope.addmode = true;

	});

	var successSwipePayment = function(data, successParams){
		$scope.$emit('hideLoader');
		$scope.cancellationData.selectedCard = data.id;
		$scope.cancellationData.cardNumber = successParams.cardNumber.slice(-4);;
		$scope.cancellationData.expiry_date = successParams.cardExpiryMonth+"/"+successParams.cardExpiryYear;
		$scope.cancellationData.card_type = successParams.cardType.toLowerCase();
		$scope.showCC = false;
	};
	$scope.$on("SWIPED_DATA_TO_SAVE", function(e, swipedCardDataToSave){
		var data 				 = swipedCardDataToSave;
		data.reservation_id 	 = $scope.reservationData.reservation_card.reservation_id;
		data.payment_credit_type = swipedCardDataToSave.cardType;
		data.credit_card 		 = swipedCardDataToSave.cardType;
		data.card_expiry 		 = "20"+swipedCardDataToSave.cardExpiryYear+"-"+swipedCardDataToSave.cardExpiryMonth+"-01";
		data.add_to_guest_card   = swipedCardDataToSave.addToGuestCard;


		var options = {
			params: 			data,
			successCallBack: 	successSwipePayment,	 
			successCallBackParameters:  swipedCardDataToSave 	
		};
		$scope.callAPI(RVPaymentSrv.savePaymentDetails, options);
	});
	$scope.closeReservationCancelModal = function(){
		$scope.$emit("UPDATE_CANCEL_RESERVATION_PENALTY_FLAG", false);
		$scope.closeDialog();
	};

	}]);
