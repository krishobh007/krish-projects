sntRover.controller('RVmanagerDashboardController', ['$scope', '$rootScope', '$state', '$vault', function($scope, $rootScope, $state, $vault) {
  //inheriting some useful things
  BaseCtrl.call(this, $scope);
  var that = this;
  //scroller related settings
  var scrollerOptions = {
    click: true,
    preventDefault: false
  };
  $scope.setScroller('dashboard_scroller', scrollerOptions);

  //changing the header
  $scope.$emit("UpdateHeading", 'DASHBOARD_MANAGER_HEADING');
  $scope.showDashboard = true; //variable used to hide/show dabshboard

  // we are hiding the search results area
  $scope.$broadcast("showSearchResultsArea", false);

  $scope.tomorrow = tzIndependentDate($rootScope.businessDate);
  $scope.tomorrow.setDate($scope.tomorrow.getDate() + 1);
  $scope.dayAfterTomorrow = tzIndependentDate($scope.tomorrow);
  $scope.dayAfterTomorrow.setDate($scope.tomorrow.getDate() + 1);

  $scope.$on("$includeContentLoaded", function(){
      //we are showing the add new guest button in searhc only if it is standalone & search result is empty
      if($rootScope.isStandAlone){
          $scope.$broadcast("showAddNewGuestButton", true);
      }        
  });


  //we are setting the header accrdoing to manager's dashboard
  $scope.$emit("UpdateHeading", 'DASHBOARD_MANAGER_HEADING');

  /*
   *    a recievable function hide/show search area.
   *    when showing the search bar, we will hide dashboard & vice versa
   *    param1 {event}, javascript event
   *    param2 {boolean}, value to determine whether dashboard should be visible
   */
  $scope.$on("showDashboardArea", function(event, showDashboard) {
    $scope.showDashboard = showDashboard;
    $scope.refreshScroller('dashboard_scroller');
  });

  /**
   *   recievalble function to update dashboard reservatin search results
   *   intended for checkin, inhouse, checkout (departed), vip buttons handling.
   *   @param {Object} javascript event
   *   @param {array of Objects} data search results
   */
  $scope.$on("updateDashboardSearchDataFromExternal", function(event, data) {
    $scope.$broadcast("updateDataFromOutside", data);
    $scope.$broadcast("showSearchResultsArea", true);
  });

  /**
   *   recievalble function to update dashboard reservatin search result's type
   *   intended for checkin, inhouse, checkout (departed), vip buttons search result handling.
   *   @param {Object} javascript event
   *   @param {array of Objects} data search results
   */
  $scope.$on("updateDashboardSearchTypeFromExternal", function(event, type) {
    $scope.$broadcast("updateReservationTypeFromOutside", type);
  });

  //show Latecheckout icon
  $scope.shouldShowLateCheckout = true;
  $scope.shouldShowQueuedRooms = true;

  /**
   *   a recievder function to show erorr message in the dashboard
   *   @param {Object} Angular event
   *   @param {String} error message to display
   */

  $scope.$on("showErrorMessage", function(event, errorMessage) {
    $scope.errorMessage = errorMessage;
  });

  /**
   * function used to check null values, especially api response from templates
   */
  $scope.escapeNull = function(value, replaceWith) {
    var newValue = "";
    if ((typeof replaceWith != "undefined") && (replaceWith != null)) {
      newValue = replaceWith;
    }
    var valueToReturn = ((value == null || typeof value == 'undefined') ? newValue : value);
    return valueToReturn;
  };

  /**
   * function to check whether the object is empty or not
   * @param {Object} Js Object
   * @return Boolean
   */
  $scope.isEmptyObject = $.isEmptyObject;

  $scope.$on("UPDATE_MANAGER_DASHBOARD", function() {
    $scope.$emit("UpdateHeading", 'DASHBOARD_MANAGER_HEADING');
  });
  //scroller is not appearing after coming back from other screens
  setTimeout(function() {
    $scope.refreshScroller('dashboard_scroller');
  }, 500);


  //Function to be deleted - CICO-9433 - Sample button in dashboard screen
  $scope.setReservationDataFromDiaryScreen = function() {
    console.log('hello');
    //$rootScope.temporaryReservationDataFromDiaryScreen = {
    var temporaryReservationDataFromDiaryScreen = {

      "arrival_date": "2014-07-15",
      "departure_date": "2014-07-16",
      "arrival_time": "04:30 AM",
      "departure_time": "09:15 PM",

      "rooms": [{
        "room_id": "245",
        "rateId": "382",
        "numAdults": "1",
        "numChildren": "2",
        "numInfants": "4",
        "amount": 300
      }
      // , {
        // "room_id": "270",
        // "rateId": "382",
        // "numAdults": "2",
        // "numChildren": "2",
        // "numInfants": "4",
        // "amount": 250
      // }, {
        // "room_id": "295",
        // "rateId": "382",
        // "numAdults": "2",
        // "numChildren": "2",
        // "numInfants": "4",
        // "amount": 450
      // }
      ]
    };
    $vault.set('temporaryReservationDataFromDiaryScreen', JSON.stringify(temporaryReservationDataFromDiaryScreen));
    $state.go("rover.reservation.staycard.mainCard.summaryAndConfirm", {
      'reservation': 'HOURLY'
    });
  };
}]);