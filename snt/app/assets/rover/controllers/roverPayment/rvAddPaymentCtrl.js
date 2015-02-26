sntRover.controller('RVPaymentAddPaymentCtrl',
	['$rootScope', 
	 '$scope', 
	 '$state', 
	 'ngDialog',
	 'RVPaymentSrv','$timeout',
	function($rootScope, $scope, $state, ngDialog, RVPaymentSrv,$timeout){

   //save/select card actions
        // +-----------------+-------------------------------+
        // |                      save                       |
        // |                       +                         |
        // |                       |                         |
        // |          add new  <---+----> existing cc        |
        // |            +                                    |
        // |            |                                    |
        // |     CC <---+--->Other                           |
        // |												 |	
         // +-------------------------------------------------+
       


	BaseCtrl.call(this, $scope);
	$scope.shouldShowWaiting = false;
	$scope.addmode         = true;
	$scope.savePayment     = {};
	$scope.isFromGuestCard = (typeof $scope.passData.isFromGuestCard !== "undefined" && $scope.passData.isFromGuestCard) ? true:false;
	$scope.isNewCardAdded  = false;
	$scope.isManual        = false;
	$scope.dataToSave      = {};
	$scope.cardsList       = [];
	$scope.setScroller('cardsList');
	$scope.showCCPage = false;
	
	if(!isEmptyObject($scope.passData.details.swipedDataToRenderInScreen)){
		$scope.showManualEntryDisabledPopup = false;
		$scope.showCCPage = true;
	}
	else{
		$scope.showManualEntryDisabledPopup = ($rootScope.isManualCCEntryEnabled) ? false : true;
	};
	
    var refreshCardsList = function() {
        $timeout(function() {
			$scope.refreshScroller('cardsList');
		}, 2000);
    };

    refreshCardsList();

	$scope.successRender = function(data){
		$scope.$emit("hideLoader");
		$scope.renderData = data;
		$scope.creditCardTypes = [];
		angular.forEach($scope.renderData, function(item, key) {
			if(item.name === 'CC'){
				$scope.creditCardTypes = item.values;
			};					
		});	
		setTimeout(function(){
			if(!isEmptyObject($scope.passData.details.swipedDataToRenderInScreen)){
				$scope.dataToSave.paymentType = "CC";
			}
		}, 2000);
		
	};
	$scope.invokeApi(RVPaymentSrv.renderPaymentScreen, {}, $scope.successRender);

	$scope.successPaymentList = function(data){
		$scope.$emit("hideLoader");
		//for accompany guest dont show existing cards for add payment type in bill screen CICO-9719
		$scope.hasAccompanyguest = data.has_accompanying_guests && (typeof $scope.passData.fromBill !== "undefined");
		
		if($scope.hasAccompanyguest){
			$scope.cardsList = [];
		}
		else{
			//To remove non cc payments
			angular.forEach(data.existing_payments, function(obj, index){
				if (obj.is_credit_card) {
		 		 	$scope.cardsList.push(obj);
				};
			});
			
		};
		
		angular.forEach($scope.cardsList, function(value, key) {
			
			value.mli_token = value.ending_with; //For common payment HTML to work - Payment modifications story
			value.card_expiry = value.expiry_date;//Same comment above
		});

		$scope.addmode = $scope.cardsList.length > 0 ? false:true;
		
		//To render swiped data in the add screen
		if(!isEmptyObject($scope.passData.details.swipedDataToRenderInScreen)){
			$scope.showManualEntryDisabledPopup = false;
			$scope.dataToSave.paymentType = "CC";
			$scope.showCCPage 			  = true;
			$scope.addmode                = true;	
			$scope.showAddtoGuestCard = ($scope.passData.details.swipedDataToRenderInScreen.swipeFrom == "guestCard") ? false : true;
		}
		refreshCardsList();
	};
	//NO need to show existing cards in guest card model
	if(!$scope.isFromGuestCard){
		$scope.showAddtoGuestCard = true;
		$scope.invokeApi(RVPaymentSrv.getPaymentList, $scope.passData.reservationId, $scope.successPaymentList);
	}
	else{		
		$scope.showAddtoGuestCard = false;
	};
	
	/*
	 * change payment type action - initial add payment screen
	 */
	$scope.changePaymentType = function(){

		if($scope.paymentGateway !== 'sixpayments'){
			$scope.showCCPage = ($scope.dataToSave.paymentType == "CC") ? true: false;
			$scope.addmode =($scope.dataToSave.paymentType == "CC" &&  $scope.cardsList.length === 0) ? true: false;
			$scope.showInitialScreen = ($scope.dataToSave.paymentType == "CC") ? false: true;
			refreshCardsList();
		}else{
			$scope.isNewCardAdded = ($scope.dataToSave.paymentType == "CC" && !$scope.isManual) ? true : false;
			return;
		};

		refreshCardsList();
	};

	$scope.changeOnsiteCallIn = function(){		
		$scope.showCCPage = ($scope.isManual) ? true:false;
		$scope.addmode =  ($scope.isManual && $scope.cardsList.length === 0) ? true:false;
		$scope.showInitialScreen = ($scope.isManual) ?false :true;
		//to enable add to guest card
		$scope.isNewCardAdded = ($scope.dataToSave.paymentType == "CC" && !$scope.isManual) ? true : false;
		refreshCardsList();
	};


	$scope.showCCList = function(){
		refreshCardsList();
		$scope.showCCPage =  true;
		$scope.addmode = false;
	};

    //retrieve card type based on paymnet gateway
	var retrieveCardtype = function(){
		var cardType = $scope.cardData.tokenDetails.isSixPayment?
					getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase():
					getCreditCardType($scope.cardData.tokenDetails.cardBrand).toLowerCase()
					;
		return cardType;
	};

	//retrieve card expiry based on paymnet gateway
	var retrieveExpiryDate = function(){

		var expiryDate = $scope.cardData.tokenDetails.isSixPayment?
					$scope.cardData.tokenDetails.expiry.substring(2, 4)+" / "+$scope.cardData.tokenDetails.expiry.substring(0, 2):
					$scope.cardData.cardDetails.expiryMonth+" / "+$scope.cardData.cardDetails.expiryYear
					;
		return expiryDate;
	};

	//retrieve card number based on paymnet gateway
	var retrieveCardNumber = function(){
		var cardNumber = $scope.cardData.tokenDetails.isSixPayment?
				$scope.cardData.tokenDetails.token_no.substr($scope.cardData.tokenDetails.token_no.length - 4):
				$scope.cardData.cardDetails.cardNumber.slice(-4);
		return cardNumber;
	};

	var retrieveCardName = function(){
		var cardName = (!$scope.cardData.tokenDetails.isSixPayment)?
							$scope.cardData.cardDetails.userName:
							($scope.passData.details.firstName+" "+$scope.passData.details.lastName);
		return cardName;
	};

	var retrieveCardExpiryForApi =  function(){
		var expiryMonth = $scope.cardData.tokenDetails.isSixPayment ? $scope.cardData.tokenDetails.expiry.substring(2, 4) :$scope.cardData.cardDetails.expiryMonth;
		var expiryYear  = $scope.cardData.tokenDetails.isSixPayment ? $scope.cardData.tokenDetails.expiry.substring(0, 2) :$scope.cardData.cardDetails.expiryYear;
		var expiryDate  = (expiryMonth && expiryYear )? ("20"+expiryYear+"-"+expiryMonth+"-01"):"";
		return expiryDate;
	};

	var renderScreen = function(){
		$scope.showCCPage = false;
		$scope.showSelectedCreditCard  = true;
		$scope.addmode                 = false;			
		$scope.renderData.creditCardType = (!$scope.cardData.tokenDetails.isSixPayment)?
										getCreditCardType($scope.cardData.cardDetails.cardType).toLowerCase() : 
										getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase();
		$scope.renderData.cardExpiry = retrieveExpiryDate();
		$scope.renderData.endingWith = retrieveCardNumber();		
	};
	
	//retrieve token from paymnet gateway
	$scope.$on("TOKEN_CREATED", function(e, tokenDetails){
		$scope.cardData = tokenDetails;
		renderScreen();
		$scope.isNewCardAdded = true;
		
		$scope.showInitialScreen       = true; 
		$scope.$digest();
	});

	$scope.$on("MLI_ERROR", function(e,data){
		$scope.errorMessage = data;
	});


	var creditCardType = '';
	var billIndex = parseInt($scope.passData.fromBill);
	var billNumber = parseInt(billIndex) - parseInt(1);

	/*
	* Save CC and other common actions in bill screen
	*/
	
	var billScreenCommonActions = function(data){
		$scope.paymentData.bills[billNumber].credit_card_details.payment_type = $scope.dataToSave.paymentType;
		var dataToUpdate = {
			"balance": data.reservation_balance,
			"confirm_no" : $scope.paymentData.confirm_no 
		};
		// CICO-9739 : To update on reservation card payment section while updating from bill#1 credit card type.
		if(billNumber == 0){
			$rootScope.$emit('UPDATEDPAYMENTLIST', $scope.paymentData.bills[billNumber].credit_card_details );
		};
		$rootScope.$broadcast('BALANCECHANGED', dataToUpdate);	
	};

	/*
	* Save CC success in  bill screen
	*/
	var billScreenCCSaveActions = function(data){		
		$scope.paymentData.bills[billNumber].credit_card_details.card_code = creditCardType.toLowerCase();
		$scope.paymentData.bills[billNumber].credit_card_details.card_number = retrieveCardNumber();
		$scope.paymentData.bills[billNumber].credit_card_details.card_expiry = retrieveExpiryDate();
		billScreenCommonActions(data);
	};
   
	/*
	* Save other type success in bill screen
	*/

	var billScreenExistingCCSucess = function(data){
		$scope.paymentData.bills[billNumber].credit_card_details.card_code = $scope.renderData.creditCardType;
		$scope.paymentData.bills[billNumber].credit_card_details.card_number = $scope.renderData.endingWith;
		$scope.paymentData.bills[billNumber].credit_card_details.card_expiry = $scope.renderData.cardExpiry;
		billScreenCommonActions(data);
	};

	/*
	* Save CC success in staycard screen
	*/

	var saveNewCardSuccess = function(data){
		$scope.paymentData.reservation_card.payment_method_used = $scope.dataToSave.paymentType;
		$scope.paymentData.reservation_card.payment_details.card_type_image = creditCardType.toLowerCase()+".png";
		$scope.paymentData.reservation_card.payment_details.card_number = retrieveCardNumber();
		$scope.paymentData.reservation_card.payment_details.card_expiry = retrieveExpiryDate();	
	};
	
	/*
	* update CC success in staycard screen
	*/

	var existingCardSuccess = function(data){
		$scope.paymentData.reservation_card.payment_method_used = $scope.dataToSave.paymentType;
		$scope.paymentData.reservation_card.payment_details.card_type_image = $scope.renderData.creditCardType+".png";
		$scope.paymentData.reservation_card.payment_details.card_number = $scope.renderData.endingWith;
		$scope.paymentData.reservation_card.payment_details.card_expiry = $scope.renderData.cardExpiry;
	};

	var addToGuestCard = function(data){
		var cardCode = (!$scope.cardData.tokenDetails.isSixPayment)?
										getCreditCardType($scope.cardData.cardDetails.cardType).toLowerCase() : 
										getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase();;
		var cardNumber = retrieveCardNumber();
		var cardExpiry = retrieveExpiryDate();
		var dataToGuestList = {
			"card_code": cardCode,
			"mli_token": cardNumber,
			"card_expiry":cardExpiry,
			"card_name": retrieveCardName(),
			"id": data.id,
			"isSelected": true,
			"is_primary":false,
			"payment_type":"CC",
			"payment_type_id": 1
		};
		$scope.cardsList.push(dataToGuestList);
		$rootScope.$broadcast('ADDEDNEWPAYMENTTOGUEST', dataToGuestList);
	};

	var saveCCToGuestCardSuccess = function(data){
	    $scope.$emit("hideLoader");
	    addToGuestCard(data);
		$scope.closeDialog();	
	};

	var saveToGuestCardSuccess = function(data){
		$scope.$emit("hideLoader");
		$scope.closeDialog();
		var dataToGuestList = {};
		if($scope.isNewCardAdded){
			dataToGuestList = {
				"id": data.id,
				"isSelected": true,
				"is_primary":false,
				"payment_type":data.payment_name,
				"card_code": $scope.renderData.creditCardType.toLowerCase(),
				"card_name":retrieveCardName()
			};
		}
		else{
			dataToGuestList = {
				"id": data.id,
				"isSelected": true,
				"is_primary":false,
				"payment_type":data.payment_name
			};
		};
		
		$rootScope.$broadcast('ADDEDNEWPAYMENTTOGUEST', dataToGuestList);
	};

	var ccSaveSuccess = function(data){
		
		$scope.$emit("hideLoader");

		if($scope.isNewCardAdded){
			if($scope.dataToSave.addToGuestCard){
				addToGuestCard(data);
			};
			(typeof $scope.passData.fromBill == "undefined")?saveNewCardSuccess(data):billScreenCCSaveActions(data);
		}
		else{
			(typeof $scope.passData.fromBill == "undefined")?existingCardSuccess(data):billScreenExistingCCSucess(data);
		};
		
		$scope.closeDialog();	
	};

	var nonCCStayCardSuccess = function(data){
		$scope.$emit("hideLoader");
		$scope.paymentData.reservation_card.payment_method_used = $scope.dataToSave.paymentType;
		
		$scope.closeDialog();
	};
	/*
	* Save CC
	*/
	var saveNewCard = function(){
			var data = {
				"reservation_id":	$scope.passData.reservationId
			};
			// var data =  {
							// "add_to_guest_card": $scope.savePayment.addToGuest,
							// "reservation_id": $scope.passData.reservationId
					    // };	

			if($scope.isNewCardAdded){
				creditCardType =
								(!$scope.cardData.tokenDetails.isSixPayment)? 
								getCreditCardType($scope.cardData.cardDetails.cardType):
								getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase();
				data.token = 
								(!$scope.cardData.tokenDetails.isSixPayment)?
								$scope.cardData.tokenDetails.session :
								$scope.cardData.tokenDetails.token_no;
				data.add_to_guest_card = $scope.dataToSave.addToGuestCard;
				data.card_name = retrieveCardName();

			}
			else{
				creditCardType = $scope.renderData.creditCardType;
				data.user_payment_type_id = $scope.renderData.value;
			};
			data.payment_type = $scope.dataToSave.paymentType;
			if(typeof $scope.passData.fromBill !== "undefined"){
				data.bill_number = $scope.passData.fromBill;	
			};	
			if($scope.isFromGuestCard){
				data.add_to_guest_card = true;
				data.card_code =  (!$scope.cardData.tokenDetails.isSixPayment)?
									$scope.cardData.cardDetails.cardType: 
									getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase();
				data.user_id = $scope.passData.guest_id;
				data.card_expiry = 	retrieveCardExpiryForApi();
				$scope.invokeApi(RVPaymentSrv.saveGuestPaymentDetails, data,saveCCToGuestCardSuccess);
			}
			else{
				if($scope.isNewCardAdded){	
					data.card_expiry = 	retrieveCardExpiryForApi();
					data.card_code   = (!$scope.cardData.tokenDetails.isSixPayment)?
										$scope.cardData.cardDetails.cardType: 
										getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase();
					$scope.invokeApi(RVPaymentSrv.savePaymentDetails, data, ccSaveSuccess);
				} else {
					$scope.invokeApi(RVPaymentSrv.mapPaymentToReservation, data, ccSaveSuccess);  
					
				};
			};
			
	};

    var savePaymentSuccess = function(data){
    	$scope.$emit("hideLoader");
    	if(typeof $scope.passData.fromBill !== "undefined"){
     		$scope.paymentData.bills[billNumber].credit_card_details.payment_type = $scope.dataToSave.paymentType;
			$scope.paymentData.bills[billNumber].credit_card_details.payment_type_description = data.payment_type;
		}else{
			$scope.paymentData.reservation_card.payment_method_description = data.payment_type;
			$scope.paymentData.reservation_card.payment_method_used = $scope.dataToSave.paymentType;
		};
    	$scope.closeDialog();
    };
    /*
    * save non CC
    */
	var saveNewPayment = function(){
		var data =  {};
		data = {
				"add_to_guest_card": $scope.dataToSave.addToGuestCard,
				"reservation_id": $scope.passData.reservationId,
				"payment_type": $scope.dataToSave.paymentType
			   };
		if($scope.passData.fromBill){
			data.bill_number = $scope.passData.fromBill;	
		};			

		if($scope.isFromGuestCard){
			data.add_to_guest_card = true;
			data.user_id = $scope.passData.guest_id;
			$scope.invokeApi(RVPaymentSrv.saveGuestPaymentDetails, data,saveToGuestCardSuccess);
		}
		else{	
			$scope.invokeApi(RVPaymentSrv.savePaymentDetails, data,savePaymentSuccess);
		};
	};

	
	$scope.addNewPayment = function(){
		if(!$scope.isManual && $rootScope.paymentGateway == "sixpayments" && $scope.dataToSave.paymentType ==='CC'){
			sixPaymentSwipe();
		} else if(!isEmptyObject($scope.passData.details.swipedDataToRenderInScreen)){
			saveDataFromSwipe();
		} else if(typeof $scope.dataToSave !== "undefined")
		   ($scope.dataToSave.paymentType ==='CC') ? saveNewCard():saveNewPayment();
	};
	var sixPaymentSwipe = function(){
		
		var data = {};
		if(!$scope.isFromGuestCard){
			data.reservation_id = $scope.passData.reservationId;
			data.add_to_guest_card = $scope.dataToSave.addToGuestCard;
			data.guest_id = $scope.passData.userId;
		} else {
			data.add_to_guest_card = true;
			data.guest_id = $scope.passData.guest_id;
		}
		
		$scope.shouldShowWaiting = true;
		RVPaymentSrv.chipAndPinGetToken(data).then(function(response) {
			$scope.shouldShowWaiting = false;
			successSixSwipe(response);
		},function(error){
			$scope.errorMessage = error;
			$scope.shouldShowWaiting = false;
		});
// 		
		
		
		//$scope.invokeApi(RVPaymentSrv.chipAndPinGetToken, data, successSixSwipe);
	};
	var successSixSwipe = function(response){
		$scope.$emit("hideLoader");
		var cardType = getSixCreditCardType(response.card_type).toLowerCase();
		var endingWith = response.ending_with;
		var expiryDate = response.expiry_date.slice(-2)+"/"+response.expiry_date.substring(0, 2);
		if($scope.passData.fromBill == undefined){
			if(!$scope.isFromGuestCard){
				$scope.paymentData.reservation_card.payment_method_used = "CC";
				$scope.paymentData.reservation_card.payment_details.card_type_image = cardType+".png";
				$scope.paymentData.reservation_card.payment_details.card_number = endingWith;
				$scope.paymentData.reservation_card.payment_details.card_expiry = 	expiryDate;
			}
		} else {
			$scope.paymentData.bills[billNumber].credit_card_details.card_code = cardType;
			$scope.paymentData.bills[billNumber].credit_card_details.card_number = endingWith;
			$scope.paymentData.bills[billNumber].credit_card_details.card_expiry = expiryDate;	
		}
		if($scope.dataToSave.addToGuestCard || $scope.isFromGuestCard){
				var dataToGuestList = {
					"card_code": cardType,
					"mli_token": endingWith,
					"card_expiry": expiryDate,
					"card_name": "",
					"id": response.guest_payment_method_id,
					"isSelected": true,
					"is_primary":false,
					"payment_type":"CC",
					"payment_type_id": 1,
					"is_credit_card": true

				};
				$scope.cardsList.push(dataToGuestList);
				$rootScope.$broadcast('ADDEDNEWPAYMENTTOGUEST', dataToGuestList);
		};
		$scope.closeDialog();
		
	};
	var saveDataFromSwipe = function(){
		var data 			= $scope.swipedCardDataToSave;
		data.reservation_id =	$scope.passData.reservationId;
		
		data.payment_credit_type = $scope.swipedCardDataToSave.cardType;
		data.credit_card = $scope.swipedCardDataToSave.cardType;
		data.card_expiry = "20"+$scope.swipedCardDataToSave.cardExpiryYear+"-"+$scope.swipedCardDataToSave.cardExpiryMonth+"-01";
		//alert(JSON.stringify(data));
		if($scope.passData.details.isClickedCheckin != undefined && $scope.passData.details.isClickedCheckin){
			$scope.$emit("UPDATE_ADD_TO_GUEST_ON_CHECKIN_FLAG", $scope.dataToSave.addToGuestCard);
			successSwipePayment();
			
		} else if($scope.passData.details.swipedDataToRenderInScreen.swipeFrom == "guestCard")
		{
			data.user_id = $scope.passData.userId;
			$scope.invokeApi(RVPaymentSrv.saveGuestPaymentDetails, data, addToGuestCardOnSwipe);
		} else {
			$scope.invokeApi(RVPaymentSrv.savePaymentDetails, data, successSwipePayment);
		}
		
	};
	var successSwipePayment = function(data){
		$scope.$emit("hideLoader");
		if($scope.passData.fromBill == undefined){
			$scope.paymentData.reservation_card.payment_method_used = "CC";
			$scope.paymentData.reservation_card.payment_details.card_type_image = $scope.swipedCardDataToSave.cardType.toLowerCase()+".png";
			$scope.paymentData.reservation_card.payment_details.card_number = $scope.swipedCardDataToSave.cardNumber.slice(-4);
			$scope.paymentData.reservation_card.payment_details.card_expiry = $scope.swipedCardDataToSave.cardExpiryMonth+"/"+$scope.swipedCardDataToSave.cardExpiryYear;	
		} else {
			//CICO-13667 update the room charge button to green color if payment type is CC
			if($scope.paymentData.bills[billNumber].bill_number === '1'){
				$scope.paymentData.roomChargeEnabled = true;
			}
			$scope.paymentData.bills[billNumber].credit_card_details.card_code = $scope.swipedCardDataToSave.cardType.toLowerCase();
			$scope.paymentData.bills[billNumber].credit_card_details.card_number = $scope.swipedCardDataToSave.cardNumber.slice(-4);
			$scope.paymentData.bills[billNumber].credit_card_details.card_expiry = $scope.swipedCardDataToSave.cardExpiryMonth+"/"+$scope.swipedCardDataToSave.cardExpiryYear;
			$scope.paymentData.bills[billNumber].credit_card_details.payment_type = "CC";
		}
		if($scope.dataToSave.addToGuestCard){
				addToGuestCardOnSwipe(data);
		};
		$scope.closeDialog();
	};
	var addToGuestCardOnSwipe  = function(data){
		$scope.$emit("hideLoader");
		var dataToGuestList = {
			"card_code": $scope.swipedCardDataToSave.cardType.toLowerCase(),
			"mli_token": $scope.swipedCardDataToSave.cardNumber.slice(-4),
			"card_expiry":$scope.swipedCardDataToSave.cardExpiryMonth+"/"+$scope.swipedCardDataToSave.cardExpiryYear,
			"card_name": $scope.swipedCardDataToSave.nameOnCard,
			"id": (data !== undefined) ? data.id : "",
			"isSelected": true,
			"is_primary":false,
			"payment_type":"CC",
			"payment_type_id": 1,
			"is_credit_card": true
		};
		$scope.cardsList.push(dataToGuestList);
		$rootScope.$broadcast('ADDEDNEWPAYMENTTOGUEST', dataToGuestList);
	};

		/*
		*  card selection action
		*/
	var setCreditCardFromList = function(index){

		$scope.renderData.creditCardType =  $scope.cardsList[index].card_code.toLowerCase();
		$scope.renderData.cardExpiry = $scope.cardsList[index].card_expiry;
		$scope.renderData.endingWith = $scope.cardsList[index].mli_token;
		$scope.renderData.value = $scope.cardsList[index].value;
		$scope.showCCPage = false;
		$scope.showSelectedCreditCard  = true;
		$scope.addmode                 = false;	
		$scope.isNewCardAdded = false;
	};

	$scope.$on('cardSelected',function(e,data){
		$scope.showInitialScreen       = true;
		setCreditCardFromList(data.index);
	});
	$scope.$on("SWIPED_DATA_TO_SAVE", function(e, swipedCardDataToSave){
		$scope.swipedCardDataToSave = swipedCardDataToSave;
		$scope.dataToSave.paymentType = "CC";
		$scope.showCCPage = false;
		$scope.showSelectedCreditCard  = true;
		$scope.addmode                 = false;	
		$scope.renderData.creditCardType = swipedCardDataToSave.cardType.toLowerCase();
		$scope.renderData.cardExpiry = swipedCardDataToSave.cardExpiryMonth+"/"+swipedCardDataToSave.cardExpiryYear;
		$scope.renderData.endingWith = swipedCardDataToSave.cardNumber.slice(-4);
		if($scope.passData.details.swipedDataToRenderInScreen.swipeFrom != "guestCard"){
			$scope.isNewCardAdded = true;
		}
		
		$scope.showInitialScreen       = true; 
	});

	$scope.$on('cancelCardSelection',function(e,data){
		$scope.showCCPage = false;
		$scope.dataToSave.paymentType = "";
		$scope.isManual = false;
	});

	
}]);