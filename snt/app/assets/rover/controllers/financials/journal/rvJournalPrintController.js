sntRover.controller('RVJournalPrintController', ['$scope','$rootScope','$timeout','$window',function($scope,$rootScope,$timeout,$window) {
	BaseCtrl.call(this, $scope);

	/** Code for PRINT BOX drawer common Resize Handler starts here .. **/
	var resizableMinHeight = 0;
	var resizableMaxHeight = 90;
	$scope.eventTimestamp = '';
	$scope.data.printBoxHeight = resizableMinHeight;
	// Drawer resize options.
	$scope.resizableOptions = {
		minHeight: resizableMinHeight,
		maxHeight: resizableMaxHeight,
		handles: 's',
		resize: function(event, ui) {
			var height = $(this).height();
			if (height > 5){
				$scope.data.isDrawerOpened = true;
				$scope.data.printBoxHeight = height;
			}
			else if(height < 5){
				$scope.closeDrawer();
			}
		},
		stop: function(event, ui) {
			preventClicking = true;
			$scope.eventTimestamp = event.timeStamp;
		}
	};
	
	// To handle click on drawer handle - open/close.
	$scope.clickedDrawer = function($event){
		$event.stopPropagation();
		$event.stopImmediatePropagation();
		if(getParentWithSelector($event, document.getElementsByClassName("ui-resizable-handle")[0])){
			if(parseInt($scope.eventTimestamp)) {
				if(($event.timeStamp - $scope.eventTimestamp)<2){
					return;
				}
			}
			if($scope.data.printBoxHeight == resizableMinHeight || $scope.data.printBoxHeight == resizableMaxHeight) {
				if ($scope.data.isDrawerOpened)	$scope.closeDrawer();
				else $scope.openDrawer();
			}
			else{
				// mid way click : close guest card
				$scope.closeDrawer();
			}
		}
	};

	// To open the Drawer
	$scope.openDrawer = function(){
		$scope.data.printBoxHeight = resizableMaxHeight;
		$scope.data.isDrawerOpened = true;
	};

	// To close the Drawer
	$scope.closeDrawer = function(){
		$scope.data.printBoxHeight = resizableMinHeight;
		$scope.data.isDrawerOpened = false;
	};

	$scope.$on("CLOSEPRINTBOX",function(){
		$scope.closeDrawer();
	});

	/** Code for Resize Handler ends here ..  **/

	/** Code for Revenue Tab - PRINT BOX - filters  starts here .. **/

	// On changing charge group on PRINT filter
	$scope.chargeGroupChanged = function(){
		
		$scope.data.activeChargeCodes = [];

		angular.forEach($scope.data.revenueData.charge_groups,function(charge_groups, index1) {
			
			if((charge_groups.id == $scope.data.selectedChargeGroup) || ($scope.data.selectedChargeGroup == 'ALL')){
				
				if(charge_groups.show){

					charge_groups.show = true;
					charge_groups.filterFlag = true;
					
					angular.forEach(charge_groups.charge_codes,function(charge_codes, index2) {
						if(charge_codes.show){
							charge_codes.filterFlag = true;

							if($scope.data.selectedChargeGroup !== 'ALL'){
								var obj = { "id": charge_codes.id , "name": charge_codes.name };
			       				$scope.data.activeChargeCodes.push(obj);
			       			}
	       				}
					});
				}
				else{
					charge_groups.filterFlag = false;
				}
			}
			else{
				charge_groups.filterFlag = false;
			}
       	});
       	$scope.data.selectedChargeCode = 'ALL';
	};

	// On changing charge code on PRINT filter
	$scope.chargeCodeChanged = function(){

		angular.forEach($scope.data.revenueData.charge_groups,function(charge_groups, index1) {

			angular.forEach(charge_groups.charge_codes,function(charge_codes, index2) {

				if((charge_codes.id == $scope.data.selectedChargeCode) || ($scope.data.selectedChargeCode == 'ALL')){

					if(charge_codes.show) {
						charge_codes.filterFlag = true;
						charge_groups.active = true;
					}
					else{
						charge_codes.filterFlag = false;
					}
				}
				else{
					charge_codes.filterFlag = false;
				}
			});
       	});
	};

	$scope.toggleRevenueTransactions = function(){
		if($scope.data.isRevenueToggleSummaryActive)
			$scope.showRevenueDetailView(false);
		else
			$scope.showRevenueDetailView(true);
	};

	// To handle Summary/Details toggle button click - REVENUE
	$scope.toggleSummaryOrDeatilsRevenue = function(){
		$rootScope.$broadcast('REFRESHREVENUECONTENT');
		$scope.data.isRevenueToggleSummaryActive = !$scope.data.isRevenueToggleSummaryActive;
		$scope.toggleRevenueTransactions();
	};

	$scope.togglePaymentTransactions = function(){
		if($scope.data.isPaymentToggleSummaryActive)
			$scope.showPaymentDetailView(false);
		else
			$scope.showPaymentDetailView(true);
	};

	// To handle Summary/Details toggle button click - PAYMENT
	$scope.toggleSummaryOrDeatilsPayment = function(){
		$rootScope.$broadcast('REFRESHPAYMENTCONTENT');
		$scope.data.isPaymentToggleSummaryActive = !$scope.data.isPaymentToggleSummaryActive;
		$scope.togglePaymentTransactions();
	};

	/*
     *	To handle Summary/Details view for Revenue filter.
	 */
	$scope.showRevenueDetailView = function(isDetailView){
		
		angular.forEach($scope.data.revenueData.charge_groups,function(charge_groups, index1) {
			
            angular.forEach(charge_groups.charge_codes,function(charge_codes, index2) {
            	
            	if(isDetailView && charge_codes.filterFlag){
            		//Expanding Level1 and Level2 to show detailed view.
            		charge_groups.active = true;
            		// If charge code is having items inside, expand it.
            		if(charge_codes.transactions.length > 0) charge_codes.active = true;
            	}
            	else if(!isDetailView){
            		charge_groups.active =  false;
            	 	charge_codes.active = false;
            	}
            });
        });
	};

	/** Code for Revenue Tab - PRINT BOX - filters ends here ..   **/

	/** Code for Payment Tab - PRINT BOX - filters starts here .. **/
	$scope.paymentTypeChanged = function(){

		angular.forEach($scope.data.paymentData.payment_types,function(payment_types, index1) {

			if((payment_types.id == $scope.data.selectedPaymentType) && (payment_types.payment_type == "Credit Card")) {
				
				if(payment_types.show){
					payment_types.filterFlag = true;
					
					angular.forEach(payment_types.credit_cards,function(credit_cards, index2) {
						if(credit_cards.show){
							credit_cards.filterFlag = true;
						}
						$scope.togglePaymentTransactions();
					});
				}
				else{
					payment_types.filterFlag = false;
				}
	        }
	        else if((payment_types.id == $scope.data.selectedPaymentType) || ($scope.data.selectedPaymentType == 'ALL')){
	        	
	        	payment_types.filterFlag = true;
	        	$scope.togglePaymentTransactions();
	        }
	        else{
	        	payment_types.filterFlag = false;
	        }
        });
	};

	/*
     *	To handle Summary/Details view for Payments filter.
	 */
	$scope.showPaymentDetailView = function(isDetailView){
		
		angular.forEach($scope.data.paymentData.payment_types,function(payment_types, index1) {

			if(payment_types.payment_type == "Credit Card"){
	            angular.forEach(payment_types.credit_cards,function(credit_cards, index2) {
	            	
	            	if(isDetailView && credit_cards.filterFlag){
	            		// Expanding Level1 and Level2 to show detailed view for Credit Cards.
	            		payment_types.active = true;
	            		// If cards having data inside , expand it.
	            		if(credit_cards.transactions.length >0) credit_cards.active = true;
	            	}
	            	else if(!isDetailView){
	            		payment_types.active = false;
	            		credit_cards.active = false;
	            	}
	            });
        	}
        	else{
        		if(isDetailView && payment_types.transactions.length >0){
        			payment_types.active = true;
        		}
        		else if(!isDetailView){
        			payment_types.active = false;
        		}
        	}
        });
	};

	/** Code for Payment Tab - PRINT BOX - filters ends here .. **/


	/** PRINT Functionality **/

	$scope.printRevenue = function(){
		printJournal();
	};

	$scope.printPayment = function(){
		printJournal();
	};

	$scope.printCashier = function(){
		printJournal();
	};

	// print the journal page
	var printJournal = function() {
		
		/*
		 *	=====[ READY TO PRINT ]=====
		 */
		// this will show the popup with full bill
	    $timeout(function() {
	    	/*
	    	 *	=====[ PRINTING!! JS EXECUTION IS PAUSED ]=====
	    	 */

	        $window.print();

	        if ( sntapp.cordovaLoaded ) {
	            cordova.exec(function(success) {}, function(error) {}, 'RVCardPlugin', 'printWebView', []);
	        };
	    }, 100);

	    /*
	     *	=====[ PRINTING COMPLETE. JS EXECUTION WILL COMMENCE ]=====
	     */
	};

}]);