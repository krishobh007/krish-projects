sntRover.controller('rvRouteDetailsCtrl',['$scope','$rootScope','$filter','RVBillinginfoSrv', 'RVGuestCardSrv', 'ngDialog', 'RVBillCardSrv', 'RVPaymentSrv', function($scope, $rootScope,$filter, RVBillinginfoSrv, RVGuestCardSrv, ngDialog, RVBillCardSrv, RVPaymentSrv){
	BaseCtrl.call(this, $scope);
	$scope.isAddPayment = false;
    $scope.chargeCodeToAdd = "";
    $scope.showPayment = false;
    $scope.first_bill_id = "";
    $scope.showChargeCodes = false;
    $scope.isBillingGroup = true;
    $scope.paymentDetails = null;
    $scope.swipedCardDataToSave = {};
    $scope.showCreditCardDropDown = false;
    $scope.isShownExistingCCPayment = false;
   
    if($scope.selectedEntity.credit_card_details.hasOwnProperty('payment_type_description')){
    	
        $scope.renderAddedPayment = $scope.selectedEntity.credit_card_details;
        $scope.renderAddedPayment.cardExpiry = $scope.selectedEntity.credit_card_details.card_expiry;
        $scope.renderAddedPayment.endingWith = $scope.selectedEntity.credit_card_details.card_number;
        $scope.renderAddedPayment.creditCardType = $scope.selectedEntity.credit_card_details.card_code;
        $scope.isAddPayment = true;
        $scope.showCreditCardDropDown = false;
        
        $scope.isShownExistingCCPayment = true;
        setTimeout(function(){
        	 $scope.$broadcast('UPDATE_FLAG');
        }, 1000);
       
        
    }

        //common payment model items
    $scope.passData = {};
    $scope.passData.details ={};
    if(typeof $scope.guestCardData == 'undefined' || typeof $scope.guestCardData.contactInfo == 'undefined'){
        $scope.passData.details.firstName = '';
        $scope.passData.details.lastName = '';
    }
    else{
        $scope.passData.details.firstName = $scope.guestCardData.contactInfo.first_name;
        $scope.passData.details.lastName = $scope.guestCardData.contactInfo.last_name;
    }
    $scope.setScroller('cardsList');

    /**
    * Initializing the scrollers for the screen
    */
    var scrollerOptions = { preventDefault: false};
    $scope.setScroller('paymentList', scrollerOptions); 
    $scope.setScroller('billingGroups', scrollerOptions);
    $scope.setScroller('chargeCodes', scrollerOptions); 
    var scrollerOptionsForSearch = {click: true};
    $scope.setScroller('chargeCodesList',scrollerOptionsForSearch);
    $scope.chargeCodesListDivHgt = 250;
    $scope.chargeCodesListDivTop = 0;
    setTimeout(function(){
                $scope.refreshScroller('paymentList'); 
                $scope.refreshScroller('billingGroups');
                $scope.refreshScroller('chargeCodes');
                $scope.refreshScroller('chargeCodesList');
                }, 
            500);

    /**
    * function to show the payment list on cancelling or adding new payment
    */
	$scope.showPaymentList = function(){
		$scope.isAddPayment = false;
        $scope.refreshScroller('paymentList'); 
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
     /**
    * function to show the newly added payment
    */
    $scope.paymentAdded = function(data){
        $scope.selectedEntity.selected_payment = "";
        $scope.cardData = data;
        $scope.renderAddedPayment = {};
        $scope.renderAddedPayment.payment_type = "CC";
        $scope.isAddPayment = true;
        $scope.showPayment  = true;
        
        $scope.renderAddedPayment.creditCardType = (!$scope.cardData.tokenDetails.isSixPayment)?
										getCreditCardType($scope.cardData.cardDetails.cardType).toLowerCase() : 
										getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase();
		$scope.renderAddedPayment.cardExpiry = retrieveExpiryDate();
		$scope.renderAddedPayment.endingWith = retrieveCardNumber();	
     };
     $scope.paymentAddedThroughMLISwipe = function(swipedCardDataToSave){
     	$scope.renderAddedPayment = {};
        $scope.renderAddedPayment.payment_type = "CC";
     	$scope.swipedCardDataToSave = swipedCardDataToSave;
     	$scope.renderAddedPayment.creditCardType = swipedCardDataToSave.cardType.toLowerCase();
		$scope.renderAddedPayment.cardExpiry = swipedCardDataToSave.cardExpiryMonth+"/"+swipedCardDataToSave.cardExpiryYear;
		$scope.renderAddedPayment.endingWith = swipedCardDataToSave.cardNumber.slice(-4);
     };
    /**
    * function to show the add payment view
    */
	$scope.showAddPayment = function(){
        if(!$rootScope.isManualCCEntryEnabled){
            $scope.isManualCCEntryEnabled = false;
            var dialog = ngDialog.open({
                template: '/assets/partials/payment/rvPaymentModal.html',
                controller: '',
                scope: $scope
              });
            return;
        }
      
		$scope.isAddPayment = true;
		$scope.showCreditCardDropDown = true;
		$scope.renderAddedPayment = {};
		$scope.renderAddedPayment.creditCardType  = "";
		$scope.renderAddedPayment.cardExpiry = "";
		$scope.renderAddedPayment.endingWith = "";
		$scope.renderAddedPayment.payment_type = "";
		$scope.isShownExistingCCPayment = false;
        $scope.$broadcast('showaddpayment');
	};
	$scope.$on("SHOW_SWIPED_DATA_ON_BILLING_SCREEN", function(e, swipedCardDataToRender){
		$scope.isAddPayment = true;	
		 $scope.$broadcast('showaddpayment');
		 
		setTimeout(function(){
			$scope.saveData.payment_type = "CC";
			$scope.showCreditCardDropDown = true;
			$scope.$broadcast('RENDER_DATA_ON_BILLING_SCREEN', swipedCardDataToRender);
			$scope.$digest();
		}, 2000);
		
    	
	});
    /**
    * Listener to track the ngDialog open event.
    * We save the id for the ngDialog to close nested dialog for disabling manual payment addition.
    */
    $scope.$on("ngDialog.opened", function(event, data){
            
           $scope.ngDialogID =  data[0].id;
    });
    $scope.closeDialog = function(){
        ngDialog.close($scope.ngDialogID);
        
    };
    /**
    * function to switch between the charge code and billing groups views
    */
	$scope.toggleChargeType = function(){
		$scope.isBillingGroup = !$scope.isBillingGroup;
        if($scope.isBillingGroup){
            $scope.refreshScroller('billingGroups');
        }
        else
            $scope.refreshScroller('chargeCodes');
        $scope.showChargeCodes = false;
	};
    /**
    * function to know if the billing grup is selected or not, to adjust the UI
    */
	$scope.isBillingGroupSelected = function(billingGroup){
        for(var i=0; i < $scope.selectedEntity.attached_billing_groups.length; i++){
            if($scope.selectedEntity.attached_billing_groups[i].id == billingGroup.id )
                return true;
        }
        return false;
    }   ;
    /**
    * function to switch the billing group selection
    */
    $scope.toggleSelectionForBillingGroup = function(billingGroup){
        for(var i=0; i < $scope.selectedEntity.attached_billing_groups.length; i++){
            if($scope.selectedEntity.attached_billing_groups[i].id == billingGroup.id ){
                $scope.selectedEntity.attached_billing_groups.splice(i, 1);
                return;                
            }
        }
        $scope.selectedEntity.attached_billing_groups.push(billingGroup);
        $scope.refreshScroller('billingGroups');
    };
    /**
    * function to remove the charge code
    */
    $scope.removeChargeCode = function(chargeCode){
        for(var i=0; i < $scope.selectedEntity.attached_charge_codes.length; i++){
            if($scope.selectedEntity.attached_charge_codes[i].id == chargeCode.id ){
                $scope.selectedEntity.attached_charge_codes.splice(i, 1);
                return;                
            }
        }
    };    
    /**
    * function to show available charge code list on clicking the dropdown
    */
    $scope.showAvailableChargeCodes = function(){
        $scope.clearResults ();
        displayFilteredResultsChargeCodes();
        $scope.showChargeCodes = !$scope.showChargeCodes;
    }; 

    /**
    * function to select charge code
    */
    $scope.addChargeCode = function(){
        for(var i=0; i < $scope.availableChargeCodes.length; i++){
            if($scope.availableChargeCodes[i].id == $scope.chargeCodeToAdd){
                for(var j=0; j < $scope.selectedEntity.attached_charge_codes.length; j++){
                    
                    if($scope.selectedEntity.attached_charge_codes[j].id == $scope.chargeCodeToAdd ){
                        return;                
                    }
                }     
                $scope.selectedEntity.attached_charge_codes.push($scope.availableChargeCodes[i]); 
                $scope.refreshScroller('chargeCodes');     
                return;
            }
        }
    };      
    /**
    * function to select the charge code to be used in UI
    */
    $scope.selectChargeCode = function(selected_chargecode_id){
        $scope.chargeCodeToAdd = selected_chargecode_id;
        $scope.addChargeCode();
        $scope.chargeCodeSearchText = '';
        $scope.showChargeCodes = false;
    };
    /**
    * function to fetch available charge code from the server
    */
	$scope.fetchAvailableChargeCodes = function(){
        
            var successCallback = function(data) {
                $scope.availableChargeCodes = data;
                $scope.fetchAvailableBillingGroups();
            };
            var errorCallback = function(errorMessage) {
                $scope.$parent.$emit('hideLoader');
                $scope.$emit('displayErrorMessage',errorMessage);
            };
            var data = {};
            data.id = $scope.reservationData.reservation_id;
            if($scope.reservationData.reservation_id != $scope.selectedEntity.id && $scope.selectedEntity.entity_type == 'RESERVATION'){
                        data.to_bill = $scope.first_bill_id;
            }else{
                data.to_bill = $scope.selectedEntity.to_bill;
            }
            data.is_new = $scope.selectedEntity.is_new;
            
            
            $scope.invokeApi(RVBillinginfoSrv.fetchAvailableChargeCodes, data, successCallback, errorCallback);
    };	
    /**
    * function to fetch available billing groups from the server
    */
    $scope.fetchAvailableBillingGroups = function(){
        
            var successCallback = function(data) {
                $scope.availableBillingGroups = data;
                if(data.length == 0)
                    $scope.isBillingGroup = false;
                if($scope.reservationData.reservation_id != $scope.selectedEntity.id && $scope.selectedEntity.entity_type == 'RESERVATION'){
                    $scope.$parent.$emit('hideLoader');                    
                }else if($scope.reservationData.reservation_id != $scope.selectedEntity.id && $scope.selectedEntity.entity_type != 'RESERVATION'){
                    $scope.showPayment = true;
                    $scope.attachedPaymentTypes = [];
                    $scope.$parent.$emit('hideLoader');
                }else{
                    $scope.showPayment = true;
                    $scope.fetchAttachedPaymentTypes();
                }
                
            };
            var errorCallback = function(errorMessage) {
                $scope.$parent.$emit('hideLoader');
                $scope.$emit('displayErrorMessage',errorMessage);
            };
            var data = {};
            data.id = $scope.reservationData.reservation_id;
            if($scope.reservationData.reservation_id != $scope.selectedEntity.id && $scope.selectedEntity.entity_type == 'RESERVATION'){
                        data.to_bill = $scope.first_bill_id;
            }else{
                data.to_bill = $scope.selectedEntity.to_bill;
            }
            data.is_new = $scope.selectedEntity.is_new;
           
            $scope.invokeApi(RVBillinginfoSrv.fetchAvailableBillingGroups, data, successCallback, errorCallback);
    };	
    /**
    * function to fetch attached payment types from the server
    */
    $scope.fetchAttachedPaymentTypes = function(){
        
            var successCallback = function(data) {
                
                $scope.attachedPaymentTypes = data;
                $scope.$parent.$emit('hideLoader');
            };
            var errorCallback = function(errorMessage) {
                $scope.$parent.$emit('hideLoader');
                $scope.$emit('displayErrorMessage',errorMessage);
            };
           
            $scope.invokeApi(RVGuestCardSrv.fetchGuestPaymentData, $scope.reservationData.user_id, successCallback, errorCallback);
    };

    /**
    * function to exclude bills for already existing routings
    */
    $scope.excludeExistingBills = function(bills){
        
           for(var i = 0; i < $scope.routes.length; i++){
                for(var j = 0; j < bills.length; j++){
                    if(bills[j].id == $scope.routes[i].to_bill && $scope.selectedEntity.id != $scope.routes[i].id){
                        bills.splice(j, 1);
                        break;
                    }
                }
           }
           return bills;
    };
    /**
    * function to fetch available bills for the reservation from the server
    */
    $scope.fetchBillsForReservation = function(){
        
            var successCallback = function(data) {
                $scope.bills = [];
                $scope.$parent.bills = [];
                
               if(data.length > 0){
                    $scope.first_bill_id = data[0].id;
                    $scope.newBillNumber = data.length + 1;
                    if($scope.reservationData.reservation_id != $scope.selectedEntity.id && $scope.selectedEntity.entity_type == 'RESERVATION'){
                        $scope.bills.push(data[0]);
                        $scope.bills = $scope.excludeExistingBills($scope.bills);
                        $scope.$parent.bills = $scope.bills;
                    }else{
                        data.splice(0, 1);
                        $scope.bills = $scope.excludeExistingBills(data);
                        if($scope.newBillNumber <= 10){
                            var newBill = {};
                            newBill.id = 'new';
                            newBill.bill_number = '' + $scope.newBillNumber + '(new)';
                            $scope.bills.push(newBill);
                        }                        
                        $scope.$parent.bills = $scope.bills;
                    }
                    $scope.selectedEntity.to_bill = $scope.selectedEntity.is_new? $scope.bills[0].id : $scope.selectedEntity.to_bill;
                    $scope.fetchAvailableChargeCodes();
                }
            };
            var errorCallback = function(errorMessage) {
                $scope.$parent.$emit('hideLoader');
                $scope.$emit('displayErrorMessage',errorMessage);
            };
            var id = $scope.selectedEntity.id;
            if($scope.selectedEntity.entity_type != 'RESERVATION')
                id = $scope.reservationData.reservation_id;
           
            $scope.invokeApi(RVBillinginfoSrv.fetchBillsForReservation, id, successCallback, errorCallback);
    };

    $scope.fetchDefaultAccountRouting = function(){

        var successCallback = function(data) {
        	
            $scope.selectedEntity.attached_charge_codes = data.attached_charge_codes;
            $scope.selectedEntity.attached_billing_groups = data.billing_groups;
            if(!isEmptyObject(data.credit_card_details)){
	            $scope.renderAddedPayment = data.credit_card_details;
	            $scope.saveData.payment_type = data.credit_card_details.payment_type;

		        $scope.renderAddedPayment.cardExpiry = data.credit_card_details.card_expiry;
		        $scope.renderAddedPayment.endingWith = data.credit_card_details.card_number;
		        $scope.renderAddedPayment.creditCardType = data.credit_card_details.card_code;
		        $scope.isAddPayment = true;
		        if(data.credit_card_details.payment_type != 'CC'){
		        	 $scope.showCreditCardDropDown = true;
		        } else {
		        	 $scope.showCreditCardDropDown = false;
		        	 $scope.isShownExistingCCPayment = true;
		        }
		       
		       
		    }
	       
            $scope.$parent.$emit('hideLoader');

        };
        var params = {};
        params.id = $scope.selectedEntity.id;
        $scope.invokeApi(RVBillinginfoSrv.fetchDefaultAccountRouting, params, successCallback);

    };
    /**
    * function to fetch available billing groups from the server
    */
    $scope.fetchAllBillingGroups = function(){
        
            var successCallback = function(data) {
                $scope.availableBillingGroups = data;
                if(data.length == 0)
                    $scope.isBillingGroup = false;
                $scope.$parent.$emit('hideLoader');
                $scope.fetchDefaultAccountRouting();

            };
            var errorCallback = function(errorMessage) {
                $scope.$parent.$emit('hideLoader');
                $scope.$emit('displayErrorMessage',errorMessage);
            };
            
           
            $scope.invokeApi(RVBillinginfoSrv.fetchAllBillingGroups, '', successCallback, errorCallback);
    };  

    $scope.fetchAllChargeCodes = function(){
        var successCallback = function(data) {
            $scope.availableChargeCodes = data;
            $scope.fetchAllBillingGroups();
        };
        var errorCallback = function(errorMessage) {
            $scope.$parent.$emit('hideLoader');
            $scope.$emit('displayErrorMessage',errorMessage);
        };
        
        $scope.invokeApi(RVBillinginfoSrv.fetchAllChargeCodes, '', successCallback, errorCallback);
    };

    if($scope.billingEntity !== "TRAVEL_AGENT_DEFAULT_BILLING" &&
        $scope.billingEntity !== "COMPANY_CARD_DEFAULT_BILLING"){
        $scope.fetchBillsForReservation();
    }else {
        $scope.fetchAllChargeCodes();
    }
     if($scope.billingEntity == "TRAVEL_AGENT_DEFAULT_BILLING" ||
        $scope.billingEntity == "COMPANY_CARD_DEFAULT_BILLING"){
        	$scope.showPayment = true;
     }
    /**
    * function to trigger the filtering when the search text is entered
    */
    $scope.chargeCodeEntered = function(){
        $scope.showChargeCodes = false;
	   	displayFilteredResultsChargeCodes();
	   	var queryText = $scope.chargeCodeSearchText;
	   	$scope.chargeCodeSearchText = queryText.charAt(0).toUpperCase() + queryText.slice(1);
    };
	/**
    * function to clear the charge code search text
    */
	$scope.clearResults = function(){
	  	$scope.chargeCodeSearchText = "";
	};
  	
  	/**
  	* function to perform filering on results.
  	* if not fouund in the data, it will request for webservice
  	*/
  	var displayFilteredResultsChargeCodes = function(){ 
	    //if the entered text's length < 3, we will show everything, means no filtering    
	    if($scope.chargeCodeSearchText.length < 3){
	      //based on 'is_row_visible' parameter we are showing the data in the template      
	      for(var i = 0; i < $scope.availableChargeCodes.length; i++){
	      	if($scope.isChargeCodeSelected($scope.availableChargeCodes[i])){
	      		$scope.availableChargeCodes[i].is_row_visible = false;
	          	$scope.availableChargeCodes[i].is_selected = false;
	      	} else {
	      		$scope.availableChargeCodes[i].is_row_visible = true;
	            $scope.availableChargeCodes[i].is_selected = true;
	      	}
	          
	      }     
	      $scope.refreshScroller('chargeCodesList');
	      // we have changed data, so we are refreshing the scrollerbar
	      //$scope.refreshScroller('cards_search_scroller');      
	    }
	    else{
	      var value = ""; 
	      //searching in the data we have, we are using a variable 'visibleElementsCount' to track matching
	      //if it is zero, then we will request for webservice
	      for(var i = 0; i < $scope.availableChargeCodes.length; i++){
	        value = $scope.availableChargeCodes[i];
	        if ((($scope.escapeNull(value.code).toUpperCase()).indexOf($scope.chargeCodeSearchText.toUpperCase()) >= 0 || 
	            ($scope.escapeNull(value.description).toUpperCase()).indexOf($scope.chargeCodeSearchText.toUpperCase()) >= 0) && (!$scope.isChargeCodeSelected($scope.availableChargeCodes[i]))) 
	            {
	               $scope.availableChargeCodes[i].is_row_visible = true;
	            }
	        else {
	          $scope.availableChargeCodes[i].is_row_visible = false;
	        }
	              
	      }
	      // we have changed data, so we are refreshing the scrollerbar
	      //$scope.refreshScroller('cards_search_scroller');    
	      $scope.refreshScroller('chargeCodesList');              
	    }
  	};	
  	/**
    * function to know if the charge code is selected, to adjust in UI
    */
  	$scope.isChargeCodeSelected = function(chargeCode){
  		for(var i=0; i < $scope.selectedEntity.attached_charge_codes.length; i++){
            if($scope.selectedEntity.attached_charge_codes[i].id == chargeCode.id )
                return true;
        }
        return false;
  	};

    /**
    * Listener for the save button click
    */
    $scope.$on('routeSaveClicked', function(event){
            
            $scope.saveRoute();
    });
    /**
    * function to update the company and travel agent in stay card header
    */
    $scope.updateCardInfo = function(){
        
        if(($scope.selectedEntity.entity_type == 'COMPANY_CARD' && (typeof $scope.reservationDetails.companyCard.id == 'undefined'|| $scope.reservationDetails.companyCard.id == '')) || 
            ($scope.selectedEntity.entity_type == 'TRAVEL_AGENT' && ($scope.reservationDetails.travelAgent.id == 'undefined' || $scope.reservationDetails.travelAgent.id == ''))) {
            $rootScope.$broadcast('CardInfoUpdated', $scope.selectedEntity.id, $scope.selectedEntity.entity_type);
        }        
    };
    /**
    * function to save the new route
    */
    $scope.saveRoute = function(){
            $scope.saveSuccessCallback = function(data) {
                $scope.$parent.$emit('hideLoader');
                $scope.setReloadOption(true);
                $scope.headerButtonClicked();
                $scope.updateCardInfo();
            };
            $scope.errorCallback = function(errorMessage) {
                $scope.$parent.$emit('hideLoader');
                $scope.$emit('displayErrorMessage',errorMessage);
            };
            
            if($scope.selectedEntity.attached_charge_codes.length == 0 && $scope.selectedEntity.attached_billing_groups.length==0){
                $scope.$emit('displayErrorMessage',[$filter('translate')('ERROR_CHARGES_EMPTY')]);
                return;
            }
            if($scope.billingEntity !== "TRAVEL_AGENT_DEFAULT_BILLING" &&
                $scope.billingEntity !== "COMPANY_CARD_DEFAULT_BILLING"){
                $scope.selectedEntity.reservation_id=$scope.reservationData.reservation_id;      
            }

            var defaultRoutingSaveSuccess = function(){
                $scope.$parent.$emit('hideLoader');
                ngDialog.close();
            };
           
           /*
             * If user selects the new bill option,
             * we'll first create the bill and then save the route for that bill
             */
            
           if($scope.selectedEntity.to_bill == 'new'){
                $scope.createNewBill();
            }
            else if( $scope.saveData.payment_type != null && $scope.saveData.payment_type != "" && !$scope.isShownExistingCCPayment){
                $scope.savePayment();
            }
            // else if($scope.paymentDetails != null){
                // $scope.savePayment();
            // }
            
            else{
                if($scope.billingEntity === "TRAVEL_AGENT_DEFAULT_BILLING" ||
                    $scope.billingEntity === "COMPANY_CARD_DEFAULT_BILLING"){
                    $scope.invokeApi(RVBillinginfoSrv.saveDefaultAccountRouting, $scope.selectedEntity, defaultRoutingSaveSuccess, $scope.errorCallback);
                }else {
                    $scope.invokeApi(RVBillinginfoSrv.saveRoute, $scope.selectedEntity, $scope.saveSuccessCallback, $scope.errorCallback);
                }
            }
            
    };

        /**
        * function to create new bill
        */
        $scope.createNewBill = function(){
            var billData ={
                        "reservation_id" : $scope.reservationData.reservation_id
                        };
                    /*
                     * Success Callback of create bill action
                     */
                    var createBillSuccessCallback = function(data){
                        $scope.$emit('hideLoader');   
                        $scope.selectedEntity.to_bill = data.id;    
                        $scope.bills[$scope.bills.length - 1].id = data.id;  
                        if($scope.saveData.payment_type != null && $scope.saveData.payment_type != "" ){
                            $scope.savePayment();
                        }else{
                            $scope.invokeApi(RVBillinginfoSrv.saveRoute, $scope.selectedEntity, $scope.saveSuccessCallback, $scope.errorCallback);
                        }
                        
                    };
                    $scope.invokeApi(RVBillCardSrv.createAnotherBill,billData,createBillSuccessCallback, $scope.errorCallback);
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
        /**
        * function to save a new payment type for the bill
        */
        $scope.savePayment = function(){
            
           
          
            if($scope.reservationData!=undefined){
            	if($scope.reservationData.reservation_id != null){
            		$scope.savePaymentToReservationOrAccount('reservation');
            	} else if($scope.billingEntity === "TRAVEL_AGENT_DEFAULT_BILLING" ||
                    $scope.billingEntity === "COMPANY_CARD_DEFAULT_BILLING") {
                    	$scope.savePaymentToReservationOrAccount('account');
	            } else {
	                $scope.invokeApi(RVBillinginfoSrv.saveRoute, $scope.selectedEntity, $scope.saveSuccessCallback, $scope.errorCallback);
	            }
	                
            } else if($scope.billingEntity === "TRAVEL_AGENT_DEFAULT_BILLING" ||
                    $scope.billingEntity === "COMPANY_CARD_DEFAULT_BILLING") {
                    	$scope.savePaymentToReservationOrAccount('account');
            	
            } else {
                $scope.invokeApi(RVBillinginfoSrv.saveRoute, $scope.selectedEntity, $scope.saveSuccessCallback, $scope.errorCallback);
            }
            
        };
        $scope.savePaymentToReservationOrAccount = function(toReservationOrAccount){
        	  var defaultRoutingSaveSuccess = function(){
                $scope.$parent.$emit('hideLoader');
                ngDialog.close();
              };
        	 var successCallback = function(data) {
        	 	$scope.$parent.$emit('hideLoader');
        	 	if($scope.billingEntity === "TRAVEL_AGENT_DEFAULT_BILLING" ||
                    $scope.billingEntity === "COMPANY_CARD_DEFAULT_BILLING") {
                		$scope.invokeApi(RVBillinginfoSrv.saveDefaultAccountRouting, $scope.selectedEntity, defaultRoutingSaveSuccess, $scope.errorCallback);
                } else {
                	$scope.invokeApi(RVBillinginfoSrv.saveRoute, $scope.selectedEntity, $scope.saveSuccessCallback, $scope.errorCallback);
                }
            };
            var errorCallback = function(errorMessage) {
                $scope.$parent.$emit('hideLoader');
                $scope.$emit('displayErrorMessage',errorMessage);
            };
             var successSixSwipe = function(response){
             	
             	
             	var data = {
             		"token" : response.token,
             		"is_swiped": true
             	};
             	if(toReservationOrAccount == "reservation"){
					data.reservation_id = $scope.reservationData.reservation_id;
				} else {
					data.account_id = $scope.selectedEntity.id;
				}
             	$scope.invokeApi(RVPaymentSrv.savePaymentDetails, data, successCallback, errorCallback);
            	//$scope.invokeApi(RVBillinginfoSrv.saveRoute, $scope.selectedEntity, $scope.saveSuccessCallback, $scope.errorCallback);
            };
        	if($scope.saveData.payment_type == 'CC'){
					if($rootScope.paymentGateway == "sixpayments" && !$scope.sixIsManual){
						
							var data = {};
							if(toReservationOrAccount == "reservation"){
								data.reservation_id = $scope.reservationData.reservation_id;
							} else {
								data.account_id = $scope.selectedEntity.id;
							}
							
							data.add_to_guest_card = false;
							data.bill_number = $scope.getSelectedBillNumber();	
							
						
						$scope.$emit('UPDATE_SHOULD_SHOW_WAITING', true);
						RVPaymentSrv.chipAndPinGetToken(data).then(function(response) {
							$scope.$emit('UPDATE_SHOULD_SHOW_WAITING', false);
							successSixSwipe(response);
						},function(error){
							$scope.errorMessage = error;
							$scope.$emit('UPDATE_SHOULD_SHOW_WAITING', false);
							// $scope.shouldShowWaiting = false;
						});
						
						
						
						
						
					} else if(!isEmptyObject($scope.swipedCardDataToSave)){
						
						var data 			= $scope.swipedCardDataToSave;
						if(toReservationOrAccount == "reservation"){
							data.reservation_id = $scope.reservationData.reservation_id;
						} else {
							data.account_id = $scope.selectedEntity.id;
						}
						data.bill_number = $scope.getSelectedBillNumber();	
						data.payment_credit_type = $scope.swipedCardDataToSave.cardType;
						data.credit_card = $scope.swipedCardDataToSave.cardType;
						data.card_expiry = "20"+$scope.swipedCardDataToSave.cardExpiryYear+"-"+$scope.swipedCardDataToSave.cardExpiryMonth+"-01";
						$scope.invokeApi(RVPaymentSrv.savePaymentDetails, data, successCallback, errorCallback);
						
					} else {
						  var data = {
							"add_to_guest_card": false
						};
						if(toReservationOrAccount == "reservation"){
							data.reservation_id = $scope.reservationData.reservation_id;
						} else {
							data.account_id = $scope.selectedEntity.id;
						}
						data.payment_type = $scope.saveData.payment_type;
						creditCardType = (!$scope.cardData.tokenDetails.isSixPayment)? 
									    getCreditCardType($scope.cardData.cardDetails.cardType):
										getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase();
						data.token = 
										(!$scope.cardData.tokenDetails.isSixPayment)?
										$scope.cardData.tokenDetails.session :
										$scope.cardData.tokenDetails.token_no;
						data.card_name = retrieveCardName();
						data.bill_number = $scope.getSelectedBillNumber();	
						data.card_expiry = 	retrieveCardExpiryForApi();
						data.card_code   = (!$scope.cardData.tokenDetails.isSixPayment)?
										$scope.cardData.cardDetails.cardType: 
										getSixCreditCardType($scope.cardData.tokenDetails.card_type).toLowerCase();
						$scope.invokeApi(RVPaymentSrv.savePaymentDetails, data, successCallback, errorCallback);
					}
					 console.log(JSON.stringify(data));
				} else {
					var data = {
							"payment_type"  :   $scope.saveData.payment_type
						};
						if(toReservationOrAccount == "reservation"){
							data.reservation_id = $scope.reservationData.reservation_id;
						} else {
							data.account_id = $scope.selectedEntity.id;
						}
                    data.bill_number = $scope.getSelectedBillNumber();
					$scope.invokeApi(RVPaymentSrv.savePaymentDetails, data, successCallback, errorCallback);
			    }
       };
         /**
        * function to get selected bill number
        */
        $scope.getSelectedBillNumber = function(){
            for(var i = 0; i < $scope.bills.length; i++){
                if($scope.bills[i].id == $scope.selectedEntity.to_bill)
                    return $scope.bills[i].bill_number;
            }    
        };
        $scope.sixIsManual = false;
        $scope.$on('CHANGE_IS_MANUAL', function(e, value){
        	$scope.sixIsManual = value;
        });

}]);