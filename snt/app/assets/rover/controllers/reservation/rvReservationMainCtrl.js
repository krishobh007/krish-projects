sntRover.controller('RVReservationMainCtrl', ['$scope', '$rootScope', 'ngDialog', '$filter', 'RVCompanyCardSrv', '$state', 'dateFilter', 'baseSearchData', 'RVReservationSummarySrv', 'RVReservationCardSrv', 'RVPaymentSrv', '$timeout', '$stateParams',
    function($scope, $rootScope, ngDialog, $filter, RVCompanyCardSrv, $state, dateFilter, baseSearchData, RVReservationSummarySrv, RVReservationCardSrv, RVPaymentSrv, $timeout, $stateParams) {

        BaseCtrl.call(this, $scope);

        $scope.$emit("updateRoverLeftMenu", "createReservation");

        var title = $filter('translate')('RESERVATION_TITLE');
        $scope.setTitle(title);
        //$scope.viewState.existingAddons = [];
        var that = this;

        //setting the main header of the screen
        $scope.heading = "Reservations";

        $scope.viewState = {
            isAddNewCard: false,
            pendingRemoval: {
                status: false,
                cardType: ""
            },
            identifier: "CREATION",
            lastCardSlot: {
                cardType: ""
            },
            reservationStatus: {
                confirm: false,
                number: null
            }
        };

        // var successCallbackOfCountryListFetch = function(data) {
        //     $scope.countries = data;
        // };

        //fetching country list
        //Commenting - Another call is happening to fetch countries
        //$scope.invokeApi(RVCompanyCardSrv.fetchCountryList, {}, successCallbackOfCountryListFetch);

        // adding extra function to reset time
        $scope.clearArrivalAndDepartureTime = function() {
            $scope.reservationData.checkinTime = {
                hh: '',
                mm: '00',
                ampm: 'AM'
            };
            $scope.reservationData.checkoutTime = {
                hh: '',
                mm: '00',
                ampm: 'AM'
            };

        };

        $scope.otherData = {};
        // needed to add an extra data variable as others were getting reset
        $scope.addonsData = {};
        $scope.addonsData.existingAddons = [];

        $scope.initReservationData = function() {
            $scope.hideSidebar = false;
            $scope.addonsData.existingAddons = [];
            // intialize reservation object
            $scope.reservationData = {
                isHourly: false,
                isValidDeposit: false,
                arrivalDate: '',
                departureDate: '',
                midStay: false, // Flag to check in edit mode if in the middle of stay
                stayDays: [],
                resHours: 1,
                checkinTime: {
                    hh: '',
                    mm: '00',
                    ampm: 'AM'
                },
                checkoutTime: {
                    hh: '',
                    mm: '00',
                    ampm: 'AM'
                },
                taxDetails: {},
                numNights: 1, // computed value, ensure to keep it updated
                roomCount: 1, // Hard coded for now,
                rooms: [{
                    numAdults: 1,
                    numChildren: 0,
                    numInfants: 0,
                    roomTypeId: '',
                    roomTypeName: '',
                    rateId: '',
                    rateName: '',
                    rateAvg: 0,
                    rateTotal: 0,
                    addons: [],
                    varyingOccupancy: false,
                    stayDates: {},
                    isOccupancyCheckAlerted: false
                }],
                totalTaxAmount: 0, //This is for ONLY exclusive taxes
                totalStayCost: 0,
                totalTax: 0, // CICO-10161 > This stores the tax inclusive and exclusive together
                guest: {
                    id: null, // if new guest, then it is null, other wise his id
                    firstName: '',
                    lastName: '',
                    email: '',
                    city: '',
                    loyaltyNumber: '',
                    sendConfirmMailTo: ''
                },
                company: {
                    id: null, // if new company, then it is null, other wise his id
                    name: '',
                    corporateid: '', // Add different fields for company as in story
                },
                travelAgent: {
                    id: null, // if new , then it is null, other wise his id
                    name: '',
                    iataNumber: '', // Add different fields for travelAgent as in story
                },
                paymentType: {
                    type: {},
                    ccDetails: { //optional - only if credit card selected
                        number: '',
                        expMonth: '',
                        expYear: '',
                        nameOnCard: ''
                    }
                },
                demographics: {
                    market: '',
                    source: '',
                    reservationType: '',
                    origin: ''
                },
                promotion: {
                    promotionCode: '',
                    promotionType: ''
                },
                status: '', //reservation status
                reservationId: '',
                confirmNum: '',
                isSameCard: false, // Set flag to retain the card details,
                rateDetails: [], // This array would hold the configuration information of rates selected for each room
                isRoomRateSuppressed: false, // This variable will hold flag to check whether any of the room rates is suppressed?
                reservation_card: {},
                number_of_infants:0,
                number_of_adults:0,
                number_of_children:0                

            };

            $scope.searchData = {
                guestCard: {
                    guestFirstName: "",
                    guestLastName: "",
                    guestCity: "",
                    guestLoyaltyNumber: "",
                    email: ""
                },
                companyCard: {
                    companyName: "",
                    companyCity: "",
                    companyCorpId: ""
                },
                travelAgentCard: {
                    travelAgentName: "",
                    travelAgentCity: "",
                    travelAgentIATA: ""
                }
            };
            // default max value if max_adults, max_children, max_infants is not configured
            var defaultMaxvalue = 5;
            var guestMaxSettings = baseSearchData.settings.max_guests;

            /**
             *   We have moved the fetching of 'baseData' form 'rover.reservation' state
             *   to the states where it actually requires it.
             *
             *   Now we do want to bind the baseData so we have created a 'callFromChildCtrl' (last method).
             *
             *   Once that state controller fetch 'baseData', it will find this controller
             *   by climbing the $socpe.$parent ladder and will call 'callFromChildCtrl' method.
             */

            $scope.otherData.taxesMeta = [];
            $scope.otherData.promotionTypes = [{
                value: "v1",
                description: "The first"
            }, {
                value: "v2",
                description: "The Second"
            }];
            $scope.otherData.maxAdults = (guestMaxSettings.max_adults === null || guestMaxSettings.max_adults === '') ? defaultMaxvalue : guestMaxSettings.max_adults;
            $scope.otherData.maxChildren = (guestMaxSettings.max_children === null || guestMaxSettings.max_children === '') ? defaultMaxvalue : guestMaxSettings.max_children;
            $scope.otherData.maxInfants = (guestMaxSettings.max_infants === null || guestMaxSettings.max_infants === '') ? defaultMaxvalue : guestMaxSettings.max_infants;
            $scope.otherData.roomTypes = baseSearchData.roomTypes;
            $scope.otherData.fromSearch = false;
            $scope.otherData.recommendedRateDisplay = baseSearchData.settings.recommended_rate_display;
            $scope.otherData.defaultRateDisplayName = baseSearchData.settings.default_rate_display_name;
            $scope.otherData.businessDate = baseSearchData.businessDate;
            $scope.otherData.additionalEmail = "";
            $scope.otherData.isGuestPrimaryEmailChecked = false;
            $scope.otherData.isGuestAdditionalEmailChecked = false;
            $scope.otherData.reservationCreated = false;

            $scope.guestCardData = {};
            $scope.guestCardData.cardHeaderImage = "/assets/avatar-trans.png";
            $scope.guestCardData.contactInfo = {};
            $scope.guestCardData.userId = '';

            $scope.guestCardData.contactInfo.birthday = '';

            $scope.reservationListData = {};

            $scope.reservationDetails = {
                guestCard: {
                    id: "",
                    futureReservations: 0
                },
                companyCard: {
                    id: "",
                    futureReservations: 0
                },
                travelAgent: {
                    id: "",
                    futureReservations: 0
                }
            };
        };

        $scope.reset_guest_details = function() {
            $scope.reservationData.guest = {
                id: null, // if new guest, then it is null, other wise his id
                firstName: '',
                lastName: '',
                email: '',
                city: '',
                loyaltyNumber: '',
                sendConfirmMailTo: ''
            };
            $scope.reservationDetails.guestCard = {
                id: "",
                futureReservations: 0
            };

        }

        $scope.reset_company_details = function() {
            $scope.reservationData.company = {
                id: null, // if new company, then it is null, other wise his id
                name: '',
                corporateid: '', // Add different fields for company as in story
            };

            $scope.reservationDetails.companyCard = {
                id: "",
                futureReservations: 0
            }

        };

        $scope.reset_travel_details = function() {
            $scope.reservationData.travelAgent = {
                id: null, // if new , then it is null, other wise his id
                name: '',
                iataNumber: '', // Add different fields for travelAgent as in story
            };
            $scope.reservationDetails.travelAgent = {
                id: "",
                futureReservations: 0
            };
        }

        $scope.initReservationDetails = function() {
            // Initiate All Cards 
            $scope.reservationDetails.guestCard.id = "";
            $scope.reservationDetails.guestCard.futureReservations = 0;
            $scope.reservationDetails.companyCard.id = "";
            $scope.reservationDetails.companyCard.futureReservations = 0;
            $scope.reservationDetails.travelAgent.id = "";
            $scope.reservationDetails.travelAgent.futureReservations = 0;

            $scope.viewState = {
                isAddNewCard: false,
                pendingRemoval: {
                    status: false,
                    cardType: ""
                },
                identifier: "CREATION",
                lastCardSlot: {
                    cardType: ""
                },
                reservationStatus: {
                    confirm: false,
                    number: null
                }
            };
        };


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
                    "billing_information": "Test"
                },
                "primary_contact_details": {
                    "contact_first_name": null,
                    "contact_last_name": null,
                    "contact_job_title": null,
                    "contact_phone": null,
                    "contact_email": null
                },
                "future_reservation_count": 0
            };
        };



        //CICO-7641
        var isOccupancyConfigured = function(roomIndex) {
            var rateConfigured = true;
            if (typeof $scope.reservationData.rateDetails[roomIndex] != "undefined") {
                _.each($scope.reservationData.rateDetails[roomIndex], function(d, dateIter) {
                    if (dateIter != $scope.reservationData.departureDate && $scope.reservationData.rooms[roomIndex].stayDates[dateIter].rate.id != '' && parseFloat($scope.reservationData.rooms[roomIndex].stayDates[dateIter].rateDetails.actual_amount) != 0.00) {
                        var rateToday = d[$scope.reservationData.rooms[roomIndex].stayDates[dateIter].rate.id].rateBreakUp;
                        var numAdults = parseInt($scope.reservationData.rooms[roomIndex].stayDates[dateIter].guests.adults);
                        var numChildren = parseInt($scope.reservationData.rooms[roomIndex].stayDates[dateIter].guests.children);

                        if (rateToday.single == null && rateToday.double == null && rateToday.extra_adult == null && rateToday.child == null) {
                            rateConfigured = false;
                        } else {
                            // Step 2: Check for the other constraints here
                            // Step 2 A : Children
                            if (numChildren > 0 && rateToday.child == null) {
                                rateConfigured = false;
                            } else if (numAdults == 1 && rateToday.single == null) { // Step 2 B: one adult - single needs to be configured
                                rateConfigured = false;
                            } else if (numAdults >= 2 && rateToday.double == null) { // Step 2 C: more than one adult - double needs to be configured
                                rateConfigured = false;
                            } else if (numAdults > 2 && rateToday.extra_adult == null) { // Step 2 D: more than two adults - need extra_adult to be configured
                                rateConfigured = false;
                            }
                        }
                    }
                });
            }
            return rateConfigured;
        };

        $scope.checkOccupancyLimit = function(date, reset) {
            //CICO-11716
            if ($scope.reservationData.isHourly) {
                return false;
            } else {
                var roomIndex = 0;
                if (isOccupancyConfigured(roomIndex)) {
                    $scope.reservationData.rooms[roomIndex].varyingOccupancy = $scope.reservationUtils.isVaryingOccupancy(roomIndex);
                    $scope.computeTotalStayCost(reset);
                    var activeRoom = $scope.reservationData.rooms[roomIndex].roomTypeId;
                    var currOccupancy = parseInt($scope.reservationData.rooms[roomIndex].numChildren) +
                        parseInt($scope.reservationData.rooms[roomIndex].numAdults);
                    if (date) {
                        // If there is an date sent as a param the occupancy check has to be done for the particular day
                        currOccupancy = parseInt($scope.reservationData.rooms[roomIndex].stayDates[date].guests.adults) + parseInt($scope.reservationData.rooms[roomIndex].stayDates[date].guests.children);
                    }

                    var getMaxOccupancy = function(roomId) {
                        var max = -1;
                        var name = "";
                        $($scope.otherData.roomTypes).each(function(i, d) {
                            if (roomId == d.id) {
                                max = d.max_occupancy;
                                name = d.name;
                            }
                        });
                        return {
                            max: max,
                            name: name
                        };
                    };

                    var roomPref = getMaxOccupancy(activeRoom);

                    if (typeof activeRoom == 'undefined' || activeRoom == null || activeRoom == "" || roomPref.max == null || roomPref.max >= currOccupancy) {
                        return true;
                    }
                    // CICO-9575: The occupancy warning should pop up only once during the reservation process if no changes are being made to the room type.
                    if ((!$scope.reservationData.rooms[roomIndex].isOccupancyCheckAlerted || $scope.reservationData.rooms[roomIndex].isOccupancyCheckAlerted != activeRoom) && $state.current.name != "rover.reservation.staycard.reservationcard.reservationdetails") {
                        ngDialog.open({
                            template: '/assets/partials/reservation/alerts/occupancy.html',
                            className: 'ngdialog-theme-default',
                            scope: $scope,
                            closeByDocument: false,
                            closeByEscape: false,
                            data: JSON.stringify({
                                roomType: roomPref.name,
                                roomMax: roomPref.max
                            })
                        });
                        // CICO-9575: The occupancy warning should pop up only once during the reservation process if no changes are being made to the room type.
                        $scope.reservationData.rooms[roomIndex].isOccupancyCheckAlerted = activeRoom;
                    }
                    return true;
                } else {
                    // TODO: 7641
                    // prompt user that the room doesn't have a rate configured for the current availability
                    ngDialog.open({
                        template: '/assets/partials/reservation/alerts/notConfiguredOccupancy.html',
                        className: 'ngdialog-theme-default',
                        scope: $scope,
                        closeByDocument: false,
                        closeByEscape: false,
                        data: JSON.stringify({
                            roomIndex: roomIndex
                        })
                    });
                }
            }
        };

        $scope.resetRoomSelection = function(roomIndex) {
            $scope.editRoomRates(roomIndex);
            $scope.closeDialog();
        };

        /*
         * This method will return the tax details for the amount and the tax provided
         * The computation happens at day level as the rate details can be varying for each day!
         */

        $scope.calculateTax = function(date, amount, taxes, roomIndex, forAddons) {

            var taxInclusiveTotal = 0.0; //Per Night Inclusive Charges
            var taxExclusiveTotal = 0.0; //Per Night Exclusive Charges
            var taxesLookUp = {};
            /* --The above two are required only for the room and rates section where we 
             *  do not display the STAY taxes
             */
            var taxInclusiveStayTotal = 0.0; //Per Stay Inclusive Charges
            var taxExclusiveStayTotal = 0.0; //Per Stay Exlusive Charges

            if (date instanceof Date) {
                date = new tzIndependentDate(date).toComponents().date.toDateString();
            }
            var taxDescription = [];
            var adults = $scope.reservationData.rooms[roomIndex].stayDates[date].guests.adults;
            var children = $scope.reservationData.rooms[roomIndex].stayDates[date].guests.children;
            var nights = $scope.reservationData.numNights;

            _.each(taxes, function(tax) {
                //for every tax that is associated to the date proceed
                var isInclusive = tax.is_inclusive;
                var taxDetails = _.where($scope.otherData.taxesMeta, {
                    id: parseInt(tax.charge_code_id)
                });
                if (taxDetails.length == 0) {
                    //Error condition! Tax code in results but not in meta data
                } else {
                    var taxData = taxDetails[0];
                    // Need not consider perstay here
                    var taxAmount = taxData.amount;
                    if (taxData.amount_sign != "+") {
                        taxData.amount = parseFloat(taxData.amount * -1.0);
                    }
                    var taxAmountType = taxData.amount_type;
                    var multiplicity = 1; // for amount_type = flat
                    if (taxAmountType == "ADULT") {
                        multiplicity = adults;
                    } else if (taxAmountType == "CHILD") {
                        multiplicity = children;
                    } else if (taxAmountType == "PERSON") {
                        multiplicity = parseInt(children) + parseInt(adults);
                    }


                    var taxOnAmount = amount;

                    if (!!tax.calculation_rules.length) {
                        _.each(tax.calculation_rules, function(tax) {
                            taxOnAmount = parseFloat(taxOnAmount) + parseFloat(taxesLookUp[tax]);
                        });
                    }

                    /*
                     *  THE TAX CALCULATION HAPPENS HERE
                     */
                    var taxCalculated = 0;
                    if (taxData.amount_symbol == '%' && parseFloat(taxData.amount) != 0.0) {
                        taxCalculated = parseFloat(multiplicity * (parseFloat(taxData.amount / 100) * taxOnAmount));
                    } else {
                        taxCalculated = parseFloat(multiplicity * parseFloat(taxData.amount));
                    }

                    taxesLookUp[taxData.id] = taxCalculated;
                    if (forAddons && taxData.post_type == 'NIGHT') {
                        /**
                         * CICO-9576
                         * QA Comment
                         * 1. the tax amount seems to multiply twice with the number of nights. It shows correctly for 1 nights stays, but for 2 nights it is x4, for 3 nights x6 etc.
                         * 1 adult 3 nights
                         * Room per night $100, add on per night $20 .. 
                         * Both room and addon have charge codes of 12.5% and 2% on base +12.5% and have post type night
                         *
                         * Hence the multiplication as reported by Nicole.
                         * tax for $300 12.5% should be: 37.50
                           tax for $60 breakfast 12.5% should be: 7.50
                           so total $45
                           but it shows $60 because it takes the 7.50 *3
                           (resv is for 3 nights)
                           if I make a resv for 1 night it shows correctly
                           same for the 2% tax
                         *
                         * Hence not multiplying the nights with the price in the case of the addon
                         * // taxesLookUp[taxData.id] = parseFloat(taxCalculated) * parseFloat(nights);
                         */

                        taxesLookUp[taxData.id] = parseFloat(taxCalculated);
                    }

                    if (taxData.post_type == 'NIGHT') { // NIGHT tax computations
                        if (isInclusive) {
                            taxInclusiveTotal = parseFloat(taxInclusiveTotal) + parseFloat(taxCalculated);
                        } else {
                            taxExclusiveTotal = parseFloat(taxExclusiveTotal) + parseFloat(taxCalculated);
                        }
                    } else { // STAY tax computations                 
                        if (isInclusive) {
                            taxInclusiveStayTotal = parseFloat(taxInclusiveTotal) + parseFloat(taxCalculated);
                        } else {
                            taxExclusiveStayTotal = parseFloat(taxExclusiveTotal) + parseFloat(taxCalculated);
                        }
                    }
                    taxDescription.push({
                        postType: taxData.post_type,
                        isInclusive: isInclusive,
                        amount: taxCalculated,
                        id: taxData.id,
                        description: taxData.description,
                        roomIndex: roomIndex
                    });
                }
            });
            return {
                inclusive: taxInclusiveTotal,
                exclusive: taxExclusiveTotal,
                stayInclusive: taxInclusiveStayTotal,
                stayExclusive: taxExclusiveStayTotal,
                taxDescription: taxDescription
            };
        };


        $scope.computeTotalStayCost = function(reset) {
            // TODO : Loop thru all rooms
            var roomIndex = 0;
            var currentRoom = $scope.reservationData.rooms[roomIndex];

            //compute stay cost for the current room
            var adults = currentRoom.numAdults;
            var children = currentRoom.numChildren;
            var roomTotal = 0;
            var roomTax = 0;
            var roomAvg = 0;
            var totalTaxes = 0; // only exclusive
            var taxesInclusiveExclusive = 0; // CICO-10161 > holds both inclusive and exclusive
            var taxes = currentRoom.taxes;
            $scope.reservationData.taxDetails = {};

            _.each($scope.reservationData.rateDetails[roomIndex], function(d, date) {
                if ((date != $scope.reservationData.departure_date || $scope.reservationData.numNights == 0) && $scope.reservationData.rooms[roomIndex].stayDates[date].rate.id != '') {

                    var rateToday = d[$scope.reservationData.rooms[roomIndex].stayDates[date].rate.id].rateBreakUp;
                    var taxes = d[$scope.reservationData.rooms[roomIndex].stayDates[date].rate.id].taxes;

                    adults = parseInt($scope.reservationData.rooms[roomIndex].stayDates[date].guests.adults);
                    children = parseInt($scope.reservationData.rooms[roomIndex].stayDates[date].guests.children);

                    var baseRoomRate = adults >= 2 ? rateToday.double : rateToday.single;
                    var extraAdults = adults >= 2 ? adults - 2 : 0;
                    var roomAmount = baseRoomRate + (extraAdults * rateToday.extra_adult) + (children * rateToday.child);

                    if (reset) {
                        $scope.reservationData.rooms[roomIndex].stayDates[date].rateDetails.actual_amount = roomAmount;
                        $scope.reservationData.rooms[roomIndex].stayDates[date].rateDetails.modified_amount = roomAmount;
                    }

                    //CICO-6079
                    if ($scope.reservationData.rooms[roomIndex].stayDates[date] && $scope.reservationData.rooms[roomIndex].stayDates[date].rateDetails) {
                        if ($scope.reservationData.rooms[roomIndex].stayDates[date].rateDetails.actual_amount !=
                            $scope.reservationData.rooms[roomIndex].stayDates[date].rateDetails.modified_amount)
                            roomAmount = parseFloat($scope.reservationData.rooms[roomIndex].stayDates[date].rateDetails.modified_amount);
                    }

                    roomTotal = roomTotal + roomAmount;

                    if (!!taxes && !!taxes.length) {
                        //  We get the tax details for the specific day here
                        var taxApplied = $scope.calculateTax(date, roomAmount, taxes, roomIndex);
                        //  Note: Got to add the exclusive taxes into the tax Amount thing
                        var taxAmount = 0;
                        var taxAll = 0; // CICO-10161
                        //  Compile up the data to be shown for the tax breakup
                        //  Add up the inclusive taxes & exclusive taxes pernight
                        //  TODO: PERSTAY TAXES TO BE COMPUTED HERE [[[[[[[[PER_STAY NEEDS TO BE DONE ONLY ONCE FOR A RATE ID & TAX ID COMBO]]]]]]]]
                        _.each(taxApplied.taxDescription, function(description, index) {
                            description.rate = $scope.reservationData.rooms[roomIndex].stayDates[date].rate.id;
                            if (description.postType == "NIGHT") {
                                if (typeof $scope.reservationData.taxDetails[description.id] == "undefined") {
                                    $scope.reservationData.taxDetails[description.id] = description;
                                } else {
                                    // add the amount here
                                    $scope.reservationData.taxDetails[description.id].amount = parseFloat($scope.reservationData.taxDetails[description.id].amount) + parseFloat(description.amount);
                                }
                                taxAmount = parseFloat(taxApplied.exclusive);
                                taxAll = parseFloat(taxApplied.exclusive) + parseFloat(taxApplied.inclusive); // CICO-10161

                            } else { //[[[[[[ PER_STAY NEEDS TO BE DONE ONLY ONCE FOR A RATE ID & TAX ID COMBO]]]]]]
                                if (typeof $scope.reservationData.taxDetails[description.id] == "undefined") {
                                    // As stated earler per_stay taxes can be taken in only for the first rateId
                                    if (_.isEmpty($scope.reservationData.taxDetails)) {
                                        $scope.reservationData.taxDetails[description.id] = description;
                                    } else {
                                        //get the rateId of the first value in the $scope.reservationData.taxDetail
                                        var rateIdExisting = $scope.reservationData.taxDetails[Object.keys($scope.reservationData.taxDetails)[0]].rate;
                                        if (rateIdExisting == description.rate) {
                                            $scope.reservationData.taxDetails[description.id] = description;
                                        }
                                    }
                                } else {
                                    /*
                                     *   --NOTE: For the same rateId there could be different rates across the stay period.
                                     *   For the above scenario if the PERSTAY tax is say some x% of the rate,
                                     *   we would be having different rates >>> WHAT TO DO? For now sticking to the larger number
                                     *   Now, even better: Say there are multiple rateIds selected, or even for this comment's sake a single rate for the all stay dates
                                     *   but there are multiple occupancies and the taxes arent flat, but they are PER_PERSON/ PER_CHILD / PER_ADULT
                                     *   ThereAgain : for now sticking to the largest tax amount of all
                                     *   === TODO === Mail product team for a clarification on this!!!
                                     */
                                    $scope.reservationData.taxDetails[description.id].amount = $scope.reservationData.taxDetails[description.id].amount > description.amount ? $scope.reservationData.taxDetails[description.id].amount : description.amount;
                                }
                            }

                        });
                        //  update the total Tax Amount to be shown                        
                        totalTaxes = parseFloat(totalTaxes) + parseFloat(taxAmount);
                        taxesInclusiveExclusive = parseFloat(taxesInclusiveExclusive) + parseFloat(taxAll); // CICO-10161
                    }
                }
            });

            // Add exclusiveStayTaxes
            var exclusiveStayTaxes = _.where($scope.reservationData.taxDetails, {
                postType: 'STAY',
                isInclusive: false
            });
            _.each(exclusiveStayTaxes, function(description, index) {
                totalTaxes = parseFloat(totalTaxes) + parseFloat(description.amount);
            });

            _.each($scope.reservationData.taxDetails, function(description, index) {
                if (description.postType == 'STAY') {
                    taxesInclusiveExclusive = parseFloat(taxesInclusiveExclusive) + parseFloat(description.amount);
                }
            });



            currentRoom.rateTotal = parseFloat(roomTotal) + parseFloat(roomTax);
            currentRoom.rateAvg = currentRoom.rateTotal / ($scope.reservationData.numNights == 0 ? 1 : $scope.reservationData.numNights);

            //Calculate Addon Addition for the room
            var addOnCumulative = 0;
            $(currentRoom.addons).each(function(i, addon) {
                //Amount_Types
                // 1   ADULT   
                // 2   CHILD   
                // 3   PERSON  
                // 4   FLAT
                // The Amount Type is available in the amountType object of the selected addon
                // ("AT", addon.amountType.value)

                //Post Types
                // 1   STAY   
                // 2   NIGHT  
                // The Post Type is available in the postType object of the selected addon
                // ("PT", addon.postType.value)

                //TODO: IN CASE OF DATA ERRORS MAKE FLAT STAY AS DEFAULT

                var baseRate = parseFloat(addon.quantity) * parseFloat(addon.price);

                var finalRate = baseRate;

                var getAddonRateForDay = function(amountType, baseRate, numAdults, numChildren) {
                    if (amountType == "PERSON") {
                        return baseRate * parseInt(parseInt(numAdults) + parseInt(numChildren));
                    } else if (addon.amountType.value == "CHILD") {
                        return baseRate * parseInt(numChildren);
                    } else if (addon.amountType.value == "ADULT") {
                        return baseRate * parseInt(numAdults);
                    }
                    return baseRate;
                };

                if (addon.postType.value == "STAY" && parseInt($scope.reservationData.numNights) > 1) {
                    var cumulativeRate = 0
                    _.each(currentRoom.stayDates, function(stayDate, date) {
                        if (date !== $scope.reservationData.departureDate)
                            cumulativeRate = parseFloat(cumulativeRate) + parseFloat(getAddonRateForDay(
                                addon.amountType.value,
                                baseRate,
                                stayDate.guests.adults, // Using EACH night's occupancy information to calculate the addon's applicable amount!
                                stayDate.guests.children
                            )); // cummulative sum (Not just multiplication of rate per day with the num of nights) >> Has to done at "day level" to handle the reservations with varying occupancy!
                    });
                    finalRate = cumulativeRate;
                } else {
                    finalRate = parseFloat(getAddonRateForDay(
                        addon.amountType.value,
                        baseRate,
                        currentRoom.numAdults, // Using FIRST night's occupancy information to calculate the addon's applicable amount!
                        currentRoom.numChildren
                    ));
                }

                //  CICO-9576 => TAXES FOR ADDONS

                /**
                 * Update finalRate for the current addon!
                 * finalRate = finalRate + taxOn(finalRate)
                 * Taxes associated with the addon will be present in addon.taxDetail array.
                 * TODO :   Try to use the existing calculateTax method available to compute the tax on the finalRate value for the addon
                 *          To find out how significant the date's value could be in affecting the tax computation.
                 *          Days will have varyiung occupancies and addons rates are calculated based on the occupancies
                 *          In case of addons with the amountType as person/child/adult we will have to consider the occupancy, in which case a varying occupancy adds to the existing confusion,
                 *          To begin with, ASSUMING that occupancy of the first day is taken into consideration for such calculation, we can pass the arrival date to the $scope.calculateTax method
                 *              so that the occupancy is considered for that day.
                 *          ALSO, current granularity of the method is per day... whereas we compute the addon stuff on the whole stay... so multiplicity in case of PER_NIGHT will have to be
                 *              taken into consideration!    [IMPORTANT]
                 */

                // we are sending the arrivaldate as in case of varying occupancies, it is ASSUMED that we go forward with the first day's occupancy
                var taxApplied = $scope.calculateTax($scope.reservationData.arrivalDate, finalRate, addon.taxDetail, roomIndex, true);

                // Go through the tax applied and update the calculations such that
                // When Add-on items are being added to a reservation, their respective tax should also be added to the reservation summary screen, to 
                //      a) the respective tax charge code (can be grouped with accommodation tax charge, should not be a separate line if the same tax charge code already exists)
                //      b) the total tax amount

                var taxAmount = 0;
                var taxAll = 0; // CICO-10161
                _.each(taxApplied.taxDescription, function(description, index) {
                    if (description.postType == "NIGHT") {
                        var nights = $scope.reservationData.numNights || 1;
                        if (typeof $scope.reservationData.taxDetails[description.id] == "undefined") {
                            $scope.reservationData.taxDetails[description.id] = description;
                        } else {
                            // add the amount here
                            // Note Got to multiply with the number of days as this is a per night tax                            
                            var nights = $scope.reservationData.numNights == 0 ? 1 : $scope.reservationData.numNights;
                            if (addon.postType.value == "NIGHT") nights = 1; // Based on Nicole's comments the addons override their taxes in the post type dimension
                            /**
                                 * CICO-9576
                                 * QA Comment
                                 * 1. the tax amount seems to multiply twice with the number of nights. It shows correctly for 1 nights stays, but for 2 nights it is x4, for 3 nights x6 etc.
                                 * 1 adult 3 nights
                                 * Room per night $100, add on per night $20 .. 
                                 * Both room and addon have charge codes of 12.5% and 2% on base +12.5% and have post type night
                                 *
                                 * Hence the multiplication as reported by Nicole.
                                 * tax for $300 12.5% should be: 37.50
                                   tax for $60 breakfast 12.5% should be: 7.50
                                   so total $45
                                   but it shows $60 because it takes the 7.50 *3
                                   (resv is for 3 nights)
                                   if I make a resv for 1 night it shows correctly
                                   same for the 2% tax
                                 *
                                 * Hence not multiplying the nights with the price in the case of the addon
                                 * // $scope.reservationData.taxDetails[description.id].amount = parseFloat($scope.reservationData.taxDetails[description.id].amount) + (nights * parseFloat(description.amount));
                                 */
                            $scope.reservationData.taxDetails[description.id].amount = parseFloat($scope.reservationData.taxDetails[description.id].amount) + (parseFloat(description.amount));
                        }
                        taxAmount = parseFloat(nights * taxApplied.exclusive);
                        taxAll = parseFloat(nights * taxApplied.exclusive) + parseFloat(nights * taxApplied.inclusive); // CICO-10161
                    } else { //STAY
                        if (typeof $scope.reservationData.taxDetails[description.id] == "undefined") {
                            $scope.reservationData.taxDetails[description.id] = description;
                        } else {
                            $scope.reservationData.taxDetails[description.id].amount = parseFloat($scope.reservationData.taxDetails[description.id].amount) + parseFloat(description.amount);
                        }
                        taxAmount = parseFloat(taxApplied.exclusive);
                        taxAll = parseFloat(taxApplied.exclusive) + parseFloat(taxApplied.inclusive); // CICO-10161
                    }
                });

                totalTaxes = parseFloat(totalTaxes) + parseFloat(taxAmount);
                taxesInclusiveExclusive = parseFloat(taxesInclusiveExclusive) + parseFloat(taxAll); // CICO-10161

                //  CICO-9576

                addOnCumulative += parseInt(finalRate);
                addon.effectivePrice = finalRate;
            });


            //TODO: Extend for multiple rooms
            $scope.reservationData.totalTaxAmount = totalTaxes;
            $scope.reservationData.totalStayCost = parseFloat(currentRoom.rateTotal) + parseFloat(addOnCumulative) + parseFloat(totalTaxes);
            $scope.reservationData.totalTax = taxesInclusiveExclusive; // CICO-10161

        };


        $scope.editRoomRates = function(roomIdx) {
            //TODO: Navigate back to roomtype selection screen after resetting the current room options
            $scope.reservationData.rooms[roomIdx].roomTypeId = '';
            $scope.reservationData.rooms[roomIdx].roomTypeName = '';
            $scope.reservationData.rooms[roomIdx].rateId = '';
            $scope.reservationData.rooms[roomIdx].rateName = '';
            $scope.reservationData.demographics = {
                market: '',
                source: '',
                reservationType: '',
                origin: ''
            };

            // Redo the staydates array
            for (var d = [], ms = new tzIndependentDate($scope.reservationData.arrivalDate) * 1, last = new tzIndependentDate($scope.reservationData.departureDate) * 1; ms <= last; ms += (24 * 3600 * 1000)) {
                $scope.reservationData.rooms[roomIdx].stayDates[dateFilter(new tzIndependentDate(ms), 'yyyy-MM-dd')].rate = {
                    id: ''
                };
            };

            $state.go('rover.reservation.staycard.mainCard.roomType', {
                from_date: $scope.reservationData.arrivalDate,
                to_date: $scope.reservationData.departureDate,
                fromState: 'rover.reservation.search',
                company_id: $scope.reservationData.company.id,
                travel_agent_id: $scope.reservationData.travelAgent.id
            });
        };

        $scope.updateOccupancy = function(roomIdx) {
            for (var d = [], ms = new tzIndependentDate($scope.reservationData.arrivalDate) * 1, last = new tzIndependentDate($scope.reservationData.departureDate) * 1; ms <= last; ms += (24 * 3600 * 1000)) {
                $scope.reservationData.rooms[roomIdx].stayDates[dateFilter(new tzIndependentDate(ms), 'yyyy-MM-dd')].guests = {
                    adults: parseInt($scope.reservationData.rooms[roomIdx].numAdults),
                    children: parseInt($scope.reservationData.rooms[roomIdx].numChildren),
                    infants: parseInt($scope.reservationData.rooms[roomIdx].numInfants)
                }
            };
        };

        /*
            This function is called once the stay card loads and 
            populates the $scope.reservationData object with the current reservation's data.

            This is done to enable use of the $scope.reservationData object in the subsequent screens in 
            the flow from the staycards 
        */

        $scope.populateDataModel = function(reservationDetails) {
            /*
                CICO-8320 parse the reservation Details and store the data in the
                $scope.reservationData model
            */
            //status
            $scope.reservationData.status = reservationDetails.reservation_card.reservation_status;

            // id
            $scope.reservationData.confirmNum = reservationDetails.reservation_card.confirmation_num;
            $scope.reservationData.reservationId = reservationDetails.reservation_card.reservation_id;

            $scope.reservationData.arrivalDate = reservationDetails.reservation_card.arrival_date;
            $scope.reservationData.departureDate = reservationDetails.reservation_card.departure_date;
            $scope.reservationData.numNights = reservationDetails.reservation_card.total_nights;

            $scope.reservationData.isHourly = reservationDetails.reservation_card.is_hourly_reservation;

            $scope.reservationData.number_of_infants = reservationDetails.reservation_card.number_of_infants;
            $scope.reservationData.number_of_adults = reservationDetails.reservation_card.number_of_adults;
            $scope.reservationData.number_of_children = reservationDetails.reservation_card.number_of_children;


            /** CICO-6135
             *   TODO : Change the hard coded values to take the ones coming from the reservation_details API call
             */
            //  reservationDetails.reservation_card.departureDate ! = null
            if (reservationDetails.reservation_card.arrival_time) {
                var timeParts = reservationDetails.reservation_card.arrival_time.trim().split(" ");
                //flooring to nearest 15th as the select element's options are in 15s
                var hourMinutes = timeParts[0].split(":");
                hourMinutes[1] = (15 * Math.round(hourMinutes[1] / 15) % 60).toString();
                $scope.reservationData.checkinTime = {
                        hh: hourMinutes[0].length == 1 ? "0" + hourMinutes[0] : hourMinutes[0],
                        mm: hourMinutes[1].length == 1 ? "0" + hourMinutes[1] : hourMinutes[1],
                        ampm: timeParts[1]
                    }
                    // reservationDetails.reservation_card.arrival_time = parseInt($scope.reservationData.checkinTime.hh) + ":" + $scope.reservationData.checkinTime.mm + " " + $scope.reservationData.checkinTime.ampm;
            }


            // Handling late checkout
            if (reservationDetails.reservation_card.is_opted_late_checkout && reservationDetails.reservation_card.late_checkout_time) {
                var timeParts = reservationDetails.reservation_card.late_checkout_time.trim().split(" ");
                var hourMinutes = timeParts[0].split(":");
                //flooring to nearest 15th as the select element's options are in 15s
                hourMinutes[1] = (15 * Math.round(hourMinutes[1] / 15) % 60).toString();
                $scope.reservationData.checkoutTime = {
                        hh: hourMinutes[0].length == 1 ? "0" + hourMinutes[0] : hourMinutes[0],
                        mm: hourMinutes[1].length == 1 ? "0" + hourMinutes[1] : hourMinutes[1],
                        ampm: timeParts[1]
                    }
                    // reservationDetails.reservation_card.late_checkout_time = parseInt($scope.reservationData.checkoutTime.hh) + ":" + $scope.reservationData.checkoutTime.mm + " " + $scope.reservationData.checkoutTime.ampm;
            }
            //  reservationDetails.reservation_card.departureDate ! = null   
            else if (reservationDetails.reservation_card.departure_time) {
                var timeParts = reservationDetails.reservation_card.departure_time.trim().split(" ");
                var hourMinutes = timeParts[0].split(":");
                //flooring to nearest 15th as the select element's options are in 15s
                hourMinutes[1] = (15 * Math.round(hourMinutes[1] / 15) % 60).toString();
                $scope.reservationData.checkoutTime = {
                        hh: hourMinutes[0].length == 1 ? "0" + hourMinutes[0] : hourMinutes[0],
                        mm: hourMinutes[1].length == 1 ? "0" + hourMinutes[1] : hourMinutes[1],
                        ampm: timeParts[1]
                    }
                    // reservationDetails.reservation_card.departure_time = parseInt($scope.reservationData.checkoutTime.hh) + ":" + $scope.reservationData.checkoutTime.mm + " " + $scope.reservationData.checkoutTime.ampm;
            }



            // cards
            $scope.reservationData.company.id = $scope.reservationListData.company_id;
            $scope.reservationData.travelAgent.id = $scope.reservationListData.travel_agent_id;
            $scope.reservationData.guest.id = $scope.reservationListData.guest_details.user_id;

            //demographics
            $scope.reservationData.demographics.reservationType = reservationDetails.reservation_card.reservation_type_id == null ? "" : reservationDetails.reservation_card.reservation_type_id;
            $scope.reservationData.demographics.market = reservationDetails.reservation_card.market_segment_id == null ? "" : reservationDetails.reservation_card.market_segment_id;
            $scope.reservationData.demographics.source = reservationDetails.reservation_card.source_id == null ? "" : reservationDetails.reservation_card.source_id;
            $scope.reservationData.demographics.origin = reservationDetails.reservation_card.booking_origin_id == null ? "" : reservationDetails.reservation_card.booking_origin_id;

            // TODO : This following LOC has to change if the room number changes to an array
            // to handle multiple rooms in future
            $scope.reservationData.rooms[0].roomNumber = reservationDetails.reservation_card.room_number;
            $scope.reservationData.rooms[0].roomTypeDescription = reservationDetails.reservation_card.room_type_description;
            //cost
            $scope.reservationData.rooms[0].rateAvg = reservationDetails.reservation_card.avg_daily_rate;
            $scope.reservationData.rooms[0].rateTotal = reservationDetails.reservation_card.total_rate;
            $scope.reservationData.rooms[0].rateName = reservationDetails.reservation_card.is_multiple_rates ? "Multiple Rates" : reservationDetails.reservation_card.rate_name;

            $scope.reservationData.totalStayCost = reservationDetails.reservation_card.total_rate;



            /*
            reservation stay dates manipulation
            */
            $scope.reservationData.stayDays = [];
            $scope.reservationData.rooms[0].rateId = [];
            $scope.reservationData.rooms[0].stayDates = {};

            $scope.reservationData.is_modified = false;

            angular.forEach(reservationDetails.reservation_card.stay_dates, function(item, index) {
                if (item.rate.actual_amount != item.rate.modified_amount) {
                    $scope.reservationData.is_modified = true;
                }

                $scope.reservationData.stayDays.push({
                    date: dateFilter(new tzIndependentDate(item.date), 'yyyy-MM-dd'),
                    dayOfWeek: dateFilter(new tzIndependentDate(item.date), 'EEE'),
                    day: dateFilter(new tzIndependentDate(item.date), 'dd')
                });
                $scope.reservationData.rooms[0].stayDates[dateFilter(new tzIndependentDate(item.date), 'yyyy-MM-dd')] = {
                        guests: {
                            adults: item.adults,
                            children: item.children,
                            infants: item.infants
                        },
                        rate: {
                            id: item.rate_id
                        },
                        rateDetails: item.rate
                    }
                    // TODO : Extend for each stay dates
                $scope.reservationData.rooms[0].rateId.push(item.rate_id);
                if (index == 0) {
                    $scope.reservationData.rooms[0].roomTypeId = item.room_type_id;
                    $scope.reservationData.rooms[0].roomTypeName = reservationDetails.reservation_card.room_type_description
                }

            });

            // appending departure date for UI handling since its not in API response IFF not a day reservation
            if (parseInt($scope.reservationData.numNights) > 0) {
                $scope.reservationData.stayDays.push({
                    date: dateFilter(new tzIndependentDate($scope.reservationData.departureDate), 'yyyy-MM-dd'),
                    dayOfWeek: dateFilter(new tzIndependentDate($scope.reservationData.departureDate), 'EEE'),
                    day: dateFilter(new tzIndependentDate($scope.reservationData.departureDate), 'dd')
                });
                $scope.reservationData.rooms[0].stayDates[dateFilter(new tzIndependentDate($scope.reservationData.departureDate), 'yyyy-MM-dd')] = $scope.reservationData.rooms[0].stayDates[dateFilter(new tzIndependentDate($scope.reservationData.arrivalDate), 'yyyy-MM-dd')];
            }
            if (reservationDetails.reservation_card.payment_method_used !== "" && reservationDetails.reservation_card.payment_method_used !== null) {

                $scope.reservationData.paymentType.type.description = reservationDetails.reservation_card.payment_method_description;
                $scope.reservationData.paymentType.type.value = reservationDetails.reservation_card.payment_method_used;
                if ($scope.reservationData.paymentType.type.value == "CC") {
                    $scope.renderData = {};
                    $scope.renderData.creditCardType = reservationDetails.reservation_card.payment_details.card_type_image.replace(".png", "").toLowerCase();
                    $scope.renderData.endingWith = reservationDetails.reservation_card.payment_details.card_number;
                    $scope.renderData.cardExpiry = reservationDetails.reservation_card.payment_details.card_expiry;
                    $scope.renderData.isSwiped = reservationDetails.reservation_card.payment_details.is_swiped;
                    $scope.reservationData.selectedPaymentId = reservationDetails.reservation_card.payment_details.id;
                    //CICO-11579 - To show credit card if C&P swiped or manual.
                    //In other cases condition in HTML will work
                    if ($rootScope.paymentGateway == "sixpayments") {
                        if (reservationDetails.reservation_card.payment_details.is_swiped) {
                            //can't set manual true..that is why added this flag.. Added in HTML too
                            $scope.reservationEditMode = true;
                        } else {
                            $scope.isManual = true;
                        }
                    }
                    $scope.showSelectedCreditCard = true;

                }
            }


            /* CICO-6069
             *  Comments from story:
             *  We should show the first nights room type by default and the respective rate as 'Booked Rate'.
             *  If the reservation is already in house and it is midstay, it should show the current rate. Would this be possible?
             */
            var arrivalDateDetails = _.where(reservationDetails.reservation_card.stay_dates, {
                date: $scope.reservationData.arrivalDate
            });
            $scope.reservationData.rooms[0].numAdults = arrivalDateDetails[0].adults;
            $scope.reservationData.rooms[0].numChildren = arrivalDateDetails[0].children;
            $scope.reservationData.rooms[0].numInfants = arrivalDateDetails[0].infants;

            // Find if midstay or later
            if (new tzIndependentDate($scope.reservationData.arrivalDate) < new tzIndependentDate($rootScope.businessDate)) {
                $scope.reservationData.midStay = true;
                /**
                 * CICO-8504
                 * Initialize occupancy to the last day
                 * If midstay update it to that day's
                 *
                 */
                var lastDaydetails = _.last(reservationDetails.reservation_card.stay_dates);
                $scope.reservationData.rooms[0].numAdults = lastDaydetails.adults;
                $scope.reservationData.rooms[0].numChildren = lastDaydetails.children;
                $scope.reservationData.rooms[0].numInfants = lastDaydetails.infants;

                var currentDayDetails = _.where(reservationDetails.reservation_card.stay_dates, {
                    date: dateFilter(new tzIndependentDate($rootScope.businessDate), 'yyyy-MM-dd')
                });

                if (currentDayDetails.length > 0) {
                    $scope.reservationData.rooms[0].numAdults = currentDayDetails[0].adults;
                    $scope.reservationData.rooms[0].numChildren = currentDayDetails[0].children;
                    $scope.reservationData.rooms[0].numInfants = currentDayDetails[0].infants;
                }
            }
            $scope.reservationData.rooms[0].varyingOccupancy = $scope.reservationUtils.isVaryingOccupancy(0);
            if ($scope.reservationUtils.isVaryingRates(0)) {
                $scope.reservationData.rooms[0].rateName = "Multiple Rates Selected"
            } else {
                $scope.reservationData.rooms[0].rateName = reservationDetails.reservation_card.package_description;
            }
        };

        /**
         * Event handler for the left menu staydates click action
         * We should display the calendar screen
         */
        $scope.stayDatesClicked = function() {
            var fromState = $state.current.name;
            //If we are already in state for calendar/rooms&rates, 
            //then we only need to switch the vuew type to calendar
            if (fromState == 'rover.reservation.staycard.mainCard.roomType') {
                $scope.$broadcast('switchToStayDatesCalendar');
                //Switch state to display the reservation calendar
            } else {
                $state.go('rover.reservation.staycard.mainCard.roomType', {
                    from_date: $scope.reservationData.arrivalDate,
                    to_date: $scope.reservationData.departureDate,
                    view: "CALENDAR",
                    fromState: fromState,
                    company_id: $scope.reservationData.company.id,
                    travel_agent_id: $scope.reservationData.travelAgent.id
                });
            }
            $scope.$broadcast('closeSidebar');
        };

        $scope.$on("guestEmailChanged", function(e) {
            $scope.$broadcast('updateGuestEmail');
        });

        //CICO-8504 Generic method to check for varying occupancy
        $scope.reservationUtils = (function() {
            var self = this;
            self.isVaryingOccupancy = function(roomIndex) {
                var stayDates = $scope.reservationData.rooms[roomIndex].stayDates;
                // If staying for just one night then there is no chance for varying occupancy
                if ($scope.reservationData.numNights < 2) {
                    return false;
                }
                // If number of nights is more than one, then need to check across the occupancies 
                var numInitialAdults = stayDates[$scope.reservationData.arrivalDate].guests.adults;
                var numInitialChildren = stayDates[$scope.reservationData.arrivalDate].guests.children;
                var numInitialInfants = stayDates[$scope.reservationData.arrivalDate].guests.infants;

                var occupancySimilarity = _.filter(stayDates, function(stayDateInfo, date) {
                    return date != $scope.reservationData.departureDate && stayDateInfo.guests.adults == numInitialAdults && stayDateInfo.guests.children == numInitialChildren && stayDateInfo.guests.infants == numInitialInfants;
                })

                if (occupancySimilarity.length < $scope.reservationData.numNights) {
                    return true;
                } else {
                    return false;
                }
            }
            self.isVaryingRates = function(roomIndex) {
                var stayDates = $scope.reservationData.rooms[roomIndex].stayDates;
                // If staying for just one night then there is no chance for varying occupancy
                if ($scope.reservationData.numNights < 2) {
                    return false;
                }
                // If number of nights is more than one, then need to check across the occupancies 
                var arrivalRate = stayDates[$scope.reservationData.arrivalDate].rate.id;

                var similarRates = _.filter(stayDates, function(stayDateInfo, date) {
                    return date != $scope.reservationData.departureDate && stayDateInfo.rate.id == arrivalRate;
                })

                if (similarRates.length < $scope.reservationData.numNights) {
                    return true;
                } else {
                    return false;
                }
            }
            return {
                isVaryingOccupancy: self.isVaryingOccupancy,
                isVaryingRates: self.isVaryingRates
            }
        })();

        /**
         *   Validation conditions
         *
         *   Either adults or children can be 0,
         *   but one of them will have to have a value other than 0.
         *
         *   Infants should be excluded from this validation.
         */
        $scope.validateOccupant = function(room, from) {

            // just in case
            if (!room) {
                return;
            };

            var numAdults = parseInt(room.numAdults),
                numChildren = parseInt(room.numChildren);

            if (from === 'adult' && (numAdults === 0 && numChildren === 0)) {
                room.numChildren = 1;
            } else if (from === 'children' && (numChildren === 0 && numAdults === 0)) {
                room.numAdults = 1;
            }
        };

        $scope.initReservationData();

        $scope.$on('REFRESHACCORDIAN', function() {
            $scope.$broadcast('GETREFRESHACCORDIAN');
        });

        $scope.$on('PROMPTCARD', function() {
            $scope.$broadcast('PROMPTCARDENTRY');
        });

        /**
         *   We have moved the fetching of 'baseData' form 'rover.reservation' state
         *   to the states where it actually requires it.
         *
         *   Now we do want to bind the baseData so we have created a 'callFromChildCtrl' method here.
         *
         *   Once that state controller fetch 'baseData', it will find this controller
         *   by climbing the $socpe.$parent ladder and will call this method.
         */
        $scope.callFromChildCtrl = function(baseData) {
            // update these datas.
            $scope.otherData.marketsEnabled = baseData.demographics.is_use_markets;
            $scope.otherData.markets = baseData.demographics.markets;
            $scope.otherData.sourcesEnabled = baseData.demographics.is_use_sources;
            $scope.otherData.sources = baseData.demographics.sources;
            $scope.otherData.originsEnabled = baseData.demographics.is_use_origins;
            $scope.otherData.origins = baseData.demographics.origins;
            $scope.otherData.reservationTypes = baseData.demographics.reservationTypes;

            // call this. no sure how we can pass date from here
            $scope.checkOccupancyLimit();
        };


        $scope.editReservationRates = function(room, index) {
            ngDialog.open({
                template: '/assets/partials/reservation/rvEditRates.html',
                className: 'ngdialog-theme-default',
                scope: $scope,
                closeByDocument: false,
                controller: 'RVEditRatesCtrl',
                closeByEscape: false,
                data: JSON.stringify({
                    room: room,
                    index: index
                })
            });
        };

        $scope.computeReservationDataforUpdate = function(skipPaymentData, skipConfirmationEmails) {
            var data = {};
            data.is_hourly = $scope.reservationData.isHourly;
            data.arrival_date = $scope.reservationData.arrivalDate;
            data.arrival_time = '';
            //Check if the check-in time is set by the user. If yes, format it to the 24hr format and build the API data.
            if ($scope.reservationData.checkinTime.hh != '' && $scope.reservationData.checkinTime.mm != '' && $scope.reservationData.checkinTime.ampm != '') {
                data.arrival_time = getTimeFormated($scope.reservationData.checkinTime.hh,
                    $scope.reservationData.checkinTime.mm,
                    $scope.reservationData.checkinTime.ampm);
            }
            data.departure_date = $scope.reservationData.departureDate;
            data.departure_time = '';
            //Check if the checkout time is set by the user. If yes, format it to the 24hr format and build the API data.
            if ($scope.reservationData.checkoutTime.hh != '' && $scope.reservationData.checkoutTime.mm != '' && $scope.reservationData.checkoutTime.ampm != '') {
                data.departure_time = getTimeFormated($scope.reservationData.checkoutTime.hh,
                    $scope.reservationData.checkoutTime.mm,
                    $scope.reservationData.checkoutTime.ampm);
            }

            data.adults_count = parseInt($scope.reservationData.rooms[0].numAdults);
            data.children_count = parseInt($scope.reservationData.rooms[0].numChildren);
            data.infants_count = parseInt($scope.reservationData.rooms[0].numInfants);
            // CICO - 8320 Rate to be handled in room level
            // data.rate_id = parseInt($scope.reservationData.rooms[0].rateId);
            data.room_type_id = parseInt($scope.reservationData.rooms[0].roomTypeId);
            //Guest details
            data.guest_detail = {};
            // Send null if no guest card is attached, empty string causes server internal error
            data.guest_detail.id = $scope.reservationData.guest.id == "" ? null : $scope.reservationData.guest.id;
            // New API changes
            data.guest_detail_id = data.guest_detail.id;
            data.guest_detail.first_name = $scope.reservationData.guest.firstName;
            data.guest_detail.last_name = $scope.reservationData.guest.lastName;
            data.guest_detail.email = $scope.reservationData.guest.email;

            if (!skipPaymentData) {
                data.payment_type = {};
                if ($scope.reservationData.paymentType.type.value !== null) {
                    angular.forEach($scope.reservationData.paymentMethods, function(item, index) {
                        if ($scope.reservationData.paymentType.type.value == item.value) {
                            data.payment_type.type_id = ($scope.reservationData.paymentType.type.value === "CC") ? $scope.reservationData.selectedPaymentId : item.id;
                        }
                    });
                    data.payment_type.expiry_date = ($scope.reservationData.paymentType.ccDetails.expYear == "" || $scope.reservationData.paymentType.ccDetails.expYear == "") ? "" : "20" + $scope.reservationData.paymentType.ccDetails.expYear + "-" +
                        $scope.reservationData.paymentType.ccDetails.expMonth + "-01";
                    data.payment_type.card_name = $scope.reservationData.paymentType.ccDetails.nameOnCard;
                }
            }


            // CICO-7077 Confirmation Mail to have tax details


            data.tax_details = [];
            _.each($scope.reservationData.taxDetails, function(taxDetail) {
                data.tax_details.push(taxDetail);
            });

            data.tax_total = $scope.reservationData.totalTaxAmount;

            // guest emails to which confirmation emails should send

            if (!skipConfirmationEmails) {
                data.confirmation_emails = [];
                if ($scope.otherData.isGuestPrimaryEmailChecked && $scope.reservationData.guest.email != "") {
                    data.confirmation_emails.push($scope.reservationData.guest.email);
                }
                if ($scope.otherData.isGuestAdditionalEmailChecked && $scope.otherData.additionalEmail != "") {
                    data.confirmation_emails.push($scope.otherData.additionalEmail);
                }
            }
            //according to  new flow
            // if (!skipPaymentData) {
            //     // MLI Integration.
            //     if ($rootScope.paymentGateway === "sixpayments") {
            //         data.payment_type.token = $scope.six_token;
            //         data.payment_type.isSixPayment = true;
            //     } else {
            //         data.payment_type.isSixPayment = false;
            //         if ($scope.reservationData.paymentType.type !== null) {
            //             if ($scope.reservationData.paymentType.type.value === "CC") {
            //                 data.payment_type.session_id = $scope.data.MLIData.session;
            //             }
            //         }
            //     }
            // }

            //  CICO-8320
            //  The API request payload changes
            var stay = [];
            data.room_id = [];
            _.each($scope.reservationData.rooms, function(room) {
                var reservationStayDetails = [];
                _.each(room.stayDates, function(staydata, date) {
                    reservationStayDetails.push({
                        date: date,
                        rate_id: (date == $scope.reservationData.departureDate) ? room.stayDates[$scope.reservationData.arrivalDate].rate.id : staydata.rate.id, // In case of the last day, send the first day's occupancy
                        room_type_id: room.roomTypeId,
                        room_id: room.room_id,
                        adults_count: (date == $scope.reservationData.departureDate) ? room.stayDates[$scope.reservationData.arrivalDate].guests.adults : parseInt(staydata.guests.adults),
                        children_count: (date == $scope.reservationData.departureDate) ? room.stayDates[$scope.reservationData.arrivalDate].guests.children : parseInt(staydata.guests.children),
                        infants_count: (date == $scope.reservationData.departureDate) ? room.stayDates[$scope.reservationData.arrivalDate].guests.infants : parseInt(staydata.guests.infants),
                        rate_amount: (date == $scope.reservationData.departureDate) ? ((room.stayDates[$scope.reservationData.arrivalDate] && room.stayDates[$scope.reservationData.arrivalDate].rateDetails && room.stayDates[$scope.reservationData.arrivalDate].rateDetails.modified_amount) || 0) : ((staydata.rateDetails && staydata.rateDetails.modified_amount) || 0)

                    });
                });
                stay.push(reservationStayDetails);
            });

            //  end of payload changes
            data.stay_dates = stay;

            //addons
            data.addons = [];
            _.each($scope.reservationData.rooms[0].addons, function(addon) {
                data.addons.push({
                    id: addon.id,
                    quantity: addon.quantity
                });
            });

            data.company_id = $scope.reservationData.company.id;
            data.travel_agent_id = $scope.reservationData.travelAgent.id;
            data.reservation_type_id = parseInt($scope.reservationData.demographics.reservationType);
            data.source_id = parseInt($scope.reservationData.demographics.source);
            data.market_segment_id = parseInt($scope.reservationData.demographics.market);
            data.booking_origin_id = parseInt($scope.reservationData.demographics.origin);
            data.confirmation_email = $scope.reservationData.guest.sendConfirmMailTo;

            //to delete starts here
            // var room = {
            //                  numAdults: 1,
            //                  numChildren: 0,
            //                  numInfants: 0,
            //                  roomTypeId: '',
            //                  roomTypeName: 'Deluxe',
            //                  rateId: '',
            //                  rateName: 'Special',
            //                  rateAvg: 0,
            //                  rateTotal: 0,
            //                  addons: [],
            //                  varyingOccupancy: false,
            //                  stayDates: {},
            //                  room_id:320,
            //                  isOccupancyCheckAlerted: false
            //              }
            //          $scope.reservationData.rooms[0].room_id = 324;
            // $scope.reservationData.rooms.push(room);
            data.room_id = [];
            angular.forEach($scope.reservationData.rooms, function(room, key) {
                data.room_id.push(room.room_id);
            });
            //to delete ends here
            return data;
        };

        var cancellationCharge = 0;
        var nights = false;
        var depositAmount = 0;
        $scope.creditCardTypes = [];
        $scope.paymentTypes = [];


        var fetcCreditCardTypes = function(cancellationCharge, nights) {
            var successCallback = function(data) {
                $scope.$emit('hideLoader');
                $scope.paymentTypes = data;
                data.forEach(function(item) {
                    if (item.name === 'CC') {
                        $scope.creditCardTypes = item.values;
                    };
                });
            };
            $scope.invokeApi(RVPaymentSrv.renderPaymentScreen, "", successCallback);
        };

        fetcCreditCardTypes();
        var promptCancel = function(penalty, nights) {

            var passData = {
                "reservationId": $scope.reservationData.reservationId,
                "details": {
                    "firstName": $scope.guestCardData.contactInfo.first_name,
                    "lastName": $scope.guestCardData.contactInfo.last_name,
                    "creditCardTypes": $scope.creditCardTypes,
                    "paymentTypes": $scope.paymentTypes
                }
            };
            $scope.passData = passData;
            ngDialog.open({
                template: '/assets/partials/reservationCard/rvCancelReservation.html',
                controller: 'RVCancelReservation',
                scope: $scope,
                data: JSON.stringify({
                    state: 'CONFIRM',
                    cards: false,
                    penalty: penalty,
                    penaltyText: (function() {
                        if (nights) {
                            return penalty + (penalty > 1 ? " nights" : " night");
                        } else {
                            return $rootScope.currencySymbol + $filter('number')(penalty, 2);
                        }
                    })()
                })
            });
        };

        $scope.cancelReservation = function() {
            var checkCancellationPolicy = function() {
                var onCancellationDetailsFetchSuccess = function(data) {
                    $scope.$emit('hideLoader');

                    // Sample Response from api/reservations/:id/policies inside the results hash
                    // calculated_penalty_amount: 40
                    // cancellation_policy_id: 36
                    // penalty_type: "percent"
                    // penalty_value: 20

                    depositAmount = data.results.deposit_amount;
                    var isOutOfCancellationPeriod = (typeof data.results.cancellation_policy_id != 'undefined');
                    if (isOutOfCancellationPeriod) {
                        if (data.results.penalty_type == 'day') {
                            // To get the duration of stay
                            var stayDuration = $scope.reservationData.numNights > 0 ? $scope.reservationData.numNights : 1;
                            // Make sure that the cancellation value is -lte thatn the total duration
                            cancellationCharge = stayDuration > data.results.penalty_value ? data.results.penalty_value : stayDuration;
                            nights = true;
                        } else {
                            cancellationCharge = parseFloat(data.results.calculated_penalty_amount);
                        }
                        if (parseInt(depositAmount) > 0) {
                            showDepositPopup(depositAmount, isOutOfCancellationPeriod, cancellationCharge);
                        } else {
                            promptCancel(cancellationCharge, nights);
                        };
                    } else {
                        if (parseInt(depositAmount) > 0) {
                            showDepositPopup(depositAmount, isOutOfCancellationPeriod, '');
                        } else {
                            promptCancel('', nights);
                        };
                    }
                    //promptCancel(cancellationCharge, nights);

                };
                var onCancellationDetailsFetchFailure = function(error) {
                    $scope.$emit('hideLoader');
                    $scope.errorMessage = error;
                };

                var params = {
                    id: $scope.reservationData.reservationId
                };

                $scope.invokeApi(RVReservationCardSrv.fetchCancellationPolicies, params, onCancellationDetailsFetchSuccess, onCancellationDetailsFetchFailure);
            };

            /**
             * If the reservation is within cancellation period, no action will take place.
             * If the reservation is outside of the cancellation period, a screen will display to show the cancellation rule.
             * [Cancellation period is the date and time set up in the cancellation rule]
             */

            checkCancellationPolicy();
        }

        var showDepositPopup = function(deposit, isOutOfCancellationPeriod, penalty) {
            ngDialog.open({
                template: '/assets/partials/reservationCard/rvCancelReservationDeposits.html',
                controller: 'RVCancelReservationDepositController',
                scope: $scope,
                data: JSON.stringify({
                    state: 'CONFIRM',
                    cards: false,
                    penalty: penalty,
                    deposit: deposit,
                    depositText: (function() {
                        if (!isOutOfCancellationPeriod) {
                            return "Within Cancellation Period. Deposit of " + $rootScope.currencySymbol + $filter('number')(deposit, 2) + " is refundable.";
                        } else {
                            return "Reservation outside of cancellation period. A cancellation fee of " + $rootScope.currencySymbol + $filter('number')(penalty, 2) + " will be charged, deposit not refundable";
                        }
                    })()
                })
            });
        };

        var nextState = '';
        var nextStateParameters = '';

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

        this.hasTravelAgent = function() {
            hasTravelAgent = false;
            if ($scope.reservationData.travelAgent.id !== null && $scope.reservationData.travelAgent.id !== undefined) {
                hasTravelAgent = true;
            }
            return hasTravelAgent;
        };

        this.hasCompanyCard = function() {
            hasCompanyCard = false;
            if ($scope.reservationData.company.id !== null && $scope.reservationData.company.id !== undefined) {
                hasCompanyCard = true;
            }
            return hasCompanyCard;

        };

        $scope.applyRoutingToReservation = function() {
            var routingApplySuccess = function(data) {
                $scope.$emit("hideLoader");
                ngDialog.close();

                if ($scope.contractRoutingType == 'TRAVEL_AGENT' && that.hasCompanyCard() && $scope.routingInfo.company.routings_count > 0) {

                    $scope.contractRoutingType = "COMPANY";
                    that.showConfirmRoutingPopup($scope.contractRoutingType, $scope.reservationData.company.id)
                    return false;
                }
                /*else {
                                   //Proceed with reservation creation flow
                                   $scope.goToConfirmationScreen();
                               }*/
            };

            var params = {};
            params.account_id = $scope.contractRoutingType === 'TRAVEL_AGENT' ? $scope.reservationData.travelAgent.id : $scope.reservationData.company.id;
            //params.reservation_id = $scope.reservationData.reservationId;
            params.reservation_ids = [];
            for (var i in $scope.reservationData.reservations) {
                params.reservation_ids.push($scope.reservationData.reservations[i].id)
            }
            $scope.invokeApi(RVReservationSummarySrv.applyDefaultRoutingToReservation, params, routingApplySuccess);

        };

        /* $scope.goToConfirmationScreen = function() {
             $state.go('rover.reservation.staycard.mainCard.reservationConfirm', {
                 "id": $scope.reservationData.reservationId,
                 "confirmationId": $scope.reservationData.confirmNum
             })
         };*/

        $scope.noRoutingToReservation = function() {
            ngDialog.close();

            if ($scope.contractRoutingType == 'TRAVEL_AGENT' && that.hasCompanyCard() && $scope.routingInfo.company.routings_count > 0) {

                $scope.contractRoutingType = "COMPANY";
                that.showConfirmRoutingPopup($scope.contractRoutingType, $scope.reservationData.company.id)
                return false;


            }
            /*else {
                           //Proceed with reservation creation flow
                           $scope.goToConfirmationScreen();
                       }*/
            //$scope.goToConfirmationScreen();
        };

        $scope.okClickedForConflictingRoutes = function() {
            //$scope.goToConfirmationScreen();
            ngDialog.close();
        };

        this.attachCompanyTACardRoutings = function() {
            var fetchSuccessofDefaultRouting = function(data) {
                $scope.$emit("hideLoader");
                $scope.routingInfo = data;
                if (data.has_conflicting_routes) {
                    $scope.conflict_cards = [];
                    if (that.hasTravelAgent() && data.travel_agent.routings_count > 0) {
                        $scope.conflict_cards.push($scope.reservationData.travelAgent.name)
                    }
                    if (that.hasCompanyCard() && data.company.routings_count > 0) {
                        $scope.conflict_cards.push($scope.reservationData.company.name)
                    }

                    that.showConflictingRoutingPopup();

                    return false;
                }

                if (that.hasTravelAgent() && data.travel_agent.routings_count > 0) {
                    $scope.contractRoutingType = "TRAVEL_AGENT";
                    that.showConfirmRoutingPopup($scope.contractRoutingType, $scope.reservationData.travelAgent.id)
                    return false;

                }
                if (that.hasCompanyCard() && data.company.routings_count > 0) {
                    $scope.contractRoutingType = "COMPANY";
                    that.showConfirmRoutingPopup($scope.contractRoutingType, $scope.reservationData.company.id)
                    return false;

                }
                /*else {
                                   //ngDialog.close();
                                   $scope.goToConfirmationScreen();
                               }*/

            };

            if (that.hasTravelAgent() || that.hasCompanyCard()) {
                var params = {};
                params.reservation_id = $scope.reservationData.reservationId;
                params.travel_agent_id = $scope.reservationData.travelAgent.id;
                params.company_id = $scope.reservationData.company.id;
                /*//TODO: Actual API call
                //fetchSuccessofDefaultRouting();
                params.reservation_id = [];
                for(var i in $scope.reservationData.reservations){
                    params.reservation_id.push($scope.reservationData.reservations[i].id)
                }*/

                $scope.invokeApi(RVReservationSummarySrv.fetchDefaultRoutingInfo, params, fetchSuccessofDefaultRouting);
            }
            /*else {
                            $scope.goToConfirmationScreen();

                        }*/
        };

        $scope.saveReservation = function(navigateTo, stateParameters, index) {
            $scope.$emit('showLoader');
            nextState = navigateTo;
            nextStateParameters = stateParameters;
            /**
             * CICO-10321
             * Move check for guest / company / ta card attached to the screen before the reservation summary screen.
             * This may either be the rooms and rates screen or the Add on screen when turned on.
             */
            if (!$scope.reservationData.guest.id && !$scope.reservationData.company.id && !$scope.reservationData.travelAgent.id) {
                $scope.$emit('PROMPTCARD');
            } else {
                /**
                 * CICO-10321
                 * 3. Once hitting the BOOK button and cards have been attached, issue the confirmation number and move to reservation summary screen
                 * NOTE :
                 *     Exisiting implementation : Confirmation number gets generated when the submit reservation button in the summary screen is clicked
                 */

                var postData = $scope.computeReservationDataforUpdate(true, true);
                var saveSuccess = function(data) {
                    var totalDeposit = 0;
                    //calculate sum of each reservation deposits
                    $scope.reservationsListArray = data;
                    angular.forEach(data.reservations, function(reservation, key) {

                        totalDeposit = parseFloat(totalDeposit) + parseFloat(reservation.deposit_amount);
                    });
                    
                    // CICO-13748 : Added depositAmountWithoutFilter to handle PAY DEPOSIT LATER or PAY NOW buttons.
                    $scope.reservationData.depositAmountWithoutFilter = totalDeposit;

                    totalDeposit = $filter('number')(totalDeposit, 2);
                    $scope.reservationData.depositAmount = totalDeposit;
                    $scope.reservationData.depositEditable = (data.allow_deposit_edit !== null && data.allow_deposit_edit) ? true : false;
                    $scope.reservationData.isValidDeposit = parseInt($scope.reservationData.depositAmount) > 0;

                    if (typeof data.reservations !== 'undefined' && data.reservations instanceof Array) {
                        angular.forEach(data.reservations, function(reservation, key) {
                            angular.forEach($scope.reservationData.rooms, function(room, key) {
                                if (parseInt(reservation.room_id) === parseInt(room.room_id)) {
                                    room.confirm_no = reservation.confirm_no;
                                }
                            });
                        });
                        $scope.reservationData.reservations = data.reservations;
                        $scope.reservationData.reservationIds = [];
                        angular.forEach(data.reservations, function(reservation, key) {
                            $scope.reservationData.reservationIds.push(reservation.id);
                        });
                        $scope.reservationData.reservationId = $scope.reservationData.reservations[0].id;
                        $scope.reservationData.confirmNum = $scope.reservationData.reservations[0].confirm_no;
                        $scope.reservationData.status = $scope.reservationData.reservations[0].status;
                        $scope.viewState.reservationStatus.number = $scope.reservationData.reservations[0].id;
                    } else {
                        $scope.reservationData.reservationId = data.id;
                        $scope.reservationData.confirmNum = data.confirm_no;
                        $scope.reservationData.rooms[0].confirm_no = data.confirm_no;
                        $scope.reservationData.status = data.status;
                        $scope.viewState.reservationStatus.number = data.id;
                    }
                    /*
                     * TO DO:ends here
                     */

                    /*
                     * Comment out .if existing cards needed remove comments
                     */

                    $scope.successPaymentList = function(data) {
                        $scope.$emit("hideLoader");
                        $scope.cardsList = data.existing_payments;
                        angular.forEach($scope.cardsList, function(value, key) {
                            value.mli_token = value.ending_with; //For common payment HTML to work - Payment modifications story
                            value.card_expiry = value.expiry_date; //Same comment above
                        });
                    };

                    $scope.invokeApi(RVPaymentSrv.getPaymentList, $scope.reservationData.reservationId, $scope.successPaymentList);

                    $scope.viewState.reservationStatus.confirm = true;
                    $scope.reservationData.is_routing_available = false;
                    // Change mode to stay card as the reservation has been made!
                    $scope.viewState.identifier = "CONFIRM";

                    $scope.reservation = {
                        reservation_card: {}
                    };

                    $scope.reservation.reservation_card.arrival_date = $scope.reservationData.arrivalDate;
                    $scope.reservation.reservation_card.departure_date = $scope.reservationData.departureDate;



                    $scope.$broadcast('PROMPTCARDENTRY');


                    $scope.$emit('hideLoader');
                    that.attachCompanyTACardRoutings();

                    if (nextState) {
                        if (!nextStateParameters) {
                            nextStateParameters = {};
                        }
                        $state.go(nextState, nextStateParameters);
                    }
                };

                var saveFailure = function(data) {
                    $scope.errorMessage = data;
                    $scope.$broadcast('FAILURE_SAVE_RESERVATION', data);
                    $scope.$emit('hideLoader');
                };

                var updateFailure = function(data) {
                    $scope.errorMessage = data;
                    $scope.$broadcast('FAILURE_UPDATE_RESERVATION', data);
                    $scope.$emit('hideLoader');
                };

                var updateSuccess = function(data) {

                    var totalDepositOnRateUpdate = 0;

                    /**
                     * CICO-10195 : While extending a hourly reservation from
                     * diary the reservationListArray would be undefined
                     * Hence.. at this point as it is enough to just update
                     * reservation.deposit_amount
                     * totalDepositOnRateUpdate for just the single reservation.
                     */

                    if ($scope.reservationsListArray) {
                        angular.forEach($scope.reservationsListArray.reservations, function(reservation, key) {
                            if (key == index) {
                                reservation.deposit_amount = data.deposit_amount;
                                totalDepositOnRateUpdate = parseFloat(totalDepositOnRateUpdate) + parseFloat(data.deposit_amount);
                            } else {
                                totalDepositOnRateUpdate = parseFloat(totalDepositOnRateUpdate) + parseFloat(reservation.deposit_amount);
                            }
                        });
                    } else {
                        totalDepositOnRateUpdate = parseFloat(data.deposit_amount);
                    }

                    // $scope.reservationData.depositAmount = data.deposit_amount;
                    $scope.reservationData.depositAmount = $filter('number')(totalDepositOnRateUpdate, 2);;
                    $scope.reservationData.depositEditable = (data.allow_deposit_edit !== null && data.allow_deposit_edit) ? true : false;
                    $scope.reservationData.isValidDeposit = parseInt($scope.reservationData.depositAmount) > 0;
                    $scope.reservationData.fees_details = data.fees_details;

                    $scope.$broadcast('UPDATEFEE');
                    $scope.viewState.identifier = "UPDATED";
                    $scope.reservationData.is_routing_available = data.is_routing_available;

                    $scope.reservationData.status = data.reservation_status;

                    if (nextState) {
                        if (!nextStateParameters) {
                            nextStateParameters = {};
                        }
                        $state.go(nextState, nextStateParameters);
                    } else {
                        $scope.$emit('hideLoader');
                    }
                };

                if ($scope.reservationData.reservationId != "" && $scope.reservationData.reservationId != null && typeof $scope.reservationData.reservationId != "undefined") {
                    if (typeof index !== 'undefined') {
                        angular.forEach($scope.reservationsListArray.reservations, function(reservation, key) {
                            if (key == index) {
                                postData.reservationId = reservation.id;
                                var roomId = postData.room_id[index];
                                postData.room_id = [];
                                postData.room_id.push(roomId);
                            }

                        });
                    } else {
                        postData.reservationId = $scope.reservationData.reservationId;
                    }

                    postData.addons = $scope.viewState.existingAddons;


                    $scope.invokeApi(RVReservationSummarySrv.updateReservation, postData, updateSuccess, updateFailure);
                } else {
                    $scope.invokeApi(RVReservationSummarySrv.saveReservation, postData, saveSuccess, saveFailure);
                }
              
            }
        };

        $scope.fetchDemoGraphics = function() {

            var fetchSuccess = function(data) {
                $scope.otherData.marketsEnabled = data.demographics.is_use_markets;
                $scope.otherData.markets = data.demographics.markets;
                $scope.otherData.sourcesEnabled = data.demographics.is_use_sources;
                $scope.otherData.sources = data.demographics.sources;
                $scope.otherData.originsEnabled = data.demographics.is_use_origins;
                $scope.otherData.origins = data.demographics.origins;
                $scope.otherData.reservationTypes = data.demographics.reservationTypes;
                $scope.$emit('hideLoader');
            };
            var fetchFailure = function(data) {
                $scope.errorMessage = data;
                $scope.$emit('hideLoader');
            };

            $scope.invokeApi(RVReservationSummarySrv.fetchInitialData, {}, fetchSuccess, fetchFailure);
        };

        $scope.resetAddons = function() {
            angular.forEach($scope.reservationData.rooms, function(room) {
                room.addons = []
            });
        };

        $scope.computeHourlyTotalandTaxes = function() {
            $scope.reservationData.totalStayCost = 0.0;
            $scope.reservationData.totalTax = 0.0;
            $scope.reservationData.taxDetails = {};
            _.each($scope.reservationData.rooms, function(room, roomNumber) {
                var taxes = $scope.otherData.hourlyTaxInfo[0];
                room.amount = 0.0;
                _.each(room.stayDates, function(stayDate, date) {
                    if (date == $scope.reservationData.arrivalDate) {
                        stayDate.rateDetails.modified_amount = parseFloat(stayDate.rateDetails.modified_amount).toFixed(2);
                        if (isNaN(stayDate.rateDetails.modified_amount)) {
                            stayDate.rateDetails.modified_amount = parseFloat(stayDate.rateDetails.actual_amount).toFixed(2);
                        }
                        room.amount = parseFloat(room.amount) + parseFloat(stayDate.rateDetails.modified_amount);
                    }
                });
                room.rateTotal = room.amount;

                if (taxes) {
                    /**
                     * Calculating taxApplied just for the arrival date, as this being the case for hourly reservations.
                     */
                    var taxApplied = $scope.calculateTax($scope.reservationData.arrivalDate, room.amount, taxes.tax, roomNumber);
                    _.each(taxApplied.taxDescription, function(description, index) {
                        if (typeof $scope.reservationData.taxDetails[description.id] == "undefined") {
                            $scope.reservationData.taxDetails[description.id] = description;
                        } else {
                            $scope.reservationData.taxDetails[description.id].amount = parseFloat($scope.reservationData.taxDetails[description.id].amount) + (parseFloat(description.amount));
                        }
                    });
                    $scope.reservationData.totalTax = parseFloat($scope.reservationData.totalTax) + parseFloat(taxApplied.inclusive) + parseFloat(taxApplied.exclusive);
                    $scope.reservationData.totalStayCost = parseFloat($scope.reservationData.totalStayCost) + parseFloat(taxApplied.exclusive);
                }
                //Calculate Addon Addition for the room
                var addOnCumulative = 0;
                $(room.addons).each(function(i, addon) {
                    //Amount_Types
                    // 1   ADULT   
                    // 2   CHILD   
                    // 3   PERSON  
                    // 4   FLAT
                    // The Amount Type is available in the amountType object of the selected addon
                    // ("AT", addon.amountType.value)

                    //Post Types
                    // 1   STAY   
                    // 2   NIGHT  
                    // The Post Type is available in the postType object of the selected addon
                    // ("PT", addon.postType.value)

                    //TODO: IN CASE OF DATA ERRORS MAKE FLAT STAY AS DEFAULT

                    var baseRate = parseFloat(addon.quantity) * parseFloat(addon.price);

                    var finalRate = baseRate;

                    var getAddonRateForDay = function(amountType, baseRate, numAdults, numChildren) {
                        if (amountType == "PERSON") {
                            return baseRate * parseInt(parseInt(numAdults) + parseInt(numChildren));
                        } else if (addon.amountType.value == "CHILD") {
                            return baseRate * parseInt(numChildren);
                        } else if (addon.amountType.value == "ADULT") {
                            return baseRate * parseInt(numAdults);
                        }
                        return baseRate;
                    };

                    if (addon.postType.value == "STAY" && parseInt($scope.reservationData.numNights) > 1) {
                        var cumulativeRate = 0
                        _.each(currentRoom.stayDates, function(stayDate, date) {
                            if (date !== $scope.reservationData.departureDate) cumulativeRate = parseFloat(cumulativeRate) + parseFloat(getAddonRateForDay(
                                addon.amountType.value,
                                baseRate,
                                stayDate.guests.adults, // Using EACH night's occupancy information to calculate the addon's applicable amount!
                                stayDate.guests.children)); // cummulative sum (Not just multiplication of rate per day with the num of nights) >> Has to done at "day level" to handle the reservations with varying occupancy!
                        });
                        finalRate = cumulativeRate;
                    } else {
                        finalRate = parseFloat(getAddonRateForDay(
                            addon.amountType.value,
                            baseRate,
                            room.numAdults, // Using FIRST night's occupancy information to calculate the addon's applicable amount!
                            room.numChildren));
                    }
                    addOnCumulative += parseInt(finalRate);
                    addon.effectivePrice = finalRate;
                });
                $scope.reservationData.totalStayCost = parseFloat($scope.reservationData.totalStayCost) + parseFloat(room.rateTotal) + parseFloat(addOnCumulative);
            });
        };

        //CICO-11716
        $scope.onOccupancyChange = function(room, occupantType, idx) {
            $scope.updateOccupancy(idx);
            if (!$scope.reservationData.isHourly) {
                $scope.validateOccupant(room, occupantType);
                $scope.checkOccupancyLimit(null, true);
            }
        };
    }

]);