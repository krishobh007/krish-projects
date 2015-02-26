admin.controller('ADContentManagementSectionDetailCtrl',['$scope', '$state', 'ngDialog', '$stateParams', 'ADContentManagementSrv', 'ngTableParams','$filter', '$anchorScroll', '$timeout',  '$location', 
 function($scope, $state, ngDialog, $stateParams, ADContentManagementSrv, ngTableParams, $filter, $anchorScroll, $timeout, $location){
	
	$scope.errorMessage = '';
	BaseCtrl.call(this, $scope);
	$scope.fileName = "Choose file...";
	$scope.initialIcon = ''
	/*Initializing data, for adding a new section.
    */
	$scope.data = {	            
	            "component_type": "SECTION",
	            "status": false,
	            "name": "",
	            "icon": ''
            }

    
    /*Function to fetch the section details
    */
	$scope.fetchSection = function(){
		var fetchSectionSuccessCallback = function(data){
			$scope.$emit('hideLoader');
			$scope.data = data;
			$scope.initialIcon = $scope.data.icon;
		}
		$scope.invokeApi(ADContentManagementSrv.fetchComponent, $stateParams.id , fetchSectionSuccessCallback);
	}
	/*Checkin if the screen is loaded for a new section or,
	 * for existing section.
    */
	if($stateParams.id != 'new'){
		$scope.isAddMode = false;
		$scope.fetchSection();
	}
	else{
		$scope.isAddMode = true;
	}	
	/*Function to return to preveous state
    */
	$scope.goBack = function(){
        $state.go('admin.cmscomponentSettings');                  
	}
	/*Function to save a category
    */
	$scope.saveSection = function(){
		var saveSectionSuccessCallback = function(data){
			$scope.$emit('hideLoader');
			$scope.goBack();
		}
		var unwantedKeys = ["image"];
		if($scope.initialIcon == $scope.data.icon)
			unwantedKeys = ["icon", "image"];		

		var data = dclone($scope.data, unwantedKeys);
		$scope.invokeApi(ADContentManagementSrv.saveComponent, data , saveSectionSuccessCallback);
	}	

	/* delete component starts here*/

	$scope.deleteItem = function(id){
		var successCallbackFetchDeleteDetails = function(data){
			$scope.assocatedChildComponents = [];
			$scope.assocatedChildComponents = data.results;
			$scope.$emit('hideLoader');
			ngDialog.open({
				template: '/assets/partials/contentManagement/adDeleteContent.html',
				className: '',
				controller:'adDeleteContentController',
				scope:$scope,
				closeByDocument:true
			});
			$scope.componentIdToDelete = id;
		}
		$scope.invokeApi(ADContentManagementSrv.fetchChildList, {'id':id} , successCallbackFetchDeleteDetails);

	}
	/* Listener to know that the current category is deleted.
	 * Need to go back to preveous state in this case
	 */
	$scope.$on('componentDeleted', function(event, data) {   

      $scope.goBack();

   });

}]);

