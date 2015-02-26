admin.controller('ADFloorSetupCtrl',['$scope', '$state', 'ADFloorSetupSrv', 'ngTableParams','$filter', '$anchorScroll', '$timeout',  '$location', 
 function($scope, $state, ADFloorSetupSrv, ngTableParams, $filter, $anchorScroll, $timeout, $location){
	
	$scope.errorMessage = '';
	BaseCtrl.call(this, $scope);
	$scope.floorListData = {};
	

   /*
    * To fetch list of room types
    */
	$scope.listFloorTypes = function(){
		var successCallbackFetch = function(data){
			$scope.$emit('hideLoader');
			$scope.data = data;
			$scope.currentClickedElement = -1;
			
			// REMEMBER - ADDED A hidden class in ng-table angular module js. Search for hidde or pull-right
		    $scope.tableParams = new ngTableParams({
		       page: 1,            // show first page
		       	count: 100,    // count per page - Need to change when on pagination implemntation
		        sorting: { floor_number: 'asc'     // initial sorting 
		        }
		    }, {
		     
		        getData: function($defer, params) {
		            // use build-in angular filter
		            var orderedData = params.sorting() ?
		                                $filter('orderBy')($scope.data.floors, params.orderBy()) :
		                                $scope.data.floors;
		                              
		            $scope.orderedData =  orderedData;
		                                 
		            $defer.resolve(orderedData);
		        }
		    });
		};
	   $scope.invokeApi(ADFloorSetupSrv.fetch, {} , successCallbackFetch);	
	};
	//To list room types
	$scope.listFloorTypes(); 
   /*
    * To render edit room types screen
    * @param {index} index of selected room type
    * @param {id} id of the room type
    */	
	$scope.editFloor = function(index, id)	{
		
		$scope.currentClickedElement = index;
	 	$scope.floorListData = $scope.orderedData[index]; 
	 	$scope.floorListData.floortitle = $scope.floorListData.description ;
	 	$scope.floorListData.floor_number_old = $scope.floorListData.floor_number ;
	};
   
   /*
    * To get the template of edit screen
    * @param {int} index of the selected room type
    * @param {string} id of the room type
    */
	$scope.getTemplateUrl = function(index, id){
		// if(typeof index === "undefined" || typeof id === "undefined") return "";
		if(typeof index === "undefined" ) return "";
		if($scope.currentClickedElement == index){ 
			 	return "/assets/partials/floorSetups/adFloorDetails.html";
		}
	};
  /*
   * To save/update room type details
   */
   $scope.saveFloor = function(){
		
		var unwantedKeys = [];
		var params = dclone($scope.floorListData, unwantedKeys);
		
	
		 
    	var successCallbackSave = function(data){
    		$scope.$emit('hideLoader');
    		//Since the list is ordered. Update the ordered data
    		if($scope.isAddMode){
    			$scope.data.floors.push(data);
    			$scope.tableParams.reload();
    			$scope.isAddMode = false;
    		}else{
    			$scope.orderedData[parseInt($scope.currentClickedElement)].description = $scope.floorListData.description;
    			$scope.orderedData[parseInt($scope.currentClickedElement)].floor_number = $scope.floorListData.floor_number;
    			$scope.tableParams.reload();
    			$scope.currentClickedElement = -1;
    		}		
    		
    	};
    	$scope.invokeApi(ADFloorSetupSrv.updateFloor, params , successCallbackSave);
    };

    /*
   * To delete a floor
   */
   $scope.deleteFloor = function(index){
		
		var unwantedKeys = [];
		var data = {};
		 data.id = $scope.orderedData[index].id;
    	var successCallbackSave = function(){
    		$scope.$emit('hideLoader');
    		var pos = $scope.data.floors.indexOf($scope.orderedData[index]);
    		$scope.data.floors.splice(pos, 1);
    		$scope.tableParams.reload();
    	};
    	$scope.invokeApi(ADFloorSetupSrv.deleteFloor, data , successCallbackSave);
    };
	 /*
    * To add new floor
    * 
    */		
	$scope.addNewFloor = function(){
		$scope.currentClickedElement = -1;
		$scope.isAddMode = $scope.isAddMode ? false : true;
		//reset data
		$scope.floorListData = {
				"floor_number":"",
				"description":"",
				"floortitle":""
			};	
		$timeout(function() {
            $location.hash('new-form-holder');
            $anchorScroll();
    	});
	};

	/*
    * To handle click event
    */	
	$scope.clickCancel = function(){
		$scope.floorListData.description = $scope.floorListData.floortitle;
		$scope.floorListData.floor_number = $scope.floorListData.floor_number_old;
		if($scope.isAddMode)
			$scope.isAddMode =false;
		else
		    $scope.currentClickedElement = -1;
	};	
	var  addZeros = function(n) {
 			 return (n < 10)? '0' + n :'' + n;
	}

	$scope.floors = [];
	for(i=0;i<100;i++){
		var floorData = {"value":addZeros(i),"name":addZeros(i)};
		$scope.floors.push(floorData);
	};

	$scope.validate = function(){
		if ($scope.floorListData.floor_number == "" || typeof $scope.floorListData.floor_number == "undefined" || $scope.floorListData.description == " ") 
			return false;
		else
			return true;
	};

}]);

