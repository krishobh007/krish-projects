sntRover.controller('rvBillingInformationPopupCtrl',['$scope','$rootScope','$filter','RVBillinginfoSrv', 'ngDialog', function($scope, $rootScope,$filter, RVBillinginfoSrv, ngDialog){
	BaseCtrl.call(this, $scope);
	
	$scope.isInitialPage = true;
    $scope.isEntitySelected = false;

    $scope.selectedEntity = {};
	$scope.results = {};
    $scope.bills = [];
    $scope.isReloadNeeded = false;
    $scope.routes = [];
    $scope.errorMessage = '';
    $scope.isInitialPage = true;
    $scope.saveData = {};
    $scope.saveData.payment_type =  "";
    $scope.saveData.payment_type_description =  "";
    $scope.saveData.newPaymentFormVisible = false;
	$scope.shouldShowWaiting = false;

	$scope.$on('UPDATE_SHOULD_SHOW_WAITING', function(e, value){
		$scope.shouldShowWaiting = value;
	});
	$scope.closeDialog = function(){
		ngDialog.close();
        $scope.$emit('routingPopupDismissed');
	};

	$scope.dimissLoaderAndDialog = function(){
			$scope.$emit('hideLoader');
			$scope.closeDialog();
		};

     
    // $scope.$watch(
    //         function() { return $scope.errorMessage; },
    //         function(error) {
    //             $scope.refreshScroller('homeScroll');
    //         }
    //     );
    /**
    * function to get label for all routes and add routes button
    */
	$scope.getHeaderButtonLabel = function(){
		return $scope.isInitialPage? $filter('translate')('ADD_ROUTES_LABEL') : $filter('translate')('ALL_ROUTES_LABEL');		
	}
    /**
    * function to set the reload option
    param option is boolean
    */
    $scope.setReloadOption = function(option){
        $scope.isReloadNeeded = option;
    }
    /**
    * function to handle the click 'all routes' and 'add routes' button
    */
	$scope.headerButtonClicked = function(){
        $scope.isEntitySelected = false;
		$scope.isInitialPage = !$scope.isInitialPage;
        if($scope.isInitialPage  && $scope.isReloadNeeded){
            $scope.isReloadNeeded = false;
            $scope.fetchRoutes();
        }
	}
    /**
    * function to handle the pencil button click in route detail screen
    */
    $scope.deSelectEntity = function(){
        $scope.isEntitySelected = false;
    }
    /**
    * function to handle entity selection from the 'All Routes' screen and the 'select entity' screen
    */
	$scope.selectEntity = function(index,type){

		$scope.isEntitySelected = true;
        $scope.isInitialPage = false;
        if(type === 'ATTACHED_ENTITY' || type === 'ROUTES'){
        	$scope.selectedEntity = $scope.routes[index];
            $scope.selectedEntity.is_new = (type == 'ATTACHED_ENTITY')? true: false; 
            $scope.selectedEntity.images[0].guest_image = $scope.selectedEntity.images[0].image;
            if($scope.selectedEntity.entity_type !='RESERVATION')  
                   $scope.selectedEntity.guest_id = null;       
        }
        else if(type === 'RESERVATIONS'){
        	var data = $scope.results.reservations[index];
        	$scope.selectedEntity = {
			    "id": data.id,
			    "reservation_status" : data.reservation_status,
                "is_opted_late_checkout" : data.is_opted_late_checkout,
			    "name": data.firstname + " " + data.lastname,
			    "images": data.images,
			    "bill_no": "",
			    "entity_type": "RESERVATION",
			    "has_accompanying_guests" : ( data.images.length >1 ) ? true : false,
			    "attached_charge_codes": [],
			    "attached_billing_groups": [],
                "is_new" : true,
                "credit_card_details": {}
			};
			
        	console.log($scope.selectedEntity);
        }
        else if(type === 'CARDS'){
        	var data = $scope.results.cards[index];
        	$scope.selectedEntity = {
			    "id": data.id,
			    "name": data.account_name,
			    "bill_no": "",
			    "images": [{
                    "is_primary":true, 
		            "guest_image": data.company_logo,
		        }],
			    "attached_charge_codes": [],
			    "attached_billing_groups": [],
                "is_new" : true,
                "selected_payment" : "",
                "credit_card_details": {}
			};
			if(data.account_type === 'COMPANY'){
				$scope.selectedEntity.entity_type = 'COMPANY_CARD';
			}
			else{
				$scope.selectedEntity.entity_type = 'TRAVEL_AGENT';
			}
        }
	};

    /*function to select the attached entity
    */
    $scope.selectAttachedEntity = function(index,type){

            $scope.isEntitySelected = true;
            $scope.isInitialPage = false;
            //TODO: Remove commented out code
            $scope.selectedEntity = {
               // "reservation_status" : $scope.reservationData.reservation_status,
                //"is_opted_late_checkout" : $scope.reservationData.is_opted_late_checkout,               
                "bill_no": "",              
                "has_accompanying_guests" : false,
                "attached_charge_codes": [],
                "attached_billing_groups": [],
                "is_new" : true,
                "credit_card_details": {}
            };
            if($scope.billingEntity !== "TRAVEL_AGENT_DEFAULT_BILLING" &&
                $scope.billingEntity !== "COMPANY_CARD_DEFAULT_BILLING"){
                $scope.selectedEntity.reservation_status = $scope.reservationData.reservation_status;
                $scope.selectedEntity.is_opted_late_checkout = $scope.reservationData.is_opted_late_checkout;
            }

            if(type == 'GUEST'){
                $scope.selectedEntity.id = $scope.reservationData.reservation_id;
                $scope.selectedEntity.guest_id = $scope.attachedEntities.primary_guest_details.id;
                $scope.selectedEntity.name = $scope.attachedEntities.primary_guest_details.name;
                $scope.selectedEntity.images = [{
                    "is_primary":true, 
                    "guest_image": $scope.attachedEntities.primary_guest_details.avatar
                }];
                $scope.selectedEntity.entity_type = "RESERVATION";
            }else if(type == 'ACCOMPANY_GUEST'){
                $scope.selectedEntity.id = $scope.reservationData.reservation_id;
                $scope.selectedEntity.guest_id = $scope.attachedEntities.accompanying_guest_details[index].id;
                $scope.selectedEntity.name = $scope.attachedEntities.accompanying_guest_details[index].name;
                $scope.selectedEntity.images = [{
                    "is_primary":false, 
                    "guest_image": $scope.attachedEntities.accompanying_guest_details[index].avatar
                }];     
                $scope.selectedEntity.has_accompanying_guests = true;        
                $scope.selectedEntity.entity_type = "RESERVATION";
            }else if(type == 'COMPANY_CARD'){
                $scope.selectedEntity.id = $scope.attachedEntities.company_card.id;
                $scope.selectedEntity.name = $scope.attachedEntities.company_card.name;
                $scope.selectedEntity.images = [{
                    "is_primary":true, 
                    "guest_image": $scope.attachedEntities.company_card.logo
                }];             
                $scope.selectedEntity.entity_type = "COMPANY_CARD";
            }else if(type == 'TRAVEL_AGENT'){
                $scope.selectedEntity.id = $scope.attachedEntities.travel_agent.id;
                $scope.selectedEntity.name = $scope.attachedEntities.travel_agent.name;
                $scope.selectedEntity.images = [{
                    "is_primary":true, 
                    "guest_image": $scope.attachedEntities.travel_agent.logo
                }];             
                $scope.selectedEntity.entity_type = "TRAVEL_AGENT";                
            }
    };

    /*
    * function used in template to map the reservation status to the view expected format
    */
    $scope.getGuestStatusMapped = function(reservationStatus, isLateCheckoutOn){
      var viewStatus = "";
      if(isLateCheckoutOn && "CHECKING_OUT" == reservationStatus){
        viewStatus = "late-check-out";
        return viewStatus;
      }
      if("RESERVED" == reservationStatus){
        viewStatus = "arrival";
      }else if("CHECKING_IN" == reservationStatus){
        viewStatus = "check-in";
      }else if("CHECKEDIN" == reservationStatus){
        viewStatus = "inhouse";
      }else if("CHECKEDOUT" == reservationStatus){
        viewStatus = "departed";
      }else if("CHECKING_OUT" == reservationStatus){
        viewStatus = "check-out";
      }else if("CANCELED" == reservationStatus){
        viewStatus = "cancel";
      }else if(("NOSHOW" == reservationStatus)||("NOSHOW_CURRENT" == reservationStatus)){
        viewStatus = "no-show";
      }
      return viewStatus;
  };

     /**
    * function to get the class for the 'li' according to the entity role
    */
	$scope.getEntityRole = function(route){
    	if(route.entity_type == 'RESERVATION' &&  !route.has_accompanying_guests)
    		return 'guest';
    	else if(route.entity_type == 'RESERVATION')
    		return 'accompany';
    	else if(route.entity_type == 'TRAVEL_AGENT')
    		return 'travel-agent';
    	else if(route.entity_type == 'COMPANY_CARD')
    		return 'company';
    };
     /**
    * function to get the class for the 'icon' according to the entity role
    */
    $scope.getEntityIconClass = function(route){
        if(route.entity_type == 'RESERVATION' &&  route.has_accompanying_guests )
            return 'accompany';
    	else if(route.entity_type == 'RESERVATION' || route.entity_type == 'COMPANY_CARD')
            return '';
    	else if(route.entity_type == 'TRAVEL_AGENT')
    		return 'icons icon-travel-agent';
    	
    };
    /**
    * function to fetch the attached entity list
    */
    $scope.fetchRoutes = function(){
        
            var successCallback = function(data) {
                 $scope.routes = data;
                 $scope.fetchEntities();
            };
            var errorCallback = function(errorMessage) {
                $scope.fetchEntities();
                $scope.errorMessage = errorMessage;

            };
           
            $scope.invokeApi(RVBillinginfoSrv.fetchRoutes, $scope.reservationData.reservation_id, successCallback, errorCallback);
    };	

    /**
    * function to fetch the attached entity list
    */
    $scope.fetchEntities = function(){
        
            var successCallback = function(data) {
                $scope.attachedEntities = data;
                 $scope.$parent.$emit('hideLoader');
            };
            var errorCallback = function(errorMessage) {
                $scope.$emit('hideLoader');
                $scope.errorMessage = errorMessage;
                
            };
           
            $scope.invokeApi(RVBillinginfoSrv.fetchAttachedCards, $scope.reservationData.reservation_id, successCallback, errorCallback);
    };  

    if($scope.attachedEntities === undefined){
        $scope.isInitialPage = true;
        $scope.fetchRoutes();
        $scope.attachedEntities = [];
       
    } else {
        if($scope.billingEntity == "TRAVEL_AGENT_DEFAULT_BILLING"){
            $scope.selectAttachedEntity('', 'TRAVEL_AGENT');
        } else if($scope.billingEntity == "COMPANY_CARD_DEFAULT_BILLING") {
            $scope.selectAttachedEntity('', 'COMPANY_CARD');
        } else {
            $scope.isInitialPage = true;
            $scope.fetchRoutes();
            $scope.attachedEntities = [];
        }

    }

    /**
    * function to save the new route
    */
    $scope.saveRoute = function(){
            $rootScope.$broadcast('routeSaveClicked');
    };
    /**
    * Listener to show error messages for child views
    */
    $scope.$on("displayErrorMessage", function(event, error){
        $scope.errorMessage = error;
        
    });
    
    
	$scope.handleCloseDialog = function(){
		$scope.$emit('HANDLE_MODAL_OPENED');
		$scope.closeDialog();
	};
	
}]);