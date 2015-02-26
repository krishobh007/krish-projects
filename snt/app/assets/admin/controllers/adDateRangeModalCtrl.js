admin.controller('ADDateRangeModalCtrl', ['$scope',
  '$filter',
  'ADRatesConfigureSrv',
  'ngDialog',
  '$rootScope',
  function($scope, $filter, ADRatesConfigureSrv, ngDialog, $rootScope) {
    BaseCtrl.call(this, $scope);

    $scope.setUpData = function() {

      $scope.errorMessage = '';
      if (ADRatesConfigureSrv.hasBaseRate) {
        $scope.data.begin_date = dateDict.begin_date;
        $scope.data.end_date = dateDict.end_date;
      }
      $scope.fromDate = "";
      $scope.toDate = "";
      if ($scope.data.begin_date.length > 0) {
        $scope.fromDate = $scope.data.begin_date;
      };
      if ($scope.data.end_date.length > 0) {
        $scope.toDate = $scope.data.end_date;
      };


      $scope.fromDateOptions = {
        changeYear: true,
        changeMonth: true,
        minDate: tzIndependentDate($rootScope.businessDate),
        yearRange: "0:+10",
        onSelect: function() {

          if (tzIndependentDate($scope.fromDate) > tzIndependentDate($scope.toDate)) {
            $scope.toDate = $scope.fromDate;
          }
        }
      }

      $scope.toDateOptions = {
        changeYear: true,
        changeMonth: true,
        minDate: tzIndependentDate($rootScope.businessDate),
        yearRange: "0:+10",
        onSelect: function() {

          if (tzIndependentDate($scope.fromDate) > tzIndependentDate($scope.toDate)) {
            $scope.fromDate = $scope.toDate;
          }
        }
      }

    }

    $scope.setUpData();

    $scope.updateClicked = function() {
      var successUpdateRange = function() {
        $scope.$emit('hideLoader');
        $scope.dateRange.begin_date = $scope.data.begin_date = $scope.fromDate;
        $scope.dateRange.end_date = $scope.data.end_date = $scope.toDate;
        ngDialog.close();
      };

      var failureUpdateRange = function(data) {
        $scope.$emit('hideLoader');
        $scope.errorMessage = data;
      };

      var data = {
        "dateId": $scope.dateRange.id,
        "begin_date": $scope.fromDate,
        "end_date": $scope.toDate
      };
      $scope.invokeApi(ADRatesConfigureSrv.updateDateRange, data, successUpdateRange, failureUpdateRange);
    };
    $scope.cancelClicked = function() {
      ngDialog.close();

    };

  }
]);