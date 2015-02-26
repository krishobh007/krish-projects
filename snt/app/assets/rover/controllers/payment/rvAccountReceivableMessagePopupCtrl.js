sntRover.controller('RVAccountReceivableMessagePopupCtrl',['$rootScope', '$scope', '$state','ngDialog', 'RVCompanyCardSrv', function($rootScope, $scope, $state, ngDialog, RVCompanyCardSrv){
	BaseCtrl.call(this, $scope);
		
	$scope.createAccountAction = function(){

		ngDialog.close();
		if($scope.reservationBillData.is_auto_assign_ar_numbers == "true"){
			$scope.createAccountReceivable();
		}else{
			ngDialog.open({
				template: '/assets/partials/payment/rvAccountReceivablesCreatePopup.html',
				controller: 'RVCreateAccountReceivableCtrl',
				className: 'ngdialog-theme-default',
				scope: $scope
			});
		}		
	};

	$scope.successCreate = function(data){
		$scope.$emit("hideLoader");
		$scope.reservationBillData.ar_number = data.ar_number;
		ngDialog.close();
	};
	$scope.failureCreate = function(errorMessage){

		$scope.$emit("hideLoader");
		$scope.errorMessage = errorMessage;
	};

	$scope.createAccountReceivable = function(){
		
		var data = {
			"id": $scope.account_id,
			"ar_number": ""
		};
		$scope.invokeApi(RVCompanyCardSrv.saveARDetails, data, $scope.successCreate, $scope.failureCreate);
	};

	$scope.closeDialog = function(){
		ngDialog.close();
	}
	
}]);