sntRover.controller('RVReservationConfirmCtrl', [
	'$scope',
	'$state',
	'RVReservationSummarySrv',
	'ngDialog',
	'RVContactInfoSrv',
	'$filter',
	'RVBillCardSrv',
	'$q',
	'RVHkRoomDetailsSrv',
	'$vault',
	'$rootScope',
	function($scope, $state, RVReservationSummarySrv, ngDialog, RVContactInfoSrv, $filter, RVBillCardSrv, $q, RVHkRoomDetailsSrv, $vault, $rootScope) {
		$scope.errorMessage = '';
		BaseCtrl.call(this, $scope);
		var totalRoomsAvailable = 0;

		$scope.reservationStatus = {
			confirmed: false // flag to show the action button (Go to staycard etc.) after confirming reservation
		};

		$rootScope.setPrevState = {
			title: $filter('translate')('RESERVATION_SUMMARY'),
			name: 'rover.reservation.staycard.mainCard.summaryAndConfirm',
			param: {
				reservation: $scope.reservationData.isHourly ? 'HOURLY' : 'DAILY',
			}
		};

		$scope.init = function() {
			$scope.heading = 'Reservations';
			$scope.setHeadingTitle($scope.heading);

			$scope.$parent.hideSidebar = true;
			$scope.time = {
				arrival: $scope.reservationData.checkinTime.hh + ':' + $scope.reservationData.checkinTime.mm + ' ' + $scope.reservationData.checkinTime.ampm,
				departure: $scope.reservationData.checkoutTime.hh + ':' + $scope.reservationData.checkoutTime.mm + ' ' + $scope.reservationData.checkoutTime.ampm
			};
			$scope.disableCheckin = true;
			totalRoomsAvailable = 0;
			$scope.isConfirmationEmailSent = ($scope.otherData.isGuestPrimaryEmailChecked || $scope.otherData.isGuestAdditionalEmailChecked) ? true : false;
			$scope.setScroller('reservationSummary');
			$scope.setScroller('paymentInfo');
			checkAllRoomsAreReady();
		};

		/*
		 * Get the title for the billing info button,
		 * on the basis of routes available or not
		 */
		$scope.getBillingInfoTitle = function() {
			if ($scope.reservationData.is_routing_available)
				return $filter('translate')('BILLING_INFO_TITLE');
			else
				return $filter('translate')('ADD_BILLING_INFO_TITLE');
		}

		/**
		 * Function to check if the the check-in time is selected by the user.
		 * @return {Boolean} true if 'hours', 'minutes', 'primetime' - all are selected.
		 */
		$scope.isCheckinTimeSet = function() {
			var ret = false;
			if ($scope.reservationData.checkinTime.hh != '' &&
				$scope.reservationData.checkinTime.mm != '' &&
				$scope.reservationData.checkinTime.ampm != '') {

				ret = true;
			}
			return ret;
		};

		/**
		 * Function to check if the the checkout time is selected by the user.
		 * @return {Boolean} true if 'hours', 'minutes', 'primetime' - all are selected.
		 */
		$scope.isCheckoutTimeSet = function() {
			var ret = false;
			if ($scope.reservationData.checkoutTime.hh != '' &&
				$scope.reservationData.checkoutTime.mm != '' &&
				$scope.reservationData.checkoutTime.ampm != '') {

				ret = true;
			}
			return ret;

		};

		$scope.unflagConfirmation = function() {
			$scope.reservationStatus.confirmed = false;
			$rootScope.setPrevState = {
				title: $filter('translate')('RESERVATION_SUMMARY'),
				name: 'rover.reservation.staycard.mainCard.summaryAndConfirm',
				param: {
					reservation: $scope.reservationData.isHourly ? 'HOURLY' : 'DAILY',
				}
			};
		}

		/**
		 * Call API to send the confirmation email
		 */
		$scope.sendConfirmationClicked = function(isEmailValid) {
			var updateBackButton = function() {
				$rootScope.setPrevState = {
					title: $filter('translate')('CONFIRM_RESERVATION'),
					name: 'rover.reservation.staycard.mainCard.reservationConfirm',
					param: {
						confirmationId: $scope.reservationData.confirmNum,
					},
					callback: 'unflagConfirmation',
					scope: $scope
				};
			}

			// skip sending messages if no mail id is provided or none of the emails are checked, go to the next screen
			if ((!$scope.otherData.additionalEmail && !$scope.reservationData.guest.email) || (!$scope.otherData.isGuestPrimaryEmailChecked && !$scope.otherData.isGuestAdditionalEmailChecked)) {
				$scope.reservationStatus.confirmed = true;
				updateBackButton();
				return false;
			}

			var postData = {};
			postData.reservationId = $scope.reservationData.reservationId;

			/**
			 * CICO-7077 Confirmation Mail to have tax details
			 */
			postData.tax_details = [];
			_.each($scope.reservationData.taxDetails, function(taxDetail) {
				postData.tax_details.push(taxDetail);
			});
			postData.tax_total = $scope.reservationData.totalTax;


			postData.emails = [];
			if (!!$scope.reservationData.guest.email && $scope.otherData.isGuestPrimaryEmailChecked)
				postData.emails.push($scope.reservationData.guest.email);

			if (!!$scope.otherData.additionalEmail && $scope.otherData.isGuestAdditionalEmailChecked)
				postData.emails.push($scope.otherData.additionalEmail);

			if ($scope.reservationData.isHourly) {
				postData.reservation_ids = [];
				_.each($scope.reservationData.reservations, function(reservation) {
					postData.reservation_ids.push(reservation.id);
				});
			}

			var emailSentSuccess = function(data) {
				$scope.reservationStatus.confirmed = true;
				updateBackButton();
				$scope.$emit('hideLoader');
			};

			if ($scope.reservationData.isHourly) {
				$scope.invokeApi(RVReservationSummarySrv.sendHourlyConfirmationEmail, postData, emailSentSuccess);
			} else {
				$scope.invokeApi(RVReservationSummarySrv.sendConfirmationEmail, postData, emailSentSuccess);
			}

		};

		/*
			If email address does not exists on Guest Card,
		    and user decides to update via the Email field on the summary screen,
		    this email should be linked to the guest card. 
		 */
		$scope.primaryEmailEntered = function() {

			if ($scope.reservationData.guest.email != '' && $scope.reservationData.guest.email != null) {
				return false;
			}

			var dataToUpdate = {
				"email": $scope.reservationData.guest.sendConfirmMailTo
			};

			var data = {
				'data': dataToUpdate,
				'userId': $scope.reservationData.guest.id || $scope.reservationDetails.guestCard.id
			};

			var updateGuestEmailSuccessCallback = function(data) {
				$scope.reservationData.guest.email = $scope.reservationData.guest.sendConfirmMailTo;
				$scope.$emit('guestEmailChanged');
				$scope.$emit("hideLoader");
			}

			var updateGuestEmailFailureCallback = function(data) {
				$scope.$emit("hideLoader");
			}

			$scope.invokeApi(RVContactInfoSrv.updateGuest, data, updateGuestEmailSuccessCallback, updateGuestEmailFailureCallback);
		}

		/**
		 * Navigate to the staycard for this guest
		 */
		$scope.goToStaycardClicked = function() {
			var stateParams = {
				id: $scope.reservationData.reservationId,
				confirmationId: $scope.reservationData.confirmNum,
				isrefresh: true,
				justCreatedRes: true
			}
			$scope.otherData.reservationCreated = true;
			$state.go('rover.reservation.staycard.reservationcard.reservationdetails', stateParams);

		};

		/**
		 * Navigate to the reservation search.
		 * Retain Arrival / Departure Date / Number of nights,
		 * Retain  Guest, Company & TA names
		 * Retain Adults / Children / Infants
		 * Retain  Previously booked room type
		 * initialize all the other data.
		 */
		$scope.clickedNewReservation = function() {
			$scope.reservationData.roomCount = 1;
			$scope.reservationData.rooms[0].rateId = '';
			$scope.reservationData.rooms[0].rateName = '';
			$scope.reservationData.rooms[0].rateAvg = '';
			$scope.reservationData.rooms[0].rateTotal = '';

			$scope.reservationData.totalTaxAmount = '';
			$scope.reservationData.totalTax = '';
			$scope.reservationData.totalStayCost = '';
			$scope.reservationData.guest.sendConfirmMailTo = '';

			var paymentType = {
				type: {},
				ccDetails: { //optional - only if credit card selected
					number: '',
					expMonth: '',
					expYear: '',
					nameOnCard: ''
				}
			};
			$scope.reservationData.paymentType = paymentType;
			$scope.reservationData.demographics = {
				market: '',
				source: '',
				reservationType: '',
				origin: ''
			};
			$scope.reservationData.promotion = {
				promotionCode: '',
				promotionType: ''
			};
			$scope.reservationData.reservationId = '';
			$scope.reservationData.confirmNum = '';
			// Set flag to retain the card details
			$scope.reservationData.isSameCard = true;
			$scope.otherData.reservationCreated = true;

			$state.go('rover.reservation.search');
		};

		$scope.gotoDiaryScreen = function() {
			$scope.reservationData = {};
			$scope.initReservationDetails();
			$vault.set('temporaryReservationDataFromDiaryScreen', JSON.stringify({}));
			$state.go('rover.diary', {
				isfromcreatereservation: false
			});
		};
		var allRoomDetailsFetched = function(data) {
			$scope.$emit("hideLoader");
		}
		var failedInRoomDetailsFetch = function(data) {
			$scope.$emit("hideLoader");
		}
		var successOfRoomDetailsFetch = function(data) {
			if (data.current_hk_status == 'READY') {
				totalRoomsAvailable++;
			}
		};
		$scope.enableCheckInButton = function() {
			return _.has($scope.reservationData, "rooms") &&
				($scope.reservationData.rooms.length == totalRoomsAvailable);
		};

		var checkAllRoomsAreReady = function() {
			var promises = [];
			var data = null;
			//we are following this structure bacuse of the hideloader pblm. 
			// we are going to call mutilple API's paralelly. So sometimes last API may complete first
			// we need to keep loader until all api gets completed 
			$scope.$emit("showLoader");
			for (var i = 0; i < $scope.reservationData.rooms.length; i++) {
				id = $scope.reservationData.rooms[i].room_id;
				//directly calling without base ctrl
				promises.push(RVHkRoomDetailsSrv.fetch(id).then(successOfRoomDetailsFetch));
			}
			$q.all(promises).then(allRoomDetailsFetched, failedInRoomDetailsFetch);

		};

		var successOfAllCheckin = function(data) {
			$scope.$emit("hideLoader");
			$scope.successMessage = 'Successful checking in.';
		};

		var failureOfCheckin = function(errorMessage) {
			$scope.$emit("hideLoader");
			$scope.errorMessage = errorMessage;
		};

		$scope.checkin = function() {
			/*
				Please one min..
				We create a list of promises against each API call
				if it all resolved successfully then only we will proceed 
			*/
			var confirmationIDs = [];
			var promises = [];
			var data = null;
			$scope.$emit("showLoader");
			for (var i = 0; i < $scope.reservationData.rooms.length; i++) {
				confirmationIDs.push($scope.reservationData.rooms[i].confirm_no);
				data = {
					'reservation_id': $scope.reservationData.rooms[i].confirm_no
				};
				//directly calling without base ctrl
				promises.push(RVBillCardSrv.completeCheckin(data));
			}
			$q.all(promises).then(successOfAllCheckin, failureOfCheckin);
		};
		/**
		 * Reset all reservation data and go to search
		 */
		$scope.goToSearchClicked = function() {
			$scope.initReservationData();
			//$state.go('rover.reservation.search');
			$state.go('rover.search', '');
		};

		$scope.modifyCheckinCheckoutTime = function() {

			var updateSuccess = function(data) {
				$scope.$emit('hideLoader');
			}


			var updateFailure = function(data) {
				$scope.$emit('hideLoader');
			}
			if ($scope.reservationData.checkinTime.hh != '' && $scope.reservationData.checkoutTime.hh != '') {
				var postData = $scope.computeReservationDataforUpdate();
				postData.addons = $scope.existingAddons;
				$scope.invokeApi(RVReservationSummarySrv.updateReservation, postData, updateSuccess, updateFailure);
			}
		}

		/**
		 * trigger the billing information popup. $scope.reservationData is the same variable used in billing info popups also. 
		 So we are adding the required params to the existing $scope.reservationData, so that no other functionalities in reservation confirmation breaks.
		 */

		$scope.openBillingInformation = function(confirm_no) {
			//incase of multiple reservations we need to check the confirm_no to access billing 
			//information
			if (confirm_no) {
				angular.forEach($scope.reservationData.reservations, function(reservation, key) {
					if (reservation.confirm_no === confirm_no) {
						$scope.reservationData.confirm_no = reservation.confirm_no;
						$scope.reservationData.reservation_id = reservation.id;
						$scope.reservationData.reservation_status = reservation.status;
					}
				});
			} else {
				$scope.reservationData.confirm_no = $scope.reservationData.confirmNum;
				$scope.reservationData.reservation_id = $scope.reservationData.reservationId;
				$scope.reservationData.reservation_status = $scope.reservationData.status;
			}

			if ($scope.reservationData.guest.id != null) {
				$scope.reservationData.user_id = $scope.reservationData.guest.id;
			} else {
				$scope.reservationData.user_id = $scope.reservationData.company.id;
			}

			ngDialog.open({
				template: '/assets/partials/bill/rvBillingInformationPopup.html',
				controller: 'rvBillingInformationPopupCtrl',
				className: 'ngdialog-theme-default',
				scope: $scope
			});
		}

		$scope.setDemographics = function() {
			ngDialog.open({
				template: '/assets/partials/reservation/rvReservationDemographicsPopup.html',
				className: 'ngdialog-theme-default',
				scope: $scope
			});
		}

		$scope.updateAdditionalDetails = function() {
			console.log('updateAdditionalDetails', $scope.reservationData.demographics);
			var updateSuccess = function(data) {
				$scope.$emit('hideLoader');
			};

			var updateFailure = function(data) {
				$scope.$emit('hideLoader');
				$scope.errorMessage = data;
			};

			$scope.errorMessage = [];

			var postData = $scope.computeReservationDataforUpdate();
			postData.reservationId = $scope.reservationData.reservationId;
			postData.addons = $scope.existingAddons;
			$scope.invokeApi(RVReservationSummarySrv.updateReservation, postData, updateSuccess, updateFailure);
		}
		$scope.init();
	}
]);