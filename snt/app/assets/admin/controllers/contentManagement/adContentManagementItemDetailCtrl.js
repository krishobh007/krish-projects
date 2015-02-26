admin.controller('ADContentManagementItemDetailCtrl',['$scope', '$state', '$stateParams', 'ngDialog', 'ADContentManagementSrv', 'ngTableParams','$filter', '$anchorScroll', '$timeout',  '$location', 
 function($scope, $state, $stateParams, ngDialog, ADContentManagementSrv, ngTableParams, $filter, $anchorScroll, $timeout, $location){
	
	$scope.errorMessage = '';
	BaseCtrl.call(this, $scope);
	
	 $scope.fileName = "Choose file...";
	 $scope.initialIcon = '';
	 /*Initializing data, for adding a new item.
    */
	$scope.data = {	            
	            "component_type": "PAGE",
	            "status": false,
	            "name": "",
	            "image": '',
	            "address": "",
	            "phone": "",
	            "page_template": "POI",
	            "website_url": "",
	            "description": "",
	            "parent_category": []
            }

    
	/*Function to fetch the item details
    */
	$scope.fetchItem = function(){
		var fetchItemSuccessCallback = function(data){
			$scope.$emit('hideLoader');
			$scope.data = data;
			$scope.initialIcon =  $scope.data.image;
		}
		$scope.invokeApi(ADContentManagementSrv.fetchComponent, $stateParams.id , fetchItemSuccessCallback);
	}
	/*Checkin if the screen is loaded for a new item or,
	 * for existing item.
    */
	if($stateParams.id != 'new'){
		$scope.isAddMode = false;
		$scope.fetchItem();
	}
	else{
		$scope.isAddMode = true;
	}	
	/*Function to return to preveous state
    */
	$scope.goBack = function(){
        $state.go('admin.cmscomponentSettings');                  
	}
	/*Function to popup the assign parent modal.
	 *The param isSection == true, implies the modal is for assigning sections
	 *Otherwise the modal is for assigning categories
    */
	$scope.openAddCategoryModal = function(){
		$scope.isSection = false;
		
          ngDialog.open({
                template: '/assets/partials/contentManagement/adContentManagementAssignComponentModal.html',
                controller: 'ADContentManagementAssignComponentCtrl',
                className: '',
                scope: $scope
            });              
	}
	/*Function to save an item
    */
	$scope.saveItem = function(){
		var saveItemSuccessCallback = function(data){
			$scope.$emit('hideLoader');
			$scope.goBack();
		}
		var unwantedKeys = ["icon"];
		if($scope.initialIcon == $scope.data.image)
			unwantedKeys = ["icon", "image"];		

		var data = dclone($scope.data, unwantedKeys);
		$scope.invokeApi(ADContentManagementSrv.saveComponent, data , saveItemSuccessCallback);
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
	/* Function to remove the category from selected list*/
	$scope.deleteParentCategory = function(index){
		$scope.data.parent_category.splice(index, 1);
	}
	/* Listener to know that the current category is deleted.
	 * Need to go back to preveous state in this case
	 */
	$scope.$on('componentDeleted', function(event, data) {   

      $scope.goBack();

   });

}]);

