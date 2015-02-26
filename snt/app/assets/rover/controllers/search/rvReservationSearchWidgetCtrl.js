sntRover.controller('rvReservationSearchWidgetController', ['$scope', '$rootScope', 'RVSearchSrv', '$filter', '$state', '$stateParams', '$vault', 'ngDialog', '$timeout',
	function($scope, $rootScope, RVSearchSrv, $filter, $state, $stateParams, $vault, ngDialog, $timeout) {

		/*
		 * Base reservation search, will extend in some place
		 * it contain only minimal function, please add functions & methods where
		 * you wrapping this.
		 */
		var that = this;
		BaseCtrl.call(this, $scope);
		var searchFilteringCall = null;
		//model against query textbox, we will be using this across
		$scope.textInQueryBox = "";
		$scope.fetchTerm = "";

		// variable used track the & type if pre-loaded search results (nhouse, checkingin..)
		$scope.searchType = "default";

		// these varibales will be used to various conditiopns for ui rendering
		$scope.isLateCheckoutList = false;
		$scope.isQueueReservationList = false;
		$scope.swipeNoResults = false;
		//$scope.disableNextButton = false;

		//showSearchResultsAre
		$scope.showSearchResultsArea = false;
		$scope.searchResultsFetchDone = false;
		$scope.searchAreaIsHiding = false;
		$scope.searchAreaIsOpening = false;
		$scope.totalSearchResults = RVSearchSrv.totalSearchResults;
		$scope.searchPerPage = RVSearchSrv.searchPerPage;
		$scope.reservationSearch = ($state.current.name == "rover.search");
		$scope.search_area_id = !$scope.reservationSearch ? "dashboard-search": "search";
		//Date picker from date should default to current business date - CICO-8490
		//Get the date stored in service, and clear the service
		$scope.fromDate = RVSearchSrv.fromDate == undefined ? $rootScope.businessDate : RVSearchSrv.fromDate;
		$scope.toDate = RVSearchSrv.toDate == undefined ? "" : RVSearchSrv.toDate;
		RVSearchSrv.fromDate = $rootScope.businessDate;
		RVSearchSrv.toDate = '';

		//RVSearchSrv.fromDate = $rootScope.businessDate;

		$scope.start = 1;
		$scope.end = RVSearchSrv.searchPerPage;

		//results
		$scope.results = [];

		//prevent unwanted result whoing while typeing
		$scope.isTyping = false;
		$scope.isSwiped = false;
		$scope.firstSearch = true;

		$scope.showAddNewGuestButton = false; //read cooment below :(
		/**
		 *	should we show ADD Guest Button
		 *	we can determine this from wrapper class
		 *	will be helpful if the requirement changed from only for stand alone pms to other
		 * 	and also also we can handle it inside
		 */
		$scope.$on("showAddNewGuestButton", function(event, showAddNewGuestButton) {
			$scope.showAddNewGuestButton = showAddNewGuestButton;
		});

		//setting the scroller for view
		var scrollerOptions = {
			tap: true,
			preventDefault: false,
			deceleration: 0.0001,
			shrinkScrollbars: 'clip'
		};
		$scope.setScroller('result_showing_area', scrollerOptions);

		// if returning back and there was a search query typed in restore that
		// else reset the query value in vault
		if ($stateParams.useCache && !!$vault.get('searchQuery')) {
			$scope.textInQueryBox = $vault.get('searchQuery');
		} else {
			$vault.set('searchQuery', '');
		}

		if ($stateParams.type == "LATE_CHECKOUT") {
			$scope.isLateCheckoutList = true;
		} else {
			$scope.isLateCheckoutList = false;
		}
		if ($stateParams.type == "QUEUED_ROOMS") {
			$scope.isQueueReservationList = true;
		} else {
			$scope.isQueueReservationList = false;
		}

		// dont remove yet
		// setting up back to dashboard
		// this must be set only for switching b/w
		// dashboard and search results by clicking the search in dashboard
		// if ( !$stateParams.hasOwnProperty('type') ) {
		// 	$rootScope.setPrevState = {
		// 		title: $filter('translate')('DASHBOARD'),
		// 		callback: 'clearResults',
		// 		scope: $scope,
		// 		noStateChange: true,
		// 		hide: true
		// 	};
		// }

		/**
		 * Event propogated by ngrepeatstart directive
		 * we used to show activity indicator
		 */
		$scope.$on('NG_REPEAT_STARTED_RENDERING', function(event) {
			$scope.$emit('showLoader');
		});


		/**
		 * Event propogated by ngrepeatend directive
		 * we used to hide activity indicator & refresh scroller
		 */
		$scope.$on('NG_REPEAT_COMPLETED_RENDERING', function(event) {
			setTimeout(function() {
				refreshScroller();
			}, 100);
			$scope.$emit('hideLoader');
		});


		/**
		 * Success call back of data fetch from webservice
		 */
		var successCallBackofDataFetch = function(data) {
			$scope.$emit('hideLoader');
			$scope.results = data;
			//TODO: commenting out for now. See if this has to be restored
			//$scope.firstSearch = false;
			$scope.searchType = "default";
			$scope.isTyping = false;
			$scope.searchResultsFetchDone = true;

			if ($scope.results.length > 0) { //if there is any result then only we want to filter
				applyFilters();
			}

			// Compute the start, end and total count parameters
			if ($scope.nextAction) {
				$scope.start = $scope.start + $scope.searchPerPage;
			}
			if ($scope.prevAction) {
				$scope.start = $scope.start - $scope.searchPerPage;

			}
			$scope.totalSearchResults = RVSearchSrv.totalSearchResults
			$scope.end = $scope.start + $scope.results.length - 1;
			setTimeout(function() {
				$scope.$apply();
				$scope.$parent.myScroll['result_showing_area'].scrollTo(0, 0, 0);
				refreshScroller();
			}, 100);
		};


		/**
		 * failure call back of search result fetch
		 */
		var failureCallBackofDataFetch = function(errorMessage) {
			$scope.$emit('hideLoader');
			$scope.searchType = "default";
			$scope.errorMessage = errorMessage;
			$scope.searchResultsFetchDone = true;
			setTimeout(function() {
				refreshScroller();
				$scope.$apply(function() {
					$scope.isTyping = false;
				});
			}, 100);
		};

		/**
		 * a reciever function to update data from outside
		 */
		$scope.$on("updateDataFromOutside", function(event, data) {
			$scope.disableNextButton = false;
			$scope.results = data;

			$scope.start = ((RVSearchSrv.page - 1) * RVSearchSrv.searchPerPage) + $scope.start;
			$scope.end = $scope.start + $scope.results.length - 1;
			refreshScroller();
			$scope.$emit('hideLoader');
		});

		/**
		 * a reciever function to update data from outside
		 */
		$scope.$on("updateReservationTypeFromOutside", function(event, type) {
			$scope.searchType = type;
			$scope.isLateCheckoutList = (type === 'LATE_CHECKOUT') ? true : false;
		});

		//
		$scope.$on("clearSearchDateValues", function(event, flag) {
			$scope.$apply(function() {
				$scope.fromDate = $rootScope.businessDate;
				$scope.toDate = '';
			});
			//RVSearchSrv.fromDate = $rootScope.businessDate;
			RVSearchSrv.toDate = '';

		});

		/**
		 * reciever function to show/hide the search result area.
		 */
		$scope.$on("showSearchResultsArea", function(event, searchAreaVisibilityStatus) {
			

			// if it is hiding, we need to clear the search text
			if (!searchAreaVisibilityStatus) {				
				$scope.textInQueryBox = '';
				$vault.set('searchQuery', '');
				// hide the dashboard back button (dont remove yet)
				// $rootScope.setPrevState.hide = true;				
				if (!$scope.reservationSearch) {
					$scope.searchAreaIsHiding = true;					
					$timeout(function() {
						$scope.searchAreaIsHiding = false;
						$scope.searchAreaIsOpening = false;
						$scope.showSearchResultsArea = searchAreaVisibilityStatus;
					}, 400)					
				}
				else {
					$scope.searchAreaIsHiding = false;
					$scope.searchAreaIsOpening = false;
					$scope.showSearchResultsArea = searchAreaVisibilityStatus;
				}

			} else {
				$scope.showSearchResultsArea = searchAreaVisibilityStatus;
				if (!$scope.reservationSearch) {
					$scope.searchAreaIsOpening = true;
				}
				// show the dashboard back button (dont remove yet)
				// $rootScope.setPrevState.hide = false;
			}

		});

		/**
		 * function to perform filtering/request data from service in change event of query box
		 */
		$scope.queryEntered = function() {
			$scope.isSwiped = false;
			$scope.swipeNoResults = false;
			$scope.isLateCheckoutList = false;
			$scope.isQueueReservationList = false;
			var queryText = $scope.textInQueryBox;

			$scope.$emit("UPDATE_MANAGER_DASHBOARD");
			//inoreder to prevent unwanted results showing while tyeping..
			if (!$scope.isTyping) {
				$scope.isTyping = true;
			}

			//setting first letter as captial: soumya
			$scope.textInQueryBox = queryText.charAt(0).toUpperCase() + queryText.slice(1);

			if ($scope.textInQueryBox.length == 0 && $scope.searchType == "default") {
				$scope.clearResults();
				return;
			}
			if (!$scope.showSearchResultsArea) {
				$scope.showSearchResultsArea = true;
			}
			if (searchFilteringCall != null) {
				clearTimeout(searchFilteringCall);
			}
			searchFilteringCall = setTimeout(function() {
				$scope.$apply(function() {
					displayFilteredResults();
				});
			}, 800);


			// save the entered query into vault
			// if returning back we will display that result
			$vault.set('searchQuery', $scope.textInQueryBox);
			$scope.$emit("UpdateHeading", 'SEARCH_NORMAL');
			return true;
		}; //end of query entered

		/**
		 * fnction to execute on focused out event of search textbox is using that feature in dahbaord
		 */
		$scope.focusedOutOfSearchText = function(event) {
			if ($scope.results.length === 0 && $scope.textInQueryBox === '') {
				setTimeout(function() {
					$scope.$emit("SEARCH_BOX_FOCUSED_OUT");
				}, 50);

			}
		};

		$scope.searchAreaClicked = function($event) {
			$event.stopPropagation();
			return false;
		}

		var applyFilters = function(isLocalFiltering) {
			var value = "";
			//searching in the data we have, we are using a variable 'visibleElementsCount' to track matching
			//if it is zero, then we will request for webservice
			var totalCountOfFound = 0;
			for (var i = 0; i < $scope.results.length; i++) {
				value = $scope.results[i];
				if (($scope.escapeNull(value.firstname).toUpperCase()).indexOf($scope.textInQueryBox.toUpperCase()) >= 0 ||
					($scope.escapeNull(value.lastname).toUpperCase()).indexOf($scope.textInQueryBox.toUpperCase()) >= 0 ||
					($scope.escapeNull(value.group).toUpperCase()).indexOf($scope.textInQueryBox.toUpperCase()) >= 0 ||
					($scope.escapeNull(value.room).toString()).indexOf($scope.textInQueryBox) >= 0 ||
					($scope.escapeNull(value.confirmation).toString()).indexOf($scope.textInQueryBox.toUpperCase()) >= 0 ||
					($scope.escapeNull(value.travel_agent).toUpperCase()).indexOf($scope.textInQueryBox.toUpperCase()) >= 0 ||
					($scope.escapeNull(value.company).toUpperCase()).indexOf($scope.textInQueryBox.toUpperCase()) >= 0) {
					$scope.results[i].is_row_visible = true;
					totalCountOfFound++;
				} else {
					$scope.results[i].is_row_visible = false;
				}
			}
			/*if(isLocalFiltering){
				$scope.start = 1;
				$scope.end = totalCountOfFound;
				$scope.totalSearchResults = totalCountOfFound;
				$scope.disableNextButton = true;//TODO: workaround
			}*/

			$scope.isTyping = false;
		};
		/**
		 * Single digit search done based on the settings in admin
		 * The single digit search is done only for numeric characters.
		 * CICO-10323
		 */
		function isSearchOnSingleDigit(searchTerm) {
			if ($rootScope.isSingleDigitSearch) {
				return isNaN(searchTerm);
			} else {
				return true;
			}
		};

		/**
		 * function to perform filering on results.
		 * if not fouund in the data, it will request for webservice
		 */
		var displayFilteredResults = function() {

			//show everything, means no filtering    
			if ($scope.textInQueryBox.length < 3 && isSearchOnSingleDigit($scope.textInQueryBox)) {
				//based on 'is_row_visible' parameter we are showing the data in the template      
				for (var i = 0; i < $scope.results.length; i++) {
					$scope.results[i].is_row_visible = true;
				}
				setTimeout(function() {
					$scope.isTyping = false;
				}, 500);
				refreshScroller();
			} else {

				if ($rootScope.isSingleDigitSearch && !isNaN($scope.textInQueryBox) && $scope.textInQueryBox.length === 3) {
					$scope.fetchSearchResults();
					return false;
				}

				//see if the new query is the substring of fetch term & the fetched results count < per_page param(which is set to be 100 now)
				//If so we will do local filtering
				if ($scope.searchType == "default" && $scope.textInQueryBox.indexOf($scope.fetchTerm) == 0 && !$scope.firstSearch && $scope.results.length > 0 && RVSearchSrv.totalSearchResults <= $scope.searchPerPage) {

					//RVSearchSrv.page = 1;
					//var isLocalFiltering = true;
					//applyFilters(isLocalFilte	`ring);
					applyFilters();

				} else {
					initPaginationParams();
					$scope.fetchSearchResults();
				}
				// we have changed data, so we are refreshing the scrollerbar
				refreshScroller();
			}
		}; //end of displayFilteredResults

		$scope.fetchSearchResults = function() {
			var query = $scope.textInQueryBox.trim();
			if ($scope.escapeNull(query) == "" && $scope.escapeNull($stateParams.type) == "") {
				return false;
			}
			var dataDict = {};

			if (query != '') {
				dataDict.query = query;
			}

			if ($stateParams.type == "LATE_CHECKOUT") {
				dataDict.is_late_checkout_only = true;
			} else if ($stateParams.type == "QUEUED_ROOMS") {
				dataDict.is_queued_rooms_only = true;
			} else if ($stateParams.type == "VIP") {
				dataDict.vip = true;
			} else if ($stateParams.type != undefined && query == '' && $stateParams.type !== 'SEARCH_NORMAL') {
				dataDict.status = $stateParams.type;
			}
			//CICO-10323. for hotels with single digit search, 
			//If it is a numeric query with less than 3 digits, then lets assume it is room serach.
			if ($rootScope.isSingleDigitSearch && !isNaN(query) && query.length < 3) {
				dataDict.room_search = true;
			}
			dataDict.from_date = $scope.fromDate;
			dataDict.to_date = $scope.toDate;

			$scope.firstSearch = false;
			$scope.fetchTerm = $scope.textInQueryBox;
			$scope.searchResultsFetchDone = false;


			$scope.invokeApi(RVSearchSrv.fetch, dataDict, successCallBackofDataFetch, failureCallBackofDataFetch);

		};

		/**
		 * function to execute on focusing on search box
		 */
		$scope.focusOnSearchText = function() {
			//we are showing the search area
            $scope.focusSearchField = false;
			$scope.$emit("showSearchResultsArea", true);
			$scope.$emit("UpdateHeading", 'SEARCH_NORMAL');
			$vault.set('searchType', 'SEARCH_NORMAL')
			refreshScroller();
		};


		/**
		 * function used for refreshing the scroller
		 */
		var refreshScroller = function() {
			$scope.refreshScroller('result_showing_area');
		};

		$scope.getGuestStatusIconForArrival = function(reservationStatus, isLateCheckoutOn, isPrecheckin) {
			var viewStatus = "";
			if ("RESERVED" == reservationStatus || "CHECKEDOUT" == reservationStatus) {
				viewStatus = "arrival";
			} else if (("NOSHOW" == reservationStatus) || ("NOSHOW_CURRENT" == reservationStatus)) {
				viewStatus = "no-show";
			} else if ("CANCELED" == reservationStatus) {
				viewStatus = "cancel";
			}

			return viewStatus;

		};

		$scope.getGuestStatusIconForDeparture = function(reservationStatus, isLateCheckoutOn, isPrecheckin) {
				if ("RESERVED" == reservationStatus || "CHECKEDOUT" == reservationStatus) {
					viewStatus = "departed";
				} else if (("NOSHOW" == reservationStatus) || ("NOSHOW_CURRENT" == reservationStatus)) {
					viewStatus = "no-show";
				} else if ("CANCELED" == reservationStatus) {
					viewStatus = "cancel";
				}

				return viewStatus;
			}
			/*
			 * function used in template to map the reservation status to the view expected format
			 */
		$scope.getGuestStatusMapped = function(reservationStatus, isLateCheckoutOn, isPrecheckin) {
			var viewStatus = "";
			if (isLateCheckoutOn && "CHECKING_OUT" == reservationStatus) {
				viewStatus = "late-check-out";
				return viewStatus;
			}
			if ("RESERVED" == reservationStatus && !isPrecheckin) {
				viewStatus = "arrival";
			} else if ("CHECKING_IN" == reservationStatus && !isPrecheckin) {
				viewStatus = "check-in";
			} else if ("CHECKEDIN" == reservationStatus) {
				viewStatus = "inhouse";
			} else if ("CHECKEDOUT" == reservationStatus) {
				viewStatus = "departed";
			} else if ("CHECKING_OUT" == reservationStatus) {
				viewStatus = "check-out";
			} else if ("CANCELED" == reservationStatus) {
				viewStatus = "cancel";
			} else if (("NOSHOW" == reservationStatus) || ("NOSHOW_CURRENT" == reservationStatus)) {
				viewStatus = "no-show";
			} else if (isPrecheckin) {
				viewStatus = "pre-check-in";
			}
			return viewStatus;
		};

		//Map the room status to the view expected format
		$scope.getRoomStatusMapped = function(roomstatus, fostatus) {
			var mappedStatus = "";
			if (roomstatus == "READY" && fostatus == "VACANT") {
				mappedStatus = 'ready';
			} else {
				mappedStatus = "not-ready";
			}
			return mappedStatus;
		};

		//function that converts a null value to a desired string.

		//if no replace value is passed, it returns an empty string

		$scope.escapeNull = function(value, replaceWith) {
			var newValue = "";
			if ((typeof replaceWith != "undefined") && (replaceWith != null)) {
				newValue = replaceWith;
			}
			var valueToReturn = ((value == null || typeof value == 'undefined') ? newValue : value);
			return valueToReturn;
		};

		/*
		 * function to get reservation class against reservation status
		 */
		$scope.getReservationClass = function(reservationStatus) {
			var classes = {
				"CHECKING_IN": 'guest-check-in',
				"CHECKEDIN": 'guest-inhouse',
				"CHECKING_OUT": 'guest-check-out',
				"CANCELED": 'guest-cancel',
				"NOSHOW": 'guest-no-show',
				"NOSHOW_CURRENT": 'guest-no-show',
			};
			if (reservationStatus.toUpperCase() in classes) {
				return classes[reservationStatus.toUpperCase()];
			}
		};
		/**
		 * function to execute on clicking clear icon button
		 */
		$scope.clearResults = function() {
			$scope.results = [];
			$scope.textInQueryBox = "";
			$scope.fetchTerm = "";
			$scope.firstSearch = true;

			RVSearchSrv.totalSearchResults = 0;

			//Clear search fields
			$scope.fromDate = $rootScope.businessDate;
			$scope.toDate = "";
			//$scope.start = 1;
			//$scope.end = 100;

			$scope.$emit("SearchResultsCleared");
			setTimeout(function() {
				refreshScroller();
			}, 100);

			// dont remove yet
			// Gotacha!! Only when we are dealing with 'noStateChange'
			// if ( !!$rootScope.setPrevState.noStateChange ) {
			//     $rootScope.setPrevState.hide = true;
			// };

			// reset the query saved into vault
			$vault.set('searchQuery', '');
		};

		/**
		 * function to execute on clicking on each result
		 */
		$scope.goToReservationDetails = function($event,reservationID, confirmationID) {
			
			$event.preventDefault();
			$event.stopImmediatePropagation();
  			$event.stopPropagation();

			$scope.currentReservationID = reservationID;
			$scope.currentConfirmationID = confirmationID;
			RVSearchSrv.data = $scope.results;
			RVSearchSrv.fromDate = $scope.fromDate;
			RVSearchSrv.toDate = $scope.toDate;


			//$scope.$emit("UpdateSearchBackbuttonCaption", "");
			$state.go("rover.reservation.staycard.reservationcard.reservationdetails", {
				id: reservationID,
				confirmationId: confirmationID,
				isrefresh: true
			});
		};

		//Relaunch the reservation details screen when the ows connection retry succeeds
		$scope.$on('OWSConnectionRetrySuccesss', function(event) {
			$scope.goToReservationDetails($scope.currentReservationID, $scope.currentConfirmationID);
		});

		$scope.searchSwipeSuccessCallback = function(searchByCCResults) {

			// show back to dashboard button (dont remove yet)
			// $rootScope.setPrevState.hide = false;
			$scope.$emit('hideLoader');
			$scope.isSwiped = true;
			data = searchByCCResults;
			if (data.length == 0) {
				$scope.$emit("updateDataFromOutside", data);
				$scope.swipeNoResults = true;
				$scope.focusOnSearchText();
			} else if (data.length == 1) {
				var reservationID = data[0].id;
				var confirmationID = data[0].confirmation;
				$scope.goToReservationDetails(reservationID, confirmationID);
			} else {
				$scope.$emit("updateDataFromOutside", data);
				$scope.focusOnSearchText();
			}

			//Set the search type and search title. Used in back navigation from staycard to search
			$vault.set('searchType', "BY_SWIPE");
			$vault.set('title', swipeHeadingInSearch);

			$scope.$emit("UpdateHeading", swipeHeadingInSearch);
		};
		var swipeHeadingInSearch = '';
		$scope.$on('SWIPE_ACTION', function(event, data) {
			var ksn = data.RVCardReadTrack2KSN;
			if (data.RVCardReadETBKSN != "" && typeof data.RVCardReadETBKSN != "undefined") {
				ksn = data.RVCardReadETBKSN;
			}
			var cardNumber = data.RVCardReadMaskedPAN.substr(data.RVCardReadMaskedPAN.length - 4);
			swipeHeadingInSearch = 'Reservations with card ' + cardNumber;

			var swipeData = {
				'et2': data.RVCardReadTrack2,
				'ksn': ksn,
				'etb': data.RVCardReadETB

			};

			swipeData.is_encrypted = true;
			if(data.RVCardReadIsEncrypted == 0){
				swipeData.is_encrypted = false;
			}

			$scope.invokeApi(RVSearchSrv.searchByCC, swipeData, $scope.searchSwipeSuccessCallback);


		});

		$scope.showNoMatches = function(results, queryLength, isTyping, isSwiped) {
			var showNoMatchesMessage = false;
			var resultLength = results.length;
			if (!$scope.swipeNoResults) {
				if (isSwiped && resultLength == 0) {
					showNoMatchesMessage = true;
				} else {
					if ($scope.searchResultsFetchDone && resultLength == 0 && queryLength >= 3 && !isTyping) {
						showNoMatchesMessage = true;
					}
				}
			}
			if (!showNoMatchesMessage && resultLength > 0) {
				//TODO: verify which condition check to chose
				//if(!showNoMatchesMessage && !$scope.firstSearch){
				var totalCountOfFound = 0;
				for (var i = 0; i < results.length; i++) {
					if (results[i].is_row_visible)
						totalCountOfFound++;
				}
				if (totalCountOfFound == 0)
					showNoMatchesMessage = true;
			}
			return showNoMatchesMessage;
		};
		$scope.isReservationQueued = function(isReservationQueued, isQueueRoomsOn, reservationStatus) {
			var isQueued = false;
			if (reservationStatus === 'CHECKING_IN' || reservationStatus === 'RESERVED') {
				if (isReservationQueued == "true" && isQueueRoomsOn == "true") {
					isQueued = true;
				}
			}
			return isQueued;
		};


		$scope.getMappedClassWithResStatusAndRoomStatus = function(reservation_status, roomstatus, fostatus, roomReadyStatus, checkinInspectedOnly, serviceStatus) {
			var mappedStatus = "room-number";

			if (serviceStatus) {
				if (serviceStatus == 'OUT_OF_SERVICE' || serviceStatus == 'OUT_OF_ORDER') {
					return "room-grey";
				}
			}

			if (reservation_status == 'CHECKING_IN') {
				if (roomReadyStatus != '') {
					if (fostatus == 'VACANT') {
						switch (roomReadyStatus) {
							case "INSPECTED":
								mappedStatus += ' room-green';
								break;
							case "CLEAN":
								if (checkinInspectedOnly == "true") {
									mappedStatus += ' room-orange';
									break;
								} else {
									mappedStatus += ' room-green';
									break;
								}
								break;
							case "PICKUP":
								mappedStatus += " room-orange";
								break;

							case "DIRTY":
								mappedStatus += " room-red";
								break;
						}
					} else {
						mappedStatus += " room-red";
					}
				}
			}

			return mappedStatus;
		};

		$scope.$on("OUTSIDECLICKED", function(event) {
			$scope.focusOutOnSearchText();
			//ngDialog.close();
		});

		//please don't remove this code.... CICO-10091
		//blur action to navigate to dashboard if no query
		$scope.focusOutOnSearchText = function() {

			if ($scope.textInQueryBox.length === 0) {
				$scope.$apply(function() {
					$scope.$emit("HeaderBackButtonClicked")
				});

			}
		};


		$scope.loadNextSet = function() {
			RVSearchSrv.page++;
			$scope.nextAction = true;
			$scope.prevAction = false;
			$scope.fetchSearchResults();
		};

		$scope.loadPrevSet = function() {
			RVSearchSrv.page--;
			$scope.nextAction = false;
			$scope.prevAction = true;
			$scope.fetchSearchResults();
		};

		$scope.isNextButtonDisabled = function() {
			var isDisabled = false;
			//if($scope.end >= RVSearchSrv.totalSearchResults || $scope.disableNextButton){

			if ($scope.end >= RVSearchSrv.totalSearchResults) {
				isDisabled = true;
			}
			return isDisabled;
		};

		$scope.isPrevButtonDisabled = function() {
			var isDisabled = false;
			if (RVSearchSrv.page == 1) {
				isDisabled = true;
			}
			return isDisabled;
		};

		$scope.showCalendar = function(controller) {
			$scope.focusSearchField = false;
			$scope.$emit("showSearchResultsArea", true);
            $timeout(function() {
                ngDialog.open({
                    template: '/assets/partials/search/rvDatePickerPopup.html',
                    controller: controller,
                    className: '',
                    scope: $scope
                });
            }, 1000);
		};

		var initPaginationParams = function() {
			RVSearchSrv.page = 1;
			$scope.start = 1;
			$scope.end = $scope.start + $scope.results.length - 1;
			$scope.nextAction = false;
			$scope.prevAction = false;
		}

		$scope.onFromDateChanged = function(date) {
			$scope.fromDate = date;
			initPaginationParams();
			$scope.fetchSearchResults();
			$timeout(function() {
				$scope.focusSearchField = true;
			}, 2000);
		};

		$scope.onToDateChanged = function(date) {
			$scope.toDate = date;
			initPaginationParams();
			$scope.fetchSearchResults();
            $timeout(function() {
                $scope.focusSearchField = true;
            }, 2000);
		};

		$scope.clearToDateClicked = function() {
			$scope.toDate = '';
			RVSearchSrv.toDate = '';
			$scope.fetchSearchResults();
		};

		$scope.getTimeConverted = function(time) {
			if (time == null || time == undefined) {
				return "";
			}
			var timeDict = tConvert(time);
			return (timeDict.hh + ":" + timeDict.mm + " " + timeDict.ampm);
		};
	}
]);