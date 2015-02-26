sntRover.controller('guestCardController', ['$scope', '$window', 'RVCompanyCardSrv', 'RVReservationAllCardsSrv', 'RVContactInfoSrv', '$stateParams', '$timeout', 'ngDialog', '$rootScope', 'RVSearchSrv',

	function($scope, $window, RVCompanyCardSrv, RVReservationAllCardsSrv, RVContactInfoSrv, $stateParams, $timeout, ngDialog, $rootScope, RVSearchSrv) {
		$s = $scope;
		var resizableMinHeight = 90;
		var resizableMaxHeight = $(window).height() - resizableMinHeight;

		$scope.dimensionsLookup = {
			resizableMaxHeight: resizableMaxHeight,
			cardTabContentOffset: 170, // Height of the tab menu and the header above.			
		};

		$scope.cardVisible = false;
		//init activeCard as the companyCard
		$scope.activeCard = "companyCard";

		BaseCtrl.call(this, $scope);

		var initReservation = function() {
			if (!$scope.reservationData.isSameCard || !$scope.otherData.reservationCreated) {
				// open search list card if any of the search fields are entered on main screen
				var searchData = $scope.reservationData;
				if ($scope.searchData.guestCard.guestFirstName != '' || $scope.searchData.guestCard.guestLastName != '' || searchData.company.id != null || searchData.travelAgent.id != null) {
					// based on search values from base screen
					// init respective search
					if ($scope.reservationDetails.guestCard.id == '') {
						if ($scope.searchData.guestCard.guestFirstName != '' || $scope.searchData.guestCard.guestLastName != '') {
							$scope.openGuestCard();
							$scope.searchGuest();
						}
					}
					if (searchData.company.id != null) {
						if ($scope.searchData.guestCard.guestFirstName == '' && $scope.searchData.guestCard.guestLastName == '') {
							if ($stateParams.reservation && $stateParams.reservation != 'HOURLY' && $stateParams.mode && $stateParams.mode != 'OTHER') {
								$scope.switchCard('company-card');
							}
						}
						$scope.reservationDetails.companyCard.id = searchData.company.id;
						$scope.initCompanyCard({
							id: searchData.company.id
						});
					}
					if (searchData.travelAgent.id != null) {
						if ($scope.searchData.guestCard.guestFirstName == '' && $scope.searchData.guestCard.guestLastName == '') {
							if ($stateParams.reservation && $stateParams.reservation != 'HOURLY' && $stateParams.mode && $stateParams.mode != 'OTHER') {
								$scope.switchCard('travel-agent-card');
							}
						}
						$scope.reservationDetails.travelAgent.id = searchData.travelAgent.id;
						$scope.initTravelAgentCard({
							id: searchData.travelAgent.id
						});
					}
				}
			} else {
				// populate cards
				$scope.closeGuestCard();
				if ($scope.reservationDetails.guestCard.id != "" && $scope.reservationDetails.guestCard.id != null) {
					$scope.initGuestCard({
						id: $scope.reservationDetails.guestCard.id
					});
				}
				if ($scope.reservationDetails.companyCard.id != "" && $scope.reservationDetails.companyCard.id != null) {
					$scope.initCompanyCard({
						id: $scope.reservationDetails.companyCard.id
					});
				}
				if ($scope.reservationDetails.travelAgent.id != "" && $scope.reservationDetails.travelAgent.id != null) {
					$scope.initTravelAgentCard({
						id: $scope.reservationDetails.travelAgent.id
					});
				}
				$scope.reservationData.isSameCard = false;
			}

			if ($scope.otherData.fromSearch) {
				$scope.otherData.fromSearch = false;
			}
		};

		// update guest details to RVSearchSrv via RVSearchSrv.updateGuestDetails - params: guestid, data
		var updateSearchCache = function() {
			var data = {
				'firstname': $scope.guestCardData.contactInfo.first_name,
				'lastname': $scope.guestCardData.contactInfo.last_name,
				'location': $scope.guestCardData.contactInfo.address ? $scope.guestCardData.contactInfo.address.city + ', ' + $scope.guestCardData.contactInfo.address.state : false,
				'vip': $scope.guestCardData.contactInfo.vip
			};
			RVSearchSrv.updateGuestDetails($scope.guestCardData.contactInfo.user_id, data);
		};

		$scope.init = function() {
			if ($scope.viewState.identifier == "CREATION") {
				initReservation();
			} else {
				$scope.contactInfoError = false;
				$scope.eventTimestamp = "";
				var preventClicking = false;
			}
		};

		$scope.$on("resetGuestTab", function() {
			$scope.guestCardTabSwitch("guest-contact");
		});

		$scope.$on('reservationCardisClicked', function() {

			$("#guest-card").css("height", $scope.resizableOptions.minHeight); //against angular js practice, sorry :(
			$scope.guestCardVisible = false;
			$scope.cardVisible = false;
		});
		/**
		 * for dragging of guest card
		 */
		$scope.guestCardVisible = false;
		//varibale used to determine whether to show guest card's different tabs
		$scope.guestCardHeight = 90;

		/**
		 * to be updated from resize directive
		 */
		$scope.$watch('windowHeight', function(newValue, oldValue) {
			$scope.windowHeight = newValue;
		});

		/**
		 * scroller options
		 */
		$scope.resizableOptions = {
			minHeight: resizableMinHeight,
			maxHeight: resizableMaxHeight,
			handles: 's',
			resize: function(event, ui) {
				if ($(this).height() > 120 && !$scope.guestCardVisible) { //against angular js principle, sorry :(				
					$scope.guestCardVisible = true;
					$scope.cardVisible = true;
					$scope.$emit('GUESTCARDVISIBLE', true);
					$scope.$apply();
				} else if ($(this).height() <= 120 && $scope.guestCardVisible) {
					$scope.guestCardVisible = false;
					$scope.cardVisible = false;
					$scope.handleDrawClosing();
					$scope.$emit('GUESTCARDVISIBLE', false);
					$scope.$apply();
				}
				$scope.guestCardHeight = $(this).height();
				/**
				 * CICO-9564 -- Scrolls in the card section on dragging
				 */
				if ($scope.UICards[0] === "guest-card") {
					$scope.$broadcast('CONTACTINFOLOADED');
					$scope.$broadcast('REFRESHLIKESSCROLL');
				} else {
					$scope.$broadcast('contactTabActive');
					$scope.$broadcast('contractTabActive');
					$scope.$broadcast('refreshAccountsScroll');
				}


			},
			stop: function(event, ui) {
				preventClicking = true;
				$scope.eventTimestamp = event.timeStamp;
			}
		};

		/**
		 *  API call needs only rest of keys in the data
		 */
		$scope.decloneUnwantedKeysFromContactInfo = function() {

			var unwantedKeys = ["birthday", "country",
				"is_opted_promotion_email", "job_title",
				"mobile", "passport_expiry",
				"passport_number", "postal_code",
				"reservation_id", "title", "user_id",
				"works_at", "birthday", "avatar"
			];
			var declonedData = dclone($scope.guestCardData.contactInfo, unwantedKeys);
			return declonedData;
		};

		/**
		 *  init guestcard header data
		 */
		var declonedData = $scope.decloneUnwantedKeysFromContactInfo();
		var currentGuestCardHeaderData = declonedData;
		$scope.current = 'guest-contact';

		/**
		 *
		 *to reset current data in header info for determining any change
		 **/
		$scope.$on('RESETHEADERDATA', function(event, data) {
			currentGuestCardHeaderData.address = data.address;
			currentGuestCardHeaderData.phone = data.phone;
			currentGuestCardHeaderData.email = data.email;
			currentGuestCardHeaderData.first_name = data.first_name;
			currentGuestCardHeaderData.last_name = data.last_name;
		});

		/**
		 * tab actions
		 */
		$scope.guestCardTabSwitch = function(tab) {
			if ($scope.current === 'guest-contact' && tab !== 'guest-contact') {
				if ($scope.viewState.isAddNewCard) {
					$scope.$broadcast("showSaveMessage");
				} else {
					$scope.$broadcast('saveContactInfo');
				}
			};
			if ($scope.current === 'guest-like' && tab !== 'guest-like') {
				$scope.$broadcast('SAVELIKES');

			};
			if (tab === 'guest-credit') {
				$scope.$broadcast('PAYMENTSCROLL');
			}
			$scope.$broadcast('REFRESHLIKESSCROLL');
			if (!$scope.viewState.isAddNewCard) {
				$scope.current = tab;
			}
		};

		$scope.$on('contactInfoError', function(event, value) {
			$scope.contactInfoError = value;
		});
		$scope.$on('likesInfoError', function(event, value) {
			$scope.likesInfoError = value;
		});

		$scope.updateContactInfo = function() {
			var that = this;
			that.newUpdatedData = $scope.decloneUnwantedKeysFromContactInfo();
			var saveUserInfoSuccessCallback = function(data) {
				$scope.$emit('hideLoader');
				$scope.reservationData.guest.email = that.newUpdatedData.email;
				// update few of the details to searchSrv
				updateSearchCache();
				//to reset current data in contcat info for determining any change
				$scope.$broadcast("RESETCONTACTINFO", that.newUpdatedData);
			};

			// check if there is any chage in data.if so call API for updating data
			if (JSON.stringify(currentGuestCardHeaderData) !== JSON.stringify(that.newUpdatedData)) {
				currentGuestCardHeaderData = that.newUpdatedData;
				var data = {
					'data': currentGuestCardHeaderData,
					'userId': $scope.guestCardData.contactInfo.user_id
				};
				if(typeof data.userId != 'undefined'){
					$scope.invokeApi(RVContactInfoSrv.saveContactInfo, data, saveUserInfoSuccessCallback);
				}
			}
		};

		/**
		 *   In case of a click or an event occured on child elements
		 *	of actual targeted element, we need to change it as the event on parent element
		 *   @param {event} is the actual event
		 *   @param {selector} is the selector which we want to check against that event
		 *   @return {Boolean} trueif the event occured on selector or it's child elements
		 *   @return {Boolean} false if not
		 */
		function getParentWithSelector($event, selector) {
			var obj = $event.target,
				matched = false;
			return selector.contains(obj);
		};

		$scope.guestCardClick = function($event) {
			$rootScope.$emit('clearErroMessages');
			$scope.$broadcast('clearNotifications');
			var element = $event.target;
			$event.stopPropagation();
			$event.stopImmediatePropagation();
			//if the main menu is open close the same
			if ($scope.isMenuOpen()) {
				$scope.closeDrawer();
				return false;
			}
			if (getParentWithSelector($event, document.getElementsByClassName("ui-resizable-handle")[0])) {
				if (parseInt($scope.eventTimestamp)) {
					if (($event.timeStamp - $scope.eventTimestamp) < 100) {
						return;
					}
				}
				var currentHeight = $scope.guestCardHeight;
				if (currentHeight == resizableMinHeight || currentHeight == resizableMaxHeight) {
					// open a closed card
					if (!$scope.guestCardVisible) {
						$scope.openGuestCard();
						$scope.$broadcast('CONTACTINFOLOADED');
						$scope.$emit('GUESTCARDVISIBLE', true);
					} else if ($scope.guestCardVisible && currentHeight == resizableMaxHeight) { // close an opened card
						$scope.closeGuestCard();
						$scope.$emit('GUESTCARDVISIBLE', false);
					}
				} else {
					// mid way click : close guest card
					$scope.closeGuestCard();
					$scope.$emit('GUESTCARDVISIBLE', false);
				}


			} else {
				if (getParentWithSelector($event, document.getElementById("guest-card-content"))) {
					/**
					 * handle click on tab navigation bar.
					 */
					if ($event.target.id === 'guest-card-tabs-nav' || $event.target.id === 'cards-header') {
						$scope.$broadcast('saveContactInfo');
						$scope.$broadcast('SAVELIKES');

					} else {
						return;
					}
				}
			}
		};


		$scope.checkOutsideClick = function(targetElement) {
			if ($scope.cardVisible) {
				$scope.$broadcast('saveContactInfo');
				$scope.$broadcast('SAVELIKES');
			}
			if ($(targetElement).closest(".rover-header").length < 1 && $(targetElement).closest(".stay-card-alerts").length < 1 && $(targetElement).closest(".guest-card").length < 1 && $(targetElement).closest(".ngdialog").length < 1 && $(targetElement).find("#loading").length < 1 && $(targetElement).closest("#loading").length < 1 && $(targetElement).closest('.nav-toggle').length < 1) {
				$scope.closeGuestCard();
			}
		};


		$scope.UICards = ['guest-card', 'company-card', 'travel-agent-card'];

		// className based on UICards index
		var subCls = ['first', 'second', 'third'];

		$scope.UICardClass = function(from) {
			// based on from (guest-card, company-card || travel-agent-card)
			// evaluate UICards return className(s) as string
			var cls = '';
			if (from !== $scope.UICards[0]) {
				cls = "change-card " + subCls[$scope.UICards.indexOf(from)];
			} else {
				cls = subCls[0];
			};
			return cls;
		};

		$scope.UICardContentCls = function(from) {
			// evaluate UICards return card conten className(s) as string
			var cls = '';
			if (from !== $scope.UICards[0]) {
				cls = "hidden";
			} else {
				cls = 'visible';
			};
			return cls;
		};

		$scope.cardCls = function() {
			// evaluate 
			var cls = $scope.UICards[0]; //  current active card
			if ($scope.cardVisible) {
				cls += " open";
			}
			return cls;
		};

		$scope.switchCard = function(from) {
			//  based on from
			//  swap UICards array for guest-card, company-card & travel-agent-card
			var newCardIndex = $scope.UICards.indexOf(from);
			var currentCard = $scope.UICards[0];
			$scope.UICards[0] = from;
			$scope.UICards[newCardIndex] = currentCard;
			if ($scope.UICards[0] == 'company-card' || $scope.UICards[0] == 'travel-agent-card') {
				$scope.activeCard = $scope.UICards[0] == 'company-card' ? "companyCard" : "travelAgent";
				$scope.$broadcast('activeCardChanged');
			}
		};

		/**
		 * function to open guest card
		 */
		$scope.openGuestCard = function() {
			$scope.cardVisible = true;
			$scope.guestCardVisible = true;
			$scope.guestCardHeight = resizableMaxHeight;
			// //refresh scroll in the contact tab of the card-content view. Handled in rover/controllers/rvCompanyCardsContactCtrl.js
			$scope.$broadcast("contactTabActive");
			// //refreshing the scroller in guestcard's tab
			// $scope.$broadcast('REFRESHLIKESSCROLL');
		};

		/**
		 * function to close guest card
		 */
		$scope.closeGuestCard = function() {
			$scope.guestCardHeight = resizableMinHeight;
			//Check if pending removals - If yes remove 
			$scope.handleDrawClosing();
			$scope.cardVisible = false;
			$scope.guestCardVisible = false;
		};

		$scope.handleDrawClosing = function() {
			if ($scope.viewState.isAddNewCard) {
				var cards = {
					'guest-card': 'guest',
					'company-card': 'company',
					'travel-agent-card': 'travel_agent'
				};
				discardCard(cards[$scope.UICards[0]]);
			}
			if ($scope.viewState.pendingRemoval.status) {
				$scope.removeCard($scope.viewState.pendingRemoval.cardType);
			}
		};


		$scope.clickedDiscardCard = function(cardType, discard) {
			discardCard(cardType, discard);
		};

		var discardCard = function(cardType, discard) {
			$scope.viewState.isAddNewCard = false;
			if (cardType == 'travel_agent') {
				$scope.$broadcast('travelAgentDetached');
			} else if (cardType == 'company') {
				$scope.$broadcast('companyCardDetached');
			} else if (cardType == 'guest') {
				$scope.$broadcast('guestCardDetached');
			}
		};

		var resetReservationData = (function() {
			this.resetGuest = function() {
				$scope.reservationData.guest.id = "";
				$scope.reservationData.guest.firstName = "";
				$scope.reservationData.guest.lastName = "";
				$scope.reservationData.guest.city = "";
				$scope.reservationData.guest.loyaltyNumber = "";
				$scope.reservationData.guest.email = "";


				// update current controller scope
				$scope.guestFirstName = "";
				$scope.guestLastName = "";
				$scope.guestCity = "";
				$scope.guestCardData.cardHeaderImage = "";
			};
			this.resetCompanyCard = function() {
				$scope.reservationData.company.id = "";
				$scope.reservationData.company.name = "";
				$scope.reservationData.company.corporateid = "";
				$scope.companyName = "";
				$scope.companyCity = "";
				$scope.reservationDetails.companyCard.id = "";
			};
			this.resetTravelAgent = function() {
				$scope.reservationData.travelAgent.id = "";
				$scope.reservationData.travelAgent.name = "";
				$scope.reservationData.travelAgent.iataNumber = "";
				$scope.travelAgentName = "";
				$scope.travelAgentCity = "";
				$scope.reservationDetails.travelAgent.id = "";
			};

			return {
				resetGuest: this.resetGuest,
				resetCompanyCard: this.resetCompanyCard,
				resetTravelAgent: this.resetTravelAgent
			};
		})();

		$scope.detachCard = function(cardType) {
			if ($scope.viewState.identifier == "CREATION") {
				if (cardType == "guest") {
					resetReservationData.resetGuest();
					$scope.$broadcast("guestCardDetached");
				} else if (cardType == "company") {
					resetReservationData.resetCompanyCard();
					$scope.reservationDetails.companyCard.id = "";
					$scope.showContractedRates({
						companyCard: $scope.reservationDetails.companyCard.id,
						travelAgent: $scope.reservationDetails.travelAgent.id
					});
					$scope.$broadcast("companyCardDetached");
				} else if (cardType == "travel_agent") {
					resetReservationData.resetTravelAgent();
					$scope.reservationDetails.travelAgent.id = "";
					$scope.showContractedRates({
						companyCard: $scope.reservationDetails.companyCard.id,
						travelAgent: $scope.reservationDetails.travelAgent.id
					});
					$scope.$broadcast("travelAgentDetached");
				}
			} else {
				var cards = {
					"guest": "Guest Card",
					"company": "Company Card",
					"travel_agent": "Travel Agent Card"
				};

				ngDialog.open({
					template: '/assets/partials/cards/alerts/detachCard.html',
					className: 'ngdialog-theme-default stay-card-alerts',
					scope: $scope,
					closeByDocument: false,
					closeByEscape: false,
					data: JSON.stringify({
						cardTypeText: cards[cardType],
						cardType: cardType
					})
				});
			}
		};
		$scope.deleteCard = function(cardType) {
			if (cardType == 'travel_agent') {
				$scope.$broadcast('travelAgentDetached');
				$scope.viewState.pendingRemoval.status = true;
				$scope.viewState.pendingRemoval.cardType = "travel_agent";
			} else if (cardType == 'company') {
				$scope.$broadcast('companyCardDetached');
				$scope.viewState.pendingRemoval.status = true;
				$scope.viewState.pendingRemoval.cardType = "company";
				$scope.showContractedRates({
					companyCard: '',
					travelAgent: $scope.reservationDetails.travelAgent.id
				})
			} else if (cardType == 'guest') {
				$scope.$broadcast('guestCardDetached');
				$scope.viewState.pendingRemoval.status = true;
				$scope.viewState.pendingRemoval.cardType = "guest";
				$scope.showContractedRates({
					companyCard: $scope.reservationDetails.companyCard.id,
					travelAgent: ''
				})
			}
		};

		// init staycard header

		$scope.searchGuest = function() {
			var successCallBackFetchGuest = function(data) {
				$scope.$emit("hideLoader");
				$scope.guestSearchIntiated = true;
				$scope.searchedGuests = [];
				if (data.results.length > 0) {
					angular.forEach(data.results, function(item) {
						var guestData = {};
						guestData.id = item.id;
						guestData.firstName = item.first_name;
						guestData.lastName = item.last_name;
						guestData.image = item.image_url;
						guestData.vip = item.vip;
						if (item.address != null) {
							guestData.address = {};
							guestData.address.city = item.address.city;
							guestData.address.state = item.address.state;
							guestData.address.postalCode = item.address.postal_code;
						}
						guestData.stayCount = item.stay_count;
						guestData.lastStay = {};
						guestData.phone = item.home_phone;
						guestData.email = item.email;
						guestData.lastStay.date = item.last_stay.date;
						guestData.lastStay.room = item.last_stay.room;
						guestData.lastStay.roomType = item.last_stay.room_type;
						$scope.searchedGuests.push(guestData);
					});
				}
				$scope.$broadcast('guestSearchInitiated');
			};
			if ($scope.searchData.guestCard.guestFirstName != '' 
				|| $scope.searchData.guestCard.guestLastName != '' 
				|| $scope.searchData.guestCard.guestCity != '' 
				|| $scope.searchData.guestCard.guestLoyaltyNumber != ''
				|| $scope.searchData.guestCard.email != '') {
				var paramDict = {
					'first_name': $scope.searchData.guestCard.guestFirstName,
					'last_name': $scope.searchData.guestCard.guestLastName,
					'city': $scope.searchData.guestCard.guestCity,
					'membership_no': $scope.searchData.guestCard.guestLoyaltyNumber,
					'email': $scope.searchData.guestCard.email
				};
				if(shouldSearch()){
					$scope.invokeApi(RVReservationAllCardsSrv.fetchGuests, paramDict, successCallBackFetchGuest);
				}
			} else {
				$scope.guestSearchIntiated = false;
				$scope.searchedGuests = [];
				$scope.$apply();
				$scope.$broadcast('guestSearchStopped');
			}
		};

		var previousSearchData = {
		      'lastName': '',
		      'firstName': '',
		      'city': '',
		      'loyaltyNumber': '',
		      'email': ''
		    }

		var shouldSearch = function(){
			if( previousSearchData.lastName == $scope.searchData.guestCard.guestLastName 
				&& previousSearchData.firstName == $scope.searchData.guestCard.guestFirstName 
				&& previousSearchData.city == $scope.searchData.guestCard.guestCity 
				&& previousSearchData.loyaltyNumber == $scope.searchData.guestCard.guestLoyaltyNumber
				&& previousSearchData.email == $scope.searchData.guestCard.email ){
				return false;
			}
			previousSearchData.lastName = $scope.searchData.guestCard.guestLastName;
			previousSearchData.firstName = $scope.searchData.guestCard.guestFirstName;
			previousSearchData.city = $scope.searchData.guestCard.guestCity;
			previousSearchData.loyaltyNumber = $scope.searchData.guestCard.guestLoyaltyNumber;
			previousSearchData.email = $scope.searchData.guestCard.email;

			return ($scope.searchData.guestCard.guestLastName.length >= 2 
				|| $scope.searchData.guestCard.guestFirstName.length >= 1 
				|| $scope.searchData.guestCard.guestCity != '' 
				|| $scope.searchData.guestCard.guestLoyaltyNumber != ''
				|| $scope.searchData.guestCard.email != '');
		}

		$scope.searchCompany = function() {
			var successCallBackFetchCompanies = function(data) {
				$scope.$emit("hideLoader");
				$scope.companySearchIntiated = true;
				$scope.searchedCompanies = [];
				if (data.accounts.length > 0) {
					angular.forEach(data.accounts, function(item) {
						if (item.account_type === 'COMPANY') {
							var companyData = {};
							companyData.id = item.id;
							companyData.account_name = item.account_name;
							// companyData.lastName = item.account_last_name;
							companyData.logo = item.company_logo;
							if (item.address != null) {
								companyData.address = {};
								companyData.address.postalCode = item.address.postal_code;
								companyData.address.city = item.address.city;
								companyData.address.state = item.address.state;
							}
							if (item.current_contract != null) {
								companyData.rate = item.current_contract;
								companyData.rate.difference = (function() {
									if (parseInt(companyData.rate.based_on.value) < 0) {
										if (companyData.rate.based_on.type == "amount") {
											return $scope.currencySymbol + (parseFloat(companyData.rate.based_on.value) * -1).toFixed(2) + " off ";
										} else {
											return (parseFloat(companyData.rate.based_on.value) * -1) + "%" + " off ";
										}

									}
									return "";
								})();

								companyData.rate.surplus = (function() {
									if (parseInt(companyData.rate.based_on.value) > 0) {
										if (companyData.rate.based_on.type == "amount") {
											return " plus " + $scope.currencySymbol + parseFloat(companyData.rate.based_on.value).toFixed(2);
										} else {
											return " plus " + parseFloat(companyData.rate.based_on.value) + "%";
										}
									}
									return "";
								})();
							}
							companyData.email = item.email;
							companyData.phone = item.phone;
							$scope.searchedCompanies.push(companyData);
						}
					});
				}
				$scope.$broadcast('companySearchInitiated');
			};
			if ($scope.searchData.companyCard.companyName != '' || $scope.searchData.companyCard.companyCity != '' || $scope.searchData.companyCard.companyCorpId != '') {
				var paramDict = {
					'name': $scope.searchData.companyCard.companyName,
					'city': $scope.searchData.companyCard.companyCity,
					'account_number': $scope.searchData.companyCard.companyCorpId,
					'from_date': ($scope.viewState.identifier == "CREATION" || $scope.viewState.identifier == "CONFIRM") ? $scope.reservationData.arrivalDate : new Date($scope.reservation.reservation_card.arrival_date).toISOString().slice(0, 10).replace(/-/g, "-"),
					'to_date': ($scope.viewState.identifier == "CREATION" || $scope.viewState.identifier == "CONFIRM") ? $scope.reservationData.departureDate : new Date($scope.reservation.reservation_card.departure_date).toISOString().slice(0, 10).replace(/-/g, "-")
				};
				$scope.invokeApi(RVReservationAllCardsSrv.fetchCompaniesOrTravelAgents, paramDict, successCallBackFetchCompanies);
			} else {
				$scope.companySearchIntiated = false;
				$scope.searchedCompanies = [];
				$scope.$apply();
				$scope.$broadcast('companySearchStopped');
			}
		};

		$scope.searchTravelAgent = function() {
			var successCallBackFetchTravelAgents = function(data) {
				$scope.$emit("hideLoader");
				$scope.travelAgentSearchIntiated = true;
				$scope.searchedtravelAgents = [];
				if (data.accounts.length > 0) {
					angular.forEach(data.accounts, function(item) {
						if (item.account_type === 'TRAVELAGENT') {
							var travelAgentData = {};
							travelAgentData.id = item.id;
							travelAgentData.account_name = item.account_name;
							// travelAgentData.lastName = item.account_last_name;
							travelAgentData.logo = item.company_logo;
							if (item.address != null) {
								travelAgentData.address = {};
								travelAgentData.address.postalCode = item.address.postal_code;
								travelAgentData.address.city = item.address.city;
								travelAgentData.address.state = item.address.state;
							}
							if (item.current_contract != null) {
								travelAgentData.rate = item.current_contract;
								travelAgentData.rate.difference = (function() {
									if (parseInt(travelAgentData.rate.based_on.value) < 0) {
										if (travelAgentData.rate.based_on.type == "amount") {
											return $scope.currencySymbol + (parseFloat(travelAgentData.rate.based_on.value) * -1).toFixed(2) + " off ";
										} else {
											return (parseFloat(travelAgentData.rate.based_on.value) * -1) + "%" + " off ";
										}

									}
									return "";
								})();

								travelAgentData.rate.surplus = (function() {
									if (parseInt(travelAgentData.rate.based_on.value) > 0) {
										if (travelAgentData.rate.based_on.type == "amount") {
											return " plus " + $scope.currencySymbol + parseFloat(travelAgentData.rate.based_on.value).toFixed(2);
										} else {
											return " plus " + parseFloat(travelAgentData.rate.based_on.value) + "%";
										}
									}
									return "";
								})();
							}
							travelAgentData.email = item.email;
							travelAgentData.phone = item.phone;
							$scope.searchedtravelAgents.push(travelAgentData);
						}
					});
				}
				$scope.$broadcast('travelAgentSearchInitiated');
			};
			if ($scope.searchData.travelAgentCard.travelAgentName != '' || $scope.searchData.travelAgentCard.travelAgentCity != '' || $scope.searchData.travelAgentCard.travelAgentIATA != '') {
				var paramDict = {
					'name': $scope.searchData.travelAgentCard.travelAgentName,
					'city': $scope.searchData.travelAgentCard.travelAgentCity,
					'account_number': $scope.searchData.travelAgentCard.travelAgentIATA,
					'from_date': ($scope.viewState.identifier == "CREATION" || $scope.viewState.identifier == "CONFIRM") ? $scope.reservationData.arrivalDate : new Date($scope.reservation.reservation_card.arrival_date).toISOString().slice(0, 10).replace(/-/g, "-"),
					'to_date': ($scope.viewState.identifier == "CREATION" || $scope.viewState.identifier == "CONFIRM") ? $scope.reservationData.departureDate : new Date($scope.reservation.reservation_card.departure_date).toISOString().slice(0, 10).replace(/-/g, "-")
				};
				$scope.invokeApi(RVReservationAllCardsSrv.fetchCompaniesOrTravelAgents, paramDict, successCallBackFetchTravelAgents);
			} else {
				$scope.searchedtravelAgents = [];
				$scope.travelAgentSearchIntiated = false;
				$scope.$broadcast('travelAgentSearchStopped');
			}
		};
		$scope.checkFuture = function(cardType, card) {
			// Changing this reservation only will unlink the stay card from the previous company / travel agent card and assign it to the newly selected card. 
			// Changing all reservations will move all stay cards to the new card. 
			// This will only apply when a new company / TA card had been selected. 
			// If no new card has been selected, the change will only ever just apply to the current reservation and the above message should not display.
			// If multiple future reservations exist for the same Travel Agent / Company Card details, display message upon navigating away from the Stay Card 'Future reservations exist for the same Travel Agent / Company card.' 
			// With choice of 'Change this reservation only' and 'Change all Reservations'.

			if (!$scope.isHourly) {
				var templateUrl = '/assets/partials/cards/alerts/futureReservationsAccounts.html';
				if (cardType == 'guest') {
					templateUrl = '/assets/partials/cards/alerts/futureReservationsGuest.html';
				}
				ngDialog.open({
					template: templateUrl,
					className: 'ngdialog-theme-default stay-card-alerts',
					scope: $scope,
					closeByDocument: false,
					closeByEscape: false,
					data: JSON.stringify({
						cardType: cardType,
						card: card
					})
				});
			}
		};

		$scope.replaceCardCaller = function(cardType, card, future) {
			$scope.replaceCard(cardType, card, future);
		};

		$scope.selectCompany = function(company, $event) {
			$event.stopPropagation();
			//CICO-7792
			if ($scope.viewState.identifier == "CREATION") {
				$scope.reservationData.company.id = company.id;
				$scope.showContractedRates({
					companyCard: company.id,
					travelAgent: $scope.reservationData.travelAgent.id
				});
				$scope.reservationData.company.name = company.account_name;
				$scope.reservationData.company.corporateid = $scope.companyCorpId;

				// update current controller scopehandleDrawClosing
				$scope.companyName = company.account_name;
				$scope.companyCity = company.city;
				$scope.closeGuestCard();
				$scope.reservationDetails.companyCard.id = company.id;
				$scope.initCompanyCard(company);
				$scope.viewState.isAddNewCard = false;
			} else {
				if (!$scope.reservationDetails.companyCard.futureReservations || $scope.reservationDetails.companyCard.futureReservations <= 0) {
					$scope.replaceCardCaller('company', company, false);
				} else {
					$scope.checkFuture('company', company);
				}
			}

		};

		$scope.selectTravelAgent = function(travelAgent, $event) {
			$event.stopPropagation();
			//CICO-7792
			if ($scope.viewState.identifier == "CREATION") {
				// Update main reservation scope
				$scope.reservationData.travelAgent.id = travelAgent.id;
				$scope.showContractedRates({
					companyCard: $scope.reservationData.company.id,
					travelAgent: travelAgent.id
				});
				$scope.reservationData.travelAgent.name = travelAgent.account_name;
				$scope.reservationData.travelAgent.iataNumber = $scope.travelAgentIATA;

				// update current controller scope
				$scope.travelAgentName = travelAgent.account_name;
				$scope.travelAgentCity = travelAgent.city;
				$scope.closeGuestCard();
				$scope.reservationDetails.travelAgent.id = travelAgent.id;
				$scope.initTravelAgentCard(travelAgent);
				$scope.viewState.isAddNewCard = false;
			} else {
				if (!$scope.reservationDetails.travelAgent.futureReservations || $scope.reservationDetails.travelAgent.futureReservations <= 0) {
					$scope.replaceCardCaller('travel_agent', travelAgent, false);
				} else {
					$scope.checkFuture('travel_agent', travelAgent);
				}
			}
		};

		$scope.selectGuest = function(guest, $event) {
			$event.stopPropagation();
			if ($scope.viewState.identifier == "CREATION") {
				$scope.reservationData.guest.id = guest.id;
				$scope.reservationData.guest.firstName = guest.firstName;
				$scope.reservationData.guest.lastName = guest.lastName;
				$scope.reservationData.guest.city = guest.address.city;
				$scope.reservationData.guest.loyaltyNumber = $scope.guestLoyaltyNumber;

				// update current controller scope
				$scope.guestFirstName = guest.firstName;
				$scope.guestLastName = guest.lastName;
				$scope.guestCity = guest.address.city;
				$scope.guestCardData.cardHeaderImage = guest.image;
				$scope.viewState.isAddNewCard = false;
				$scope.reservationDetails.guestCard.id = guest.id;
				$scope.initGuestCard(guest);
				$scope.closeGuestCard();
			} else {
				if (!$scope.reservationDetails.guestCard.futureReservations || $scope.reservationDetails.guestCard.futureReservations <= 0) {
					$scope.replaceCardCaller('guest', guest, false);
				} else {
					$scope.checkFuture('guest', guest);
				}
			}
		};

		$scope.refreshScroll = function(elemToBeRefreshed) {
			if (typeof $scope.$parent.myScroll != 'undefined') {
				$timeout(function() {
					$scope.$parent.myScroll[elemToBeRefreshed].refresh();
				}, 300);
			}
		};
		// CREATES
		$scope.createNewGuest = function() {
			// create an empty dataModel for the guest
			var contactInfoData = {
				'contactInfo': {},
				'countries': $scope.countries,
				'userId': "",
				'avatar': "",
				'guestId': "",
				'vip': false
			};
			// // $scope.$emit('guestCardUpdateData', contactInfoData);
			$scope.guestCardData.contactInfo = contactInfoData.contactInfo;
			$scope.guestCardData.contactInfo.avatar = contactInfoData.avatar;
			$scope.guestCardData.contactInfo.vip = contactInfoData.vip;
			$scope.countriesList = contactInfoData.countries;
			$scope.guestCardData.userId = contactInfoData.userId;
			$scope.guestCardData.guestId = contactInfoData.guestId;
			$scope.guestCardData.contactInfo.birthday = null;
			var guestInfo = {
				"user_id": "",
				"guest_id": ""
			};
			// Retain Search Keys
			$scope.guestCardData.contactInfo.first_name = $scope.searchData.guestCard.guestFirstName;
			$scope.guestCardData.contactInfo.last_name = $scope.searchData.guestCard.guestLastName;
			$scope.guestCardData.contactInfo.email = $scope.searchData.guestCard.email;

			$scope.guestCardData.contactInfo.address = {};
			$scope.guestCardData.contactInfo.address.city = $scope.searchData.guestCard.guestCity;
			$scope.guestCardData.membership_no = $scope.searchData.guestCard.guestLoyaltyNumber;
			$scope.$broadcast('guestCardAvailable');
			$scope.current = 'guest-contact';
			$scope.viewState.isAddNewCard = true;
		};

		$scope.createNewCompany = function() {
			$scope.companyContactInformation = $scope.getEmptyAccountData();
			$scope.reservationDetails.companyCard.id = "";
			$scope.reservationDetails.companyCard.futureReservations = 0;
			$scope.viewState.isAddNewCard = true;
			$scope.$broadcast('companyCardAvailable', true);

		};

		$scope.createNewTravelAgent = function() {
			$scope.travelAgentInformation = $scope.getEmptyAccountData();
			$scope.reservationDetails.travelAgent.id = "";
			$scope.reservationDetails.travelAgent.futureReservations = 0;
			$scope.viewState.isAddNewCard = true;
			$scope.$broadcast('travelAgentFetchComplete', true);
		};

		$scope.clickedSaveCard = function(cardType) {
			if (cardType == "guest") {
				$scope.$broadcast("saveContactInfo");
			}
		};

		$scope.newGuestAdded = function(id) {
			$scope.viewState.isAddNewCard = false;
			$scope.viewState.pendingRemoval.status = false;
			$scope.viewState.pendingRemoval.cardType = "";
			$scope.initGuestCard({
				id: id
			});
			$scope.closeGuestCard();
		};

		$scope.$on("updateGuestEmail", function(e) {
			$scope.guestCardData.contactInfo.email = $scope.reservationData.guest.email;
		});
		//Listener to update the card info from billing info
		$scope.$on("CardInfoUpdated", function(e, card_id, card_type) {
			if (card_type == 'COMPANY_CARD') {
				$scope.reservationDetails.companyCard.id = card_id;
				$scope.initCompanyCard();
			} else {
				$scope.reservationDetails.travelAgent.id = card_id;
				$scope.initTravelAgentCard();
			}

		});

		$scope.$on('PROMPTCARDENTRY', function() {
			if (!$scope.reservationDetails.guestCard.id) {
				$scope.openGuestCard();
			}
		});


		$scope.init();

		// CICO-6049 Toggle VIP button
		$scope.vipToggleClicked = function(){
			$scope.guestCardData.contactInfo.vip = !$scope.guestCardData.contactInfo.vip;
			$scope.updateContactInfo();
		};

	}
]);