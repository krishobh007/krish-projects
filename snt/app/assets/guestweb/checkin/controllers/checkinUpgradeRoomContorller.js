
(function() {
  var checkinUpgradeRoomController = function($scope,$location,$rootScope,checkinRoomUpgradeOptionsService,checkinRoomUpgradeService,checkinDetailsService,$state) {

  $scope.pageValid = false;

  if($rootScope.isCheckedin){
    $state.go('checkinSuccess');
  }
  else{
    $scope.pageValid = true;
  };

  if($scope.pageValid){
    $scope.slides = [];
  //set up flags related to webservice

  $scope.isFetching     = false;
  $rootScope.netWorkError  = false;
  var data = {'reservation_id':$rootScope.reservationID};
  $scope.isFetching          = true;
  checkinRoomUpgradeOptionsService.fetch(data).then(function(response) {

    $scope.isFetching     = false;
    if(response.status === 'failure')
      $rootScope.netWorkError = true;
    else
      $scope.slides = response.data;
  },function(){
    $rootScope.netWorkError = true;
    $scope.isFetching = false;
  });

  // upgrade button clicked

  $scope.upgradeClicked = function(upgradeID,roomNumber){

    $scope.isFetching          = true;
    var data = {'reservation_id':$rootScope.reservationID,'upsell_amount_id':upgradeID,'room_no':roomNumber};
    checkinRoomUpgradeService.post(data).then(function(response) {

      $scope.isFetching     = false;
      if(response.status === "failure")
        $rootScope.netWorkError  = true;
      else
      {
        $rootScope.upgradesAvailable = false;
        $rootScope.ShowupgradedLabel = true;
        $rootScope.roomUpgradeheading = "Your new Trip details";
        checkinDetailsService.setResponseData(response.data);         
        $state.go('checkinReservationDetails');
      }

    },function(){
      $rootScope.netWorkError = true;
      $scope.isFetching = false;
    });


  }

  $scope.noThanksClicked = function(){
    if($rootScope.isAutoCheckinOn){
      $state.go('checkinArrival');
    }
    else{
       $state.go('checkinKeys');
    }
  };

}
};

var dependencies = [
'$scope','$location','$rootScope','checkinRoomUpgradeOptionsService','checkinRoomUpgradeService','checkinDetailsService','$state',
checkinUpgradeRoomController
];

snt.controller('checkinUpgradeRoomController', dependencies);
})();

  // Setup directive to compile html

  snt.directive("description", function ($compile) {
    function createList(template) {
      templ = template;
      return templ;
    }

    return{
      restrict:"E",
      scope: {},
      link:function (scope, element, attrs) {

        element.append(createList(attrs.template));
        $compile(element.contents())(scope);
      }
    }
  });

  // Setup directive to handle image not found case

  snt.directive('errSrc', function() {
    return {
      link: function(scope, element, attrs) {
        element.bind('error', function() {
          element.attr('src', attrs.errSrc);
        });
      }
    }
  });
