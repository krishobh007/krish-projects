sntRover.controller('rvReservationGuestController', ['$scope', '$rootScope', 'RVReservationGuestSrv', '$stateParams', '$state', '$timeout', 'ngDialog', 'dateFilter',
	function($scope, $rootScope, RVReservationGuestSrv, $stateParams, $state, $timeout, ngDialog, dateFilter) {

		BaseCtrl.call(this, $scope);
		$scope.guestData = {};
		var presentGuestInfo = {};
		var initialGuestInfo = {};
		$scope.errorMessage = '';

		/**
		 * To check the currently entered occupancy and display prompt if it is over the allowed max occupancy for the room / room type
		 * @return boolean [description]
		 */
		function isWithinMaxOccupancy() {
			var maxOccupancy = $scope.reservationData.reservation_card.max_occupancy; //TODO: Get the max occupancy here
			if (!!maxOccupancy) {
				var currentTotal = parseInt($scope.guestData.adult_count || 0) +
					parseInt($scope.guestData.children_count || 0);

				return currentTotal > parseInt(maxOccupancy);
			} else { // If the max occupancy aint configured DONT CARE -- Just pass it thru
				return false;
			}
		}

		/**
		 * To check if the currently entered occupancy has been configured.
		 * @return boolean [description]
		 */
		function isOccupancyRateConfigured() {
			if ($scope.reservationData.reservation_card.is_hourly_reservation) {
				// check if current staydate object has a single rate configured
				var stayDate = _.findWhere($scope.reservationData.reservation_card.stay_dates, {
					date: $scope.reservationData.reservation_card.arrival_date
				});
				return (!!(stayDate && stayDate.rate_config && stayDate.rate_config.single));
			} else {
				var flag = true;
				angular.forEach($scope.reservationData.reservation_card.stay_dates, function(item, index) {
					if (flag) {
						if ($scope.guestData.adult_count && parseInt($scope.guestData.adult_count) == 1) {
							flag = !!(item.rate_config.single);
						} else if ($scope.guestData.adult_count && parseInt($scope.guestData.adult_count) == 2) {
							flag = !!(item.rate_config.double);
						} else if ($scope.guestData.adult_count && parseInt($scope.guestData.adult_count) > 2) {
							flag = !!(item.rate_config.double && item.rate_config.extra_adult);
						}

						if (flag && $scope.guestData.children_count && !!parseInt($scope.guestData.children_count)) {
							flag = !!(item.rate_config.child);
						}
					}
				});
				return flag;
			}
		}

		function saveChanges(override) {

			$scope.$emit('showLoader');
			angular.forEach($scope.reservationData.reservation_card.stay_dates, function(item, index) {
				// Note: when editing number of guests for an INHOUSE reservation, the new number of guests should only apply from this day onwards, any previous days need to retain the previous guest count.	
				if (new tzIndependentDate(item.date) >= new tzIndependentDate($rootScope.businessDate)) {
					var adults = parseInt($scope.guestData.adult_count || 0),
						children = parseInt($scope.guestData.children_count || 0),
						rateToday = item.rate_config;
					$scope.reservationParentData.rooms[0].stayDates[dateFilter(new tzIndependentDate(item.date), 'yyyy-MM-dd')].guests = {
						adults: adults,
						children: children,
						infants: parseInt($scope.guestData.infants_count || 0)
					}
					if (!$scope.reservationData.reservation_card.is_hourly_reservation) {
						if (override) {
							var actual_amount = $scope.reservationParentData.rooms[0].stayDates[dateFilter(new tzIndependentDate(item.date), 'yyyy-MM-dd')].rateDetails.actual_amount;
							if (parseFloat(actual_amount) > 0.00) {
								$scope.reservationParentData.rooms[0].stayDates[dateFilter(new tzIndependentDate(item.date), 'yyyy-MM-dd')].rateDetails.modified_amount = actual_amount;
							}
							$scope.reservationParentData.rooms[0].stayDates[dateFilter(new tzIndependentDate(item.date), 'yyyy-MM-dd')].rateDetails.actual_amount = 0;
						} else {
							var baseRoomRate = adults >= 2 ? rateToday.double : rateToday.single;
							var extraAdults = adults >= 2 ? adults - 2 : 0;
							var roomAmount = baseRoomRate + (extraAdults * rateToday.extra_adult) + (children * rateToday.child);

							$scope.reservationParentData.rooms[0].stayDates[dateFilter(new tzIndependentDate(item.date), 'yyyy-MM-dd')].rateDetails.actual_amount = roomAmount;
							$scope.reservationParentData.rooms[0].stayDates[dateFilter(new tzIndependentDate(item.date), 'yyyy-MM-dd')].rateDetails.modified_amount = roomAmount;
						}


					}
				}
			})

			presentGuestInfo = JSON.parse(JSON.stringify($scope.guestData));
			initialGuestInfo = JSON.parse(JSON.stringify($scope.guestData));

			var successCallback = function(data) {
				$scope.saveReservation("rover.reservation.staycard.reservationcard.reservationdetails", {
					"id": $scope.reservationData.reservation_card.reservation_id,
					"confirmationId": $scope.reservationData.reservation_card.confirmation_num,
					"isrefresh": true
				});
				$scope.errorMessage = '';
			};

			var errorCallback = function(errorMessage) {
				$scope.$emit('hideLoader');
				$scope.$emit("OPENGUESTTAB");
				$scope.errorMessage = errorMessage;
			};

			var dataToSend = dclone($scope.guestData, ["primary_guest_details", "accompanying_guests_details"]);
			dataToSend.accompanying_guests_details = [];
			dataToSend.reservation_id = $scope.reservationData.reservation_card.reservation_id;

			angular.forEach($scope.guestData.accompanying_guests_details, function(item, index) {
				delete item.image;
				if ((item.first_name == "" || item.first_name == null) && (item.last_name == "" || item.last_name == null)) {
					// do nothing
				} else {
					// Only valid data is going to send.
					dataToSend.accompanying_guests_details.push(item);
				}
			});

			if (dataToSend.accompanying_guests_details.length > 0) {
				$scope.invokeApi(RVReservationGuestSrv.updateGuestTabDetails, dataToSend, successCallback, errorCallback);
			} else {
				$scope.saveReservation("rover.reservation.staycard.reservationcard.reservationdetails", {
					"id": $scope.reservationData.reservation_card.reservation_id,
					"confirmationId": $scope.reservationData.reservation_card.confirmation_num,
					"isrefresh": true
				});
			}

		}

		function closeDialog() {
			ngDialog.close();
		}

		$scope.applyCurrentRate = function() {
			saveChanges(true); //override
			closeDialog();

		}

		$scope.cancelOccupancyChange = function() {
			// RESET
			$scope.guestData = JSON.parse(JSON.stringify(initialGuestInfo));
			presentGuestInfo = JSON.parse(JSON.stringify(initialGuestInfo));
			closeDialog();
		}

		/* To save guest details */
		$scope.saveGuestDetails = function() {
			var data = JSON.parse(JSON.stringify($scope.guestData));
			if (!angular.equals(data, initialGuestInfo)) {
				$scope.$emit('showLoader');
				if (isOccupancyRateConfigured()) {
					saveChanges();
				} else {
					$scope.$emit('hideLoader');
					ngDialog.open({
						template: '/assets/partials/reservation/alerts/notConfiguredOccupancyInStayCard.html',
						className: '',
						scope: $scope,
						closeByDocument: false,
						closeByEscape: false
					});
				}
			}
		};


		/**
		 * CICO-12672 Occupancy change from the staycard --
		 */
		$scope.onStayCardOccupancyChange = function() {
			if (isWithinMaxOccupancy()) {
				////////
				// Step 1 : Check against max occupancy and let know the user if the occupancy is not allowed
				////////
				ngDialog.open({
					template: '/assets/partials/reservation/alerts/occupancy.html',
					className: '',
					scope: $scope,
					closeByDocument: false,
					closeByEscape: false,
					data: JSON.stringify({
						roomType: $scope.reservationData.reservation_card.room_type_description,
						roomMax: $scope.reservationData.reservation_card.max_occupancy
					})
				});
			}
			presentGuestInfo.adult_count = $scope.guestData.adult_count;
			presentGuestInfo.children_count = $scope.guestData.children_count;
			presentGuestInfo.infants_count = $scope.guestData.infants_count;
		}

		$scope.init = function() {

			var successCallback = function(data) {
				$scope.$emit('hideLoader');
				$scope.guestData = data;
				presentGuestInfo = JSON.parse(JSON.stringify($scope.guestData)); // to revert in case of exceeding occupancy
				initialGuestInfo = JSON.parse(JSON.stringify($scope.guestData)); // to make API call to update if some change has been made
				$scope.errorMessage = '';
			};

			var errorCallback = function(errorMessage) {
				$scope.$emit('hideLoader');
				$scope.errorMessage = errorMessage;
			};

			var data = {
				"reservation_id": $scope.reservationData.reservation_card.reservation_id
			};

			$scope.invokeApi(RVReservationGuestSrv.fetchGuestTabDetails, data, successCallback, errorCallback);
		};


		$scope.init();

		$scope.$on("UPDATEGUESTDEATAILS", function(e) {
			$scope.saveGuestDetails();
		});

		$scope.$on("FAILURE_UPDATE_RESERVATION", function(e, data) {
			$scope.$emit("OPENGUESTTAB");
			$scope.errorMessage = data;
		});

	}
]);