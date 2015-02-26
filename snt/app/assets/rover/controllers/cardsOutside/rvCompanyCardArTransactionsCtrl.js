
sntRover.controller('RVCompanyCardArTransactionsCtrl', ['$scope', '$rootScope' ,'RVCompanyCardSrv', '$timeout','$stateParams', 'ngDialog', '$state', '$vault', '$window',
	function($scope, $rootScope, RVCompanyCardSrv, $timeout, $stateParams, ngDialog, $state, $vault, $window) {

		BaseCtrl.call(this, $scope);
		$scope.errorMessage = '';
		$scope.setScroller('ar-transaction-list');

		var init = function(){
			$scope.arTransactionDetails = {};
			$scope.arTransactionDetails.ar_transactions = [];
			fetchData();
		};

		// Refresh the scroller when the tab is active.
		$rootScope.$on("arTransactionTabActive", function(event) {
			$timeout(function() {
				$scope.refreshScroller('ar-transaction-list');
			}, 100);
		});

		// Initializing filter data
		$scope.filterData = {
			'id': $scope.contactInformation == undefined? "" :$scope.contactInformation.id,
			'filterActive': false,
			'showFilterFlag': 'OPEN',
			'fromDate': '',
			'toDate': '',
			'textInQueryBox':'',
			'isShowPaid': false,
			'start': 1,
			'pageNo':1,
			'perPage':50,
			'textInQueryBox': '',
			'viewFromOutside': false
		};

		$scope.arTransactionDetails = {
			'available_credit' : parseFloat("0.00").toFixed(2),
			'amount_owing' : parseFloat("0.00").toFixed(2),
			'open_guest_bills' : 0,
			'total_count': 0,
			'ar_transactions':[]
		};

		if(typeof $stateParams.type != 'undefined'){
			$scope.filterData.viewFromOutside = true;
			$scope.filterData.id = ($stateParams.id == 'add')? '': $stateParams.id;
		}
		
		// Get parameters for fetch data
		var getParamsToSend = function(){
			var paramsToSend = {
				"id": $scope.filterData.id,
				"paid" : $scope.filterData.isShowPaid,
				"from_date":$scope.filterData.fromDate,
				"to_date": $scope.filterData.toDate,
				"query": $scope.filterData.textInQueryBox,
				"page_no" : $scope.filterData.pageNo,
				"per_page": $scope.filterData.perPage
			};
			//CICO-10323. for hotels with single digit search, 
			//If it is a numeric query with less than 3 digits, then lets assume it is room serach.
			if($rootScope.isSingleDigitSearch && 
				!isNaN($scope.filterData.textInQueryBox) && 
				$scope.filterData.textInQueryBox.length < 3){
				
				paramsToSend.room_search = true;
			}
			return paramsToSend;
		};

		// To fetch data for ar transactions
		var fetchData = function(clearErrorMsg){
			$scope.arDetailsFetched = false;
			var arAccountsFetchSuccess = function(data) {
				$scope.arDetailsFetched = true;
			    $scope.$emit('hideLoader');
			    
			    if(typeof clearErrorMsg == 'undefined' || clearErrorMsg)
			    	$scope.errorMessage = '';

			    $scope.arTransactionDetails = {};
			    $scope.arTransactionDetails = data;
			    
			    var credits = parseFloat(data.available_credit).toFixed(2);
			    if(credits == '-0.00') credits = parseFloat('0.00').toFixed(2);

			    $scope.arTransactionDetails.available_credit = credits;
			    $scope.arTransactionDetails.amount_owing = parseFloat(data.amount_owing).toFixed(2);
				
				$timeout(function() {
					$scope.refreshScroller('ar-transaction-list');
				}, 100);

				// Compute the start, end and total count parameters
				if($scope.nextAction){
					$scope.filterData.start = $scope.filterData.start + $scope.filterData.perPage ;
				}
				if($scope.prevAction){
					$scope.filterData.start = $scope.filterData.start - $scope.filterData.perPage ;

				}
				$scope.filterData.end = $scope.filterData.start + $scope.arTransactionDetails.ar_transactions.length - 1;
			};

			var failure = function(errorMessage){
			    $scope.$emit('hideLoader');
			    $scope.errorMessage = errorMessage;
			};

			var params = getParamsToSend();

			if(typeof params.id != 'undefined' && params.id != ''){
				$scope.invokeApi(RVCompanyCardSrv.fetchArAccountsList, params, arAccountsFetchSuccess, failure);
			}
		};

		// In the case of new card, handle the generated id upon saving the card.
		$scope.$on("IDGENERATED", function(event,data) {
			$scope.filterData.id = data.id;
			fetchData();
		});


		// To click filter button
		$scope.clickedFilter = function(){
			$scope.filterData.filterActive = !$scope.filterData.filterActive;
			$scope.$emit('ARTransactionSearchFilter', $scope.filterData.filterActive);
		};

		// To handle show filter changes
		$scope.chagedShowFilter = function(){
			if($scope.filterData.showFilterFlag == 'ALL')
				$scope.filterData.isShowPaid = '';
			else
				$scope.filterData.isShowPaid = false;
			initPaginationParams();
			fetchData();
		};

		/* Handling different date picker clicks */
		$scope.clickedFromDate = function(){
			$scope.popupCalendar('FROM');
		};
		$scope.clickedToDate = function(){
			$scope.popupCalendar('TO');
		};
		// Show calendar popup.
		$scope.popupCalendar = function(clickedOn) {
			$scope.clickedOn = clickedOn;
	      	ngDialog.open({
	      		template:'/assets/partials/companyCard/rvCompanyCardContractsCalendar.html',
		        controller: 'RVArTransactionsDatePickerController',
		        className: '',
		        scope: $scope
	      	});
	    };

	    // To handle from date change
	    $scope.$on('fromDateChanged',function(){
	    	initPaginationParams();
	        fetchData();
	    });

		// To handle to date change
	    $scope.$on('toDateChanged',function(){
	    	initPaginationParams();
	        fetchData();
	    });

	    
	    /**
		 * function to perform filtering/request data from service in change event of query box
		 */
		$scope.queryEntered = function() {
			
			var queryText = $scope.filterData.textInQueryBox;
			//setting first letter as captial
			$scope.filterData.textInQueryBox = queryText.charAt(0).toUpperCase() + queryText.slice(1);
			
			initPaginationParams();
			if (queryText.length < 3 && isCharacterWithSingleDigit(queryText)) {
				return false;
			}
			
			fetchData();
		
		}; //end of query entered

		/**
		* Single digit search done based on the settings in admin
		* The single digit search is done only for numeric characters.
		* CICO-10323 
		*/
		function isCharacterWithSingleDigit(searchTerm){
			if($rootScope.isSingleDigitSearch){
				return isNaN(searchTerm);
			} else {
				return true;
			}
		};

		var initPaginationParams = function(){
			$scope.filterData.pageNo = 1;
			$scope.filterData.start = 1;
			$scope.filterData.end = $scope.filterData.start + $scope.arTransactionDetails.ar_transactions.length - 1;
			$scope.nextAction = false;
			$scope.prevAction = false;
		}

		$scope.loadNextSet = function(){
			$scope.filterData.pageNo++;
			$scope.nextAction = true;
			$scope.prevAction = false;
			fetchData();
		};

		$scope.loadPrevSet = function(){
			$scope.filterData.pageNo--;
			$scope.nextAction = false;
			$scope.prevAction = true;
			fetchData();
		};

		$scope.clearSearchField = function(){
			$scope.filterData.textInQueryBox = '';
			initPaginationParams();
			fetchData();
		};

		$scope.clearToDateField = function(){
			$scope.filterData.toDate = '';
			initPaginationParams();
			fetchData();
		};
		$scope.clearFromDateField = function(){
			$scope.filterData.fromDate = '';
			initPaginationParams();
			fetchData();
		};
		$scope.isNextButtonDisabled = function(){
			var isDisabled = false;
			//if($scope.end >= RVSearchSrv.totalSearchResults || $scope.disableNextButton){
			if(typeof $scope.arTransactionDetails == "undefined")
				return true;
			if($scope.filterData.end >= $scope.arTransactionDetails.total_count){
				isDisabled = true;
			}
			return isDisabled;
		};

		$scope.isPrevButtonDisabled = function(){
			var isDisabled = false;
			if($scope.filterData.pageNo == 1){
				isDisabled = true;
			}
			return isDisabled;

		};

		/*
		 * Function to handle paid/open toggle button click.
		 */
		$scope.toggleTransaction = function(index){
	    	$scope.arTransactionDetails.ar_transactions[index].paid = !$scope.arTransactionDetails.ar_transactions[index].paid;
	    	
	    	var transactionSuccess = function(data) {
	            $scope.$emit('hideLoader');
	            $scope.errorMessage = '';

	            var credits = parseFloat(data.available_credits).toFixed(2);
			    if(credits == '-0.00') credits = parseFloat('0.00').toFixed(2);

	            $scope.arTransactionDetails.available_credit = credits;
	            $scope.arTransactionDetails.open_guest_bills = data.open_guest_bills;

	            if($scope.filterData.showFilterFlag == 'OPEN' && $scope.arTransactionDetails.ar_transactions[index].paid){
	            	$scope.arTransactionDetails.total_count--;
	            }
	            if($scope.filterData.showFilterFlag == 'OPEN' && !$scope.arTransactionDetails.ar_transactions[index].paid){
	            	$scope.arTransactionDetails.total_count++;
	            }
	        };

	        var failure = function(errorMessage){
	            $scope.$emit('hideLoader');
	            $scope.errorMessage = errorMessage;
	            $scope.arTransactionDetails.ar_transactions[index].paid = !$scope.arTransactionDetails.ar_transactions[index].paid;
	        };
	        
	        var params = {
	            'id': $scope.filterData.id,
	            'transaction_id': $scope.arTransactionDetails.ar_transactions[index].transaction_id
	        };

	        if($scope.arTransactionDetails.ar_transactions[index].paid){
	        	// To pay API call
	        	$scope.invokeApi(RVCompanyCardSrv.payForReservation, params, transactionSuccess ,failure);
	    	}
	    	else{
	    		// To Open Api call
	    		$scope.invokeApi(RVCompanyCardSrv.openForReservation, params, transactionSuccess ,failure);
	    	}
	    };

		/*
		 * function to execute on clicking on each result
		 */
		$scope.goToReservationDetails = function(index, $event) {

			var element = $event.target;

			if(element.className =='switch-button' || element.className =='switch-button on' || element.parentNode.className =='switch-button' || element.parentNode.className =='switch-button on'){
				$scope.toggleTransaction(index);
			}
			else if($scope.filterData.viewFromOutside){
				$vault.set('cardId', $stateParams.id);
				$vault.set('type', $stateParams.type);
				$vault.set('query', $stateParams.query);

				$state.go("rover.reservation.staycard.reservationcard.reservationdetails", {
					id: $scope.arTransactionDetails.ar_transactions[index].reservation_id,
					confirmationId: $scope.arTransactionDetails.ar_transactions[index].reservation_confirm_no,
					isrefresh: true,
					isFromCards: true
				});
			}
		};

		// clicked pay all button
	    $scope.clickedPayAll = function(){

	        var payAllSuccess = function(data) {
	            $scope.$emit('hideLoader');
	           
	            if(data.errors.length > 0){
	                $scope.errorMessage = [data.errors[0]];
	            }
	            else{
	                $scope.errorMessage = "";
	            }
	            var clearErrorMsg = false;
	            fetchData(clearErrorMsg);
	        };

	        var failure = function(errorMessage){
	            $scope.$emit('hideLoader');
	            $scope.errorMessage = errorMessage;
	        };

	        var params = {
	            'id':$scope.filterData.id
	        };
	        $scope.invokeApi(RVCompanyCardSrv.payAll, params, payAllSuccess, failure);
	    };

	    // Show add credits amount popup
		$scope.addCreditAmount = function(){
			ngDialog.open({
	      		template:'/assets/partials/companyCard/rvArTransactionsAddCredits.html',
		        controller: 'RVArTransactionsAddCreditsController',
		        className: '',
		        scope: $scope
	      	});
		};

		$scope.getTimeConverted = function(time){
			if(time == null || time == undefined){
				return "";
			}
			var timeDict = tConvert(time);
			return (timeDict.hh + ":" + timeDict.mm + " " + timeDict.ampm);
		};

	    init();

	    // To print the current screen details.
	    $scope.clickedPrintButton = function(){
			
			// CICO-11667 to enable landscpe printing on transactions page.
			// Sorry , we have to access the DOM , so using jQuery..
			$("body").prepend("<style id='paper-orientation'>@page { size: landscape; }</style>");
			
			/*
			 *	=====[ READY TO PRINT ]=====
			 */
			// this will show the popup
		    $timeout(function() {
		    	/*
		    	 *	=====[ PRINTING!! JS EXECUTION IS PAUSED ]=====
		    	 */

		        $window.print();

		        if ( sntapp.cordovaLoaded ) {
		            cordova.exec(function(success) {}, function(error) {}, 'RVCardPlugin', 'printWebView', []);
		        };

		        // Removing the style after print.
		        $("#paper-orientation").remove();

		    }, 100);

		    /*
		     *	=====[ PRINTING COMPLETE. JS EXECUTION WILL COMMENCE ]=====
		     */

	    };

}]);
