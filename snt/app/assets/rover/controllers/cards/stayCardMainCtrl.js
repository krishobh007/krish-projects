sntRover.controller('stayCardMainCtrl', ['$rootScope', '$scope', 'RVCompanyCardSrv', '$stateParams', 'RVReservationCardSrv', 'RVGuestCardSrv', 'ngDialog', '$state', 'RVReservationSummarySrv', '$timeout', 'dateFilter',
	function($rootScope, $scope, RVCompanyCardSrv, $stateParams, RVReservationCardSrv, RVGuestCardSrv, ngDialog, $state, RVReservationSummarySrv, $timeout, dateFilter) {
		BaseCtrl.call(this, $scope);
		//Switch to Enable the new cards addition funcitonality
		$scope.addNewCards = true;
		var that = this;
		if ($scope.guestCardData.cardHeaderImage == undefined || $scope.guestCardData.cardHeaderImage == "") {
			$scope.guestCardData.cardHeaderImage = '/assets/avatar-trans.png';
		}
		$scope.pendingRemoval = {
			status: false,
			cardType: ""
		};

		$scope.setHeadingTitle = function(heading) {
			$scope.heading = heading;
			$scope.setTitle(heading);
		}

		$scope.cardSaved = function() {
			$scope.viewState.isAddNewCard = false;
		};

		var successCallbackOfCountryListFetch = function(data) {
			$scope.countries = data;
		};

		//fetching country list
		$scope.invokeApi(RVCompanyCardSrv.fetchCountryList, {}, successCallbackOfCountryListFetch);


		$scope.initGuestCard = function(guestData) {
			// passReservationParams
			//TODO : Once this works pull it to a separate method 
			var fetchGuestcardDataSuccessCallback = function(data) {
				$scope.$emit('hideLoader');
				// No more future reservations returned with this API call
				// $scope.reservationDetails.guestCard.futureReservations = data.future_reservation_count;

				/**
				 *	CICO-9169
				 * 	Guest email id is not checked when user adds Guest details in the Payment page of Create reservation
				 *  -- To have the primary email id in app/assets/rover/partials/reservation/rvSummaryAndConfirm.html checked if the user attached has one!
				 */

				if (data.email && data.email.length > 0) {
					$scope.otherData.isGuestPrimaryEmailChecked = true;
				} else {
					// Handles cases where Guest with email is replaced with a Guest w/o an email address!
					$scope.otherData.isGuestPrimaryEmailChecked = false;
				}

				//	CICO-9169

				var contactInfoData = {
					'contactInfo': data,
					'countries': $scope.countries,
					'userId': $scope.reservationDetails.guestCard.id,
					'avatar': $scope.guestCardData.cardHeaderImage,
					'guestId': null,
					'vip': data.vip
				};
				$scope.guestCardData.contactInfo = contactInfoData.contactInfo;
				$scope.guestCardData.contactInfo.avatar = contactInfoData.avatar;
				$scope.guestCardData.contactInfo.vip = contactInfoData.vip;
				$scope.countriesList = $scope.countries;
				$scope.guestCardData.userId = contactInfoData.userId;
				$scope.guestCardData.guestId = contactInfoData.guestId;
				$scope.guestCardData.contactInfo.birthday = data.birthday;
				var guestInfo = {
					"user_id": contactInfoData.userId,
					"guest_id": null
				};
				$scope.searchData.guestCard.guestFirstName = "";
				$scope.searchData.guestCard.guestLastName = "";
				$scope.searchData.guestCard.guestCity = "";
				$scope.searchData.guestCard.guestLoyaltyNumber = "";
				$scope.searchData.guestCard.email = "";

				$scope.guestCardData.contactInfo.user_id = contactInfoData.userId;
				$scope.reservationData.guest.email = data.email;
				$scope.$broadcast('guestSearchStopped');
				$scope.$broadcast('guestCardAvailable');
				$scope.showGuestPaymentList(guestInfo);
				$scope.decloneUnwantedKeysFromContactInfo = function() {
					var unwantedKeys = ["address", "birthday", "country",
						"is_opted_promotion_email", "job_title",
						"mobile", "passport_expiry",
						"passport_number", "postal_code",
						"reservation_id", "title", "user_id",
						"works_at", "birthday"
					];
					var declonedData = dclone($scope.guestCardData.contactInfo, unwantedKeys);
					return declonedData;
				};

				/**
				 *  init guestcard header data
				 */
				var declonedData = $scope.decloneUnwantedKeysFromContactInfo();
				var currentGuestCardHeaderData = declonedData;
				$scope.$broadcast("resetGuestTab");
				$scope.$broadcast("SHOWGUESTLIKESINFO");
			};

			var fetchGuestcardDataFailureCallback = function(data) {
				$scope.$emit('hideLoader');
			};


			if ($scope.reservationDetails.guestCard.id != '' && $scope.reservationDetails.guestCard.id != null) {
				var param = {
					'id': $scope.reservationDetails.guestCard.id
				};
				$scope.invokeApi(RVReservationCardSrv.getGuestDetails, param, fetchGuestcardDataSuccessCallback, fetchGuestcardDataFailureCallback, 'NONE');
			}
		};


		// fetch reservation company card details 
		$scope.initCompanyCard = function() {
			var companyCardFound = function(data) {
				$scope.$emit("hideLoader");
				data.id = $scope.reservationDetails.companyCard.id;
				$scope.companyContactInformation = data;
				// No more future reservations returned with this API call
				// $scope.reservationDetails.companyCard.futureReservations = data.future_reservation_count;
				$scope.$broadcast('companyCardAvailable');

			};
			//	companycard defaults to search mode 
			// 	Hence, do API call only if a company card ID is returned
			if ($scope.reservationDetails.companyCard.id != '' && $scope.reservationDetails.companyCard.id != null) {
				var param = {
					'id': $scope.reservationDetails.companyCard.id
				};
				$scope.invokeApi(RVCompanyCardSrv.fetchContactInformation, param, companyCardFound);
			}
		};

		// fetch reservation travel agent card details
		$scope.initTravelAgentCard = function() {
			var successCallbackOfInitialFetch = function(data) {
				$scope.$emit("hideLoader");
				data.id = $scope.reservationDetails.travelAgent.id;
				$scope.travelAgentInformation = data;

				// No more future reservations returned with this API call
				// $scope.reservationDetails.travelAgent.futureReservations = data.future_reservation_count;
				$scope.$broadcast('travelAgentFetchComplete');

			};
			//	TAcard defaults to search mode 
			// 	Hence, do API call only if a company card ID is returned
			if ($scope.reservationDetails.travelAgent.id != '' && $scope.reservationDetails.travelAgent.id != null) {
				var param = {
					'id': $scope.reservationDetails.travelAgent.id
				};
				$scope.invokeApi(RVCompanyCardSrv.fetchContactInformation, param, successCallbackOfInitialFetch);
			}
		};


		$scope.$on('cardIdsFetched', function(event, isCardSame) {
			// Restore view state
			$scope.viewState.pendingRemoval.status = false;
			$scope.viewState.pendingRemoval.cardType = "";

			//init all cards with new data
			if (!isCardSame.guest) {
				$scope.$broadcast('guestCardDetached');
				$scope.initGuestCard();
			}
			if (!isCardSame.company) {
				$scope.$broadcast('companyCardDetached');
				$scope.initCompanyCard();
			}
			if (!isCardSame.agent) {
				$scope.$broadcast('travelAgentDetached');
				$scope.initTravelAgentCard();
			}

			// The future counts of the cards attached with the reservation
			// will be received here!
			// This code should be HIT everytime there is a removal or a replacement of
			// any of the cards attached! 
			//if cards are not attached future reservation values are coming in as null
			var futureCounts = $scope.reservationListData.future_reservation_counts;


			$scope.reservationDetails.guestCard.futureReservations = futureCounts.guest == null ? 0 : futureCounts.guest;
			$scope.reservationDetails.companyCard.futureReservations = futureCounts.company == null ? 0 : futureCounts.company;
			$scope.reservationDetails.travelAgent.futureReservations = futureCounts.travel_agent == null ? 0 : futureCounts.travel_agent;

			// TODO: Remove the following commented out code!
			// Leaving it now for further debugging if required


		});

		$scope.removeCard = function(card, future) {
			// This method returns the numnber of cards attached to the staycard
			var checkNumber = function() {
				var x = 0;
				_.each($scope.reservationDetails, function(d, i) {
					if (typeof d.id != 'undefined' && d.id != '' && d.id != null) x++;
				})
				return x;
			}

			//Cannot Remove the last card... Tell user not to select another card
			if (checkNumber() > 1 && card != "") {
				$scope.invokeApi(RVCompanyCardSrv.removeCard, {
					'reservation': typeof $stateParams.id == "undefined" ? $scope.reservationData.reservationId : $stateParams.id,
					'cardType': card
				}, function() {
					$scope.cardRemoved(card);
					$scope.$emit('hideLoader');
					/**
					 * 	Reload the stay card if any of the attached cards are changed! >>> 7078 / 7370
					 * 	the state would be STAY_CARD in the reservation edit mode also.. hence checking for confirmation id in the state params
					 * 	The confirmationId will not be in the reservation edit/create stateParams except for the confirmation screen...
					 * 	However, in the confirmation screen the identifier would be "CONFIRM"
					 */
					if ($scope.viewState.identifier == "STAY_CARD" && typeof $stateParams.confirmationId != "undefined") {
						$state.go('rover.reservation.staycard.reservationcard.reservationdetails', {
							"id": typeof $stateParams.id == "undefined" ? $scope.reservationData.reservationId : $stateParams.id,
							"confirmationId": $stateParams.confirmationId,
							"isrefresh": false
						});
					}
				}, function() {
					$scope.$emit('hideLoader');
				});
			} else {
				//Bring up alert here
				if ($scope.viewState.pendingRemoval.status) {
					$scope.viewState.pendingRemoval.status = false;
					$scope.viewState.pendingRemoval.cardType = "";
					// If user has not replaced a new card, keep this one. Else remove this card
					// The below flag tracks the card and has to be reset once a new card has been linked, 
					// along with a call to remove the flagged card
					$scope.viewState.lastCardSlot = card;
					var templateUrl = '/assets/partials/cards/alerts/cardRemoval.html';
					ngDialog.open({
						template: templateUrl,
						className: 'ngdialog-theme-default stay-card-alerts',
						scope: $scope,
						closeByDocument: false,
						closeByEscape: false
					});
				}
			}
		};

		$scope.noRoutingToReservation = function() {
			ngDialog.close();
			that.reloadStaycard();

		};

		$scope.applyRoutingToReservation = function() {
			var routingApplySuccess = function(data) {
				$scope.$emit("hideLoader");
				ngDialog.close();
				that.reloadStaycard();
				$scope.$broadcast('paymentTypeUpdated');// to update bill screen data
			};

			var params = {};
			params.account_id = $scope.contractRoutingType === 'TRAVEL_AGENT' ? $scope.reservationData.travelAgent.id : $scope.reservationData.company.id;
			params.reservation_ids = [];
			params.reservation_ids.push($scope.reservationData.reservationId)

			$scope.invokeApi(RVReservationSummarySrv.applyDefaultRoutingToReservation, params, routingApplySuccess);
		};

		$scope.okClickedForConflictingRoutes = function() {
			ngDialog.close();
			that.reloadStaycard();

		};

		this.showConfirmRoutingPopup = function(type, id) {
			ngDialog.open({
				template: '/assets/partials/reservation/alerts/rvBillingInfoConfirmPopup.html',
				className: 'ngdialog-theme-default',
				scope: $scope
			});
		};

		this.showConflictingRoutingPopup = function(type, id) {

			ngDialog.open({
				template: '/assets/partials/reservation/alerts/rvBillingInfoConflictingPopup.html',
				className: 'ngdialog-theme-default',
				scope: $scope
			});

		};

		this.attachCompanyTACardRoutings = function(card) {

			var fetchSuccessofDefaultRouting = function(data) {
				$scope.$emit("hideLoader");
				$scope.routingInfo = data;
				if (data.has_conflicting_routes) {
					$scope.conflict_cards = [];
					if (card == 'travel_agent' && data.travel_agent.routings_count > 0) {
						$scope.conflict_cards.push($scope.reservationData.travelAgent.name)
					}
					if (card == 'company' && data.company.routings_count > 0) {
						$scope.conflict_cards.push($scope.reservationData.company.name)
					}
					that.showConflictingRoutingPopup();
					return false;
				}

				if (card == 'travel_agent' && data.travel_agent.routings_count > 0) {
					$scope.contractRoutingType = "TRAVEL_AGENT";
					that.showConfirmRoutingPopup($scope.contractRoutingType, $scope.reservationData.travelAgent.id)
					return false;

				}
				if (card == 'company' && data.company.routings_count > 0) {
					$scope.contractRoutingType = "COMPANY";
					that.showConfirmRoutingPopup($scope.contractRoutingType, $scope.reservationData.company.id)
					return false;
				} else {
					that.reloadStaycard();
				}

			};

			var params = {};
			params.reservation_id = $scope.reservationData.reservationId;

			if (card == 'travel_agent') {
				params.travel_agent_id = $scope.reservationData.travelAgent.id;
			} else if (card == 'company') {
				params.company_id = $scope.reservationData.company.id;
			}

			$scope.invokeApi(RVReservationSummarySrv.fetchDefaultRoutingInfo, params, fetchSuccessofDefaultRouting);
		};

		$scope.replaceCard = function(card, cardData, future) {
			if (card == 'company') {
				$scope.reservationData.company.id = cardData.id;
				$scope.reservationData.company.name = cardData.account_name;
			} else if (card == 'travel_agent') {
				$scope.reservationData.travelAgent.id = cardData.id;
				$scope.reservationData.travelAgent.name = cardData.account_name;
			}

			//Replace card with the selected one
			$scope.invokeApi(RVCompanyCardSrv.replaceCard, {
				'reservation': typeof $stateParams.id == "undefined" ? $scope.reservationData.reservationId : $stateParams.id,
				'cardType': card,
				'id': cardData.id,
				'future': typeof future == 'undefined' ? false : future
			}, function() {
				$scope.cardRemoved(card);
				$scope.cardReplaced(card, cardData);
				if ($scope.viewState.lastCardSlot != "") {
					$scope.removeCard($scope.viewState.lastCardSlot);
					$scope.viewState.lastCardSlot = "";
				}
				$scope.$emit('hideLoader');
				that.attachCompanyTACardRoutings(card);
			}, function() {
				$scope.cardRemoved();
				$scope.$emit('hideLoader');
			});
		};

		/**
		 * 	Reload the stay card if any of the attached cards are changed! >>> 7078 / 7370
		 * 	the state would be STAY_CARD in the reservation edit mode also.. hence checking for confirmation id in the state params
		 * 	The confirmationId will not be in the reservation edit/create stateParams except for the confirmation screen...
		 * 	However, in the confirmation screen the identifier would be "CONFIRM"
		 */
		this.reloadStaycard = function() {
			if ($scope.viewState.identifier == "STAY_CARD" && typeof $stateParams.confirmationId != "undefined") {
				$state.go('rover.reservation.staycard.reservationcard.reservationdetails', {
					"id": typeof $stateParams.id == "undefined" ? $scope.reservationData.reservationId : $stateParams.id,
					"confirmationId": $stateParams.confirmationId,
					"isrefresh": false
				});
			}
		};

		$scope.cardRemoved = function(card) {
			//reset Pending Flag
			$scope.viewState.pendingRemoval.status = false;
			$scope.viewState.pendingRemoval.cardType = "";
			// reset the id and the future reservation counts that were cached
			if (card == 'guest') {
				$scope.reservationDetails.guestCard.id = "";
				$scope.reservationDetails.guestCard.futureReservations = 0;
				var contactInfoData = {
					'contactInfo': {},
					'countries': $scope.countries,
					'userId': "",
					'avatar': "",
					'guestId': "",
					'vip': "" //TODO: check with API or the product team
				};
				// // $scope.$emit('guestCardUpdateData', contactInfoData);
				$scope.guestCardData.contactInfo = contactInfoData.contactInfo;
				$scope.guestCardData.contactInfo.avatar = contactInfoData.avatar;
				$scope.guestCardData.contactInfo.vip = contactInfoData.vip;
				$scope.countriesList = contactInfoData.countries;
				$scope.guestCardData.userId = contactInfoData.userId;
				$scope.guestCardData.guestId = contactInfoData.guestId;
				$scope.guestCardData.contactInfo.birthday = null;
			}
			if (card == 'company') {
				$scope.reservationDetails.companyCard.id = "";
				$scope.reservationDetails.companyCard.futureReservations = 0;
			} else if (card == 'travel_agent') {
				$scope.reservationDetails.travelAgent.id = "";
				$scope.reservationDetails.travelAgent.futureReservations = 0;
			}


		};

		$scope.cardReplaced = function(card, cardData) {
			if (card == 'company') {
				$scope.reservationDetails.companyCard.id = cardData.id;
				$scope.initCompanyCard();
				//clean search data
				$scope.searchData.companyCard.companyName = "";
				$scope.searchData.companyCard.companyCity = "";
				$scope.searchData.companyCard.companyCorpId = "";
				$scope.showContractedRates({
					companyCard: cardData.id,
					travelAgent: $scope.reservationDetails.travelAgent.id
				});
				$scope.$broadcast('companySearchStopped');
			} else if (card == 'travel_agent') {
				$scope.reservationDetails.travelAgent.id = cardData.id;
				$scope.initTravelAgentCard();
				// clean search data
				$scope.searchData.travelAgentCard.travelAgentName = "";
				$scope.searchData.travelAgentCard.travelAgentCity = "";
				$scope.searchData.travelAgentCard.travelAgentIATA = "";
				$scope.showContractedRates({
					companyCard: $scope.reservationData.company.id,
					travelAgent: cardData.id
				});
				$scope.$broadcast('travelAgentSearchStopped');
			} else if (card == 'guest') {
				$scope.reservationDetails.guestCard.id = cardData.id;
				$scope.initGuestCard(cardData);
				$scope.searchData.guestCard.guestFirstName = "";
				$scope.searchData.guestCard.guestLastName = "";
				$scope.searchData.guestCard.guestCity = "";
				$scope.searchData.guestCard.guestLoyaltyNumber = "";
				$scope.searchData.guestCard.email = "";

				$scope.$broadcast('guestSearchStopped');
			}
		};

		$scope.showGuestPaymentList = function(guestInfo) {
			var userId = guestInfo.user_id,
				guestId = guestInfo.guest_id;
			var paymentSuccess = function(paymentData) {
				$scope.$emit('hideLoader');

				var paymentData = {
					"data": paymentData,
					"user_id": userId,
					"guest_id": guestId
				};
				$scope.$emit('GUESTPAYMENTDATA', paymentData);
				$scope.$emit('SHOWGUESTLIKES');
			};

			$scope.invokeApi(RVGuestCardSrv.fetchGuestPaymentData, userId, paymentSuccess, '', 'NONE');
		};

		// This method can be used to generate payload for the reservation update API call.
		// Note: The payment and the confirmation mails related information is not computed in this call now, as that would require moving a few variables from the 
		// scope of RVReservationSummaryCtrl to stayCardMainCtrl

		$scope.getEmptyAccountData = function() {
			return {
				"address_details": {
					"street1": null,
					"street2": null,
					"street3": null,
					"city": null,
					"state": null,
					"postal_code": null,
					"country_id": null,
					"email_address": null,
					"phone": null
				},
				"account_details": {
					"account_name": null,
					"company_logo": "",
					"account_number": null,
					"accounts_receivable_number": null,
					"billing_information": null
				},
				"primary_contact_details": {
					"contact_first_name": null,
					"contact_last_name": null,
					"contact_job_title": null,
					"contact_phone": null,
					"contact_email": null
				},
				"future_reservation_count": 0
			}
		}

		$scope.showContractedRates = function(cardIds) {
			// 	CICO-7792 BEGIN
			/*
			 *	When a Travel Agent or Company card has been attached to the reservation during the reservation process,
			 *	the rate / room display should include the rate of the Company / Travel Agent contract if one exists.
			 *	Have to make a call to the availability API with the card added as a request param
			 */
			$scope.$broadcast('cardChanged', cardIds);
			// 	CICO-7792 END
		}


		var ratesFetched = function(data, saveReservation) {
			var save = function() {
				if ($scope.reservationData.guest.id || $scope.reservationData.company.id || $scope.reservationData.travelAgent.id) {
					$scope.saveReservation();
				} else {
					$scope.$emit('PROMPTCARD');
				}
			};

			$scope.otherData.taxesMeta = data.tax_codes;
			$scope.otherData.hourlyTaxInfo = data.tax_information;
			$scope.reservationData.totalTax = 0;
			$scope.computeHourlyTotalandTaxes();
			if (saveReservation) {
				if (!$scope.reservationData.guest.id && !$scope.reservationData.company.id && !$scope.reservationData.travelAgent.id) {
					$scope.$emit('PROMPTCARD');
					$scope.$watch("reservationData.guest.id", save);
					$scope.$watch("reservationData.company.id", save);
					$scope.$watch("reservationData.travelAgent.id", save);
				} else {
					$scope.saveReservation();
				}
			}

			$timeout(function() {
				$scope.$emit('hideLoader');
			}, 500);
		};

		$scope.populateDatafromDiary = function(roomsArray, tData, saveReservation) {
			angular.forEach(tData.rooms, function(value, key) {
				value['roomTypeId'] = roomsArray[value.room_id].room_type_id;
				value['roomTypeName'] = roomsArray[value.room_id].room_type_name;
				value['roomNumber'] = roomsArray[value.room_id].room_no;
			});

			this.rooms = [];
			$scope.reservationData.rooms = tData.rooms;
			$scope.reservationData.arrivalDate = dateFilter(new tzIndependentDate(tData.arrival_date), 'yyyy-MM-dd');
			$scope.reservationData.departureDate = dateFilter(new tzIndependentDate(tData.departure_date), 'yyyy-MM-dd');
			var arrivalTimeSplit = tData.arrival_time.split(":");

			$scope.reservationData.checkinTime.hh = arrivalTimeSplit[0];
			$scope.reservationData.checkinTime.mm = arrivalTimeSplit[1].split(" ")[0];
			if ($scope.reservationData.checkinTime.mm.length == 1) {
				$scope.reservationData.checkinTime.mm = "0" + $scope.reservationData.checkinTime.mm;
			}
			$scope.reservationData.checkinTime.ampm = arrivalTimeSplit[1].split(" ")[1];
			if (!($scope.reservationData.checkinTime.ampm === "AM" || $scope.reservationData.checkinTime.ampm === "PM")) {
				if (parseInt($scope.reservationData.checkinTime.hh) >= 12) {
					$scope.reservationData.checkinTime.hh = Math.abs(parseInt($scope.reservationData.checkinTime.hh) - 12) + "";
					$scope.reservationData.checkinTime.ampm = "PM";
				} else {
					$scope.reservationData.checkinTime.ampm = "AM";
				}
			}
			if (Math.abs(parseInt($scope.reservationData.checkinTime.hh) - 12) == 0 || $scope.reservationData.checkinTime.hh === "00" || $scope.reservationData.checkinTime.hh === "0") {
				$scope.reservationData.checkinTime.hh = "12";
			}
			if ($scope.reservationData.checkinTime.hh.length == 1) {
				$scope.reservationData.checkinTime.hh = "0" + $scope.reservationData.checkinTime.hh;
			}

			var departureTimeSplit = tData.departure_time.split(":");
			$scope.reservationData.checkoutTime.hh = departureTimeSplit[0];
			$scope.reservationData.checkoutTime.mm = departureTimeSplit[1].split(" ")[0];

			if ($scope.reservationData.checkoutTime.mm.length == 1) {
				$scope.reservationData.checkoutTime.mm = "0" + $scope.reservationData.checkoutTime.mm;
			}
			$scope.reservationData.checkoutTime.ampm = departureTimeSplit[1].split(" ")[1];

			if (!($scope.reservationData.checkoutTime.ampm === "AM" || $scope.reservationData.checkoutTime.ampm === "PM")) {
				if (parseInt($scope.reservationData.checkoutTime.hh) >= 12) {
					$scope.reservationData.checkoutTime.hh = Math.abs(parseInt($scope.reservationData.checkoutTime.hh) - 12) + "";
					$scope.reservationData.checkoutTime.ampm = "PM";
				} else {
					$scope.reservationData.checkoutTime.ampm = "AM";
				}
			}
			if (Math.abs(parseInt($scope.reservationData.checkoutTime.hh) - 12) == "0" || $scope.reservationData.checkoutTime.hh === "00" || $scope.reservationData.checkoutTime.hh === "0") {
				$scope.reservationData.checkoutTime.hh = "12";
			}
			if ($scope.reservationData.checkoutTime.hh.length == 1) {
				$scope.reservationData.checkoutTime.hh = "0" + $scope.reservationData.checkoutTime.hh;
			}
			var hResData = tData.rooms[0];

			this.reservationId = hResData.reservation_id;
			this.confirmNum = hResData.confirmation_id;


			if (this.reservationId) {
				$scope.viewState.identifier = "CONFIRM";
			} else {
				$scope.viewState.identifier = "CREATION";
				$scope.viewState.reservationStatus.confirm = false;
			}

			$scope.reservationDetails.guestCard = {};
			$scope.reservationDetails.guestCard.id = hResData.guest_card_id;
			$scope.reservationDetails.travelAgent = {};
			$scope.reservationDetails.travelAgent.id = hResData.travel_agent_id;
			$scope.reservationDetails.companyCard = {};
			$scope.reservationDetails.companyCard.id = hResData.company_card_id;


			$scope.reservationData.guest = {};
			$scope.reservationData.guest.id = hResData.guest_card_id;
			$scope.reservationData.travelAgent = {};
			$scope.reservationData.travelAgent.id = hResData.travel_agent_id;
			$scope.reservationData.company = {};
			$scope.reservationData.company.id = hResData.company_card_id;

			$scope.initGuestCard();
			$scope.initCompanyCard();
			$scope.initTravelAgentCard();


			this.totalStayCost = 0;
			var rateIdSet = [];
			var self = this;
			angular.forEach($scope.reservationData.rooms, function(room, index) {
				room.stayDates = {};
				rateIdSet.push(tData.rooms[index].rateId);
				// amount: 32
				// numAdults: 1
				// numChildren: 0
				// numInfants: 0
				// rateId: 787
				// roomNumber: "07"
				// roomTypeId: "62"
				// roomTypeName: "Standard Cabin"
				// room_id: 588
				// room_no: "07"
				// room_type: "Standard Cabin"
				room.numAdults = tData.rooms[index].numAdults;
				room.numChildren = tData.rooms[index].numChildren;
				room.numInfants = tData.rooms[index].numInfants;
				room.roomTypeId = tData.rooms[index].roomTypeId;
				room.amount = tData.rooms[index].amount;
				room.room_id = tData.rooms[index].room_id;
				room.room_no = tData.rooms[index].room_no;
				room.room_type = tData.rooms[index].room_type;

				room.rateId = tData.rooms[index].rateId;
				room.roomAmount = tData.rooms[index].amount;


				self.totalStayCost = parseFloat(self.totalStayCost) + parseFloat(tData.rooms[index].amount);
				var success = function(data) {
					room.rateName = data.name;
					$scope.reservationData.demographics.market = !data.market_segment_id ? '' : data.market_segment_id;
					$scope.reservationData.demographics.source = !data.source_id ? '' : data.source_id;
					if (data.deposit_policy_id) {
						$scope.reservationData.depositData = {};
						$scope.reservationData.depositData.isDepositRequired = true;
						$scope.reservationData.depositData.description = data.deposit_policy.description;
						$scope.reservationData.depositData.depositSuccess = !$scope.reservationData.depositData.isDepositRequired;
						$scope.reservationData.depositData.attempted = false;
						$scope.reservationData.depositData.depositAttemptFailure = false;
						$scope.$broadcast("UPDATEDEPOSIT");
					}
				};
				var roomAmount = parseFloat(room.roomAmount).toFixed(2);
				$scope.invokeApi(RVReservationSummarySrv.getRateDetails, {
					id: room.rateId
				}, success);
				for (var ms = new tzIndependentDate($scope.reservationData.arrivalDate) * 1, last = new tzIndependentDate($scope.reservationData.departureDate) * 1; ms <= last; ms += (24 * 3600 * 1000)) {

					room.stayDates[dateFilter(new tzIndependentDate(ms), 'yyyy-MM-dd')] = {
						guests: {
							adults: room.numAdults,
							children: room.numChildren,
							infants: room.numInfants
						},
						rate: {
							id: room.rateId
						},
						rateDetails: {
							actual_amount: roomAmount,
							modified_amount: roomAmount,
							is_discount_allowed: 'true'
						}
					};
				}
			});

			$scope.invokeApi(RVReservationSummarySrv.getTaxDetails, {
				rate_ids: rateIdSet
			}, ratesFetched);
		}.bind($scope.reservationData);

		// CICO-11991 : Handle ARRIVALS button click.
		$scope.loadPrevState = function() {
			$rootScope.loadPrevState();
			$rootScope.$broadcast("OUTSIDECLICKED");
		};

	}
]);