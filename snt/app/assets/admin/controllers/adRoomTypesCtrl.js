admin.controller('ADRoomTypesCtrl',['$scope', '$state', 'ADRoomTypesSrv', 'ngTableParams','$filter','$anchorScroll', '$timeout', '$location', function($scope, $state, ADRoomTypesSrv, ngTableParams, $filter, $anchorScroll, $timeout, $location){
	
	$scope.errorMessage = '';
	BaseCtrl.call(this, $scope);
	$scope.roomTypeData = {};
	$scope.successMessage = "";
	$scope.errorMessage ="";	
	$scope.fileName = "Choose File....";

   /*
    * To fetch list of room types
    */
	$scope.listRoomTypes = function(){
		var successCallbackFetch = function(data){
			$scope.$emit('hideLoader');
			$scope.data = data;
			$scope.currentClickedElement = -1;
			// REMEMBER - ADDED A hidden class in ng-table angular module js. Search for hidde or pull-right
		    $scope.tableParams = new ngTableParams({
		        page: 1,            // show first page
		        count: 10000,    // count per page - Need to change when on pagination implemntation
		        sorting: {
		            name: 'asc'     // initial sorting
		        }
		    }, {
		        total: $scope.data.room_types.length, // length of data
		        getData: function($defer, params) {
		            // use build-in angular filter
		            var orderedData = params.sorting() ?
		                                $filter('orderBy')($scope.data.room_types, params.orderBy()) :
		                                $scope.data.room_types;
		                              
		            $scope.orderedData =  orderedData;
		                       
		            $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()));
		        }
		    });
		};
		$scope.invokeApi(ADRoomTypesSrv.fetch, {} , successCallbackFetch);	
	};
	//To list room types
	$scope.listRoomTypes(); 
   /*
    * To render edit room types screen
    * @param {index} index of selected room type
    * @param {id} id of the room type
    */	
	$scope.editRoomTypes = function(index, id)	{
		$scope.isAddMode =false;
		$scope.departmentData={};
		$scope.currentClickedElement = index;
		$scope.roomTypeData = {};
	 	var successCallbackRender = function(data){	
	 		$scope.$emit('hideLoader');
	 		$scope.roomTypeData = data;
	 		if($scope.roomTypeData.is_pseudo_room_type == "true" || $scope.roomTypeData.is_pseudo_room_type == true){
	 			$scope.roomTypeData.is_pseudo_room_type = true;
	 		}
	 		else{
	 			$scope.roomTypeData.is_pseudo_room_type = false;
	 		}
	 		if($scope.roomTypeData.is_suite == "true" || $scope.roomTypeData.is_suite == true){
	 			$scope.roomTypeData.is_suite = true;
	 		}
	 		else{
	 			$scope.roomTypeData.is_suite = false;
	 		}
	 	};
	 	var data = {"id":id };
	 	$scope.invokeApi(ADRoomTypesSrv.getRoomTypeDetails, data , successCallbackRender);    
	};
   
   /*
    * To get the template of edit screen
    * @param {int} index of the selected room type
    * @param {string} id of the room type
    */
	$scope.getTemplateUrl = function(index, id){
		if(typeof index === "undefined" || typeof id === "undefined") return "";
		if($scope.currentClickedElement == index){ 
			 	return "/assets/partials/roomTypes/adRoomTypesDetails.html";
		}
	};
  /*
   * To save/update room type details
   */
   $scope.saveRoomTypes = function(){
		
		var unwantedKeys = [];
		if($scope.roomTypeData.image_of_room_type.indexOf("data:")!= -1){
		} else {
			unwantedKeys = ["image_of_room_type"];
		}
		 var data = dclone($scope.roomTypeData, unwantedKeys);
		 
    	var editSuccessCallbackSave = function(data){
    		$scope.$emit('hideLoader');
    		//Since the list is ordered. Update the ordered data
    		$scope.orderedData[parseInt($scope.currentClickedElement)].name = $scope.roomTypeData.room_type_name;
    		$scope.orderedData[parseInt($scope.currentClickedElement)].code = $scope.roomTypeData.room_type_code;
    		$scope.currentClickedElement = -1;
    	};
    	var addSuccessCallbackSave = function(data){
    		$scope.$emit('hideLoader');
    		$scope.isAddMode = false;
    		$scope.data.room_types.push({'name':$scope.roomTypeData.room_type_name,'code':$scope.roomTypeData.room_type_code,'id':data.id});
    		$scope.tableParams.reload();
    	};
    	

    	if($scope.isAddMode)
    		$scope.invokeApi(ADRoomTypesSrv.createRoomType, data , addSuccessCallbackSave);
      	else
    	    $scope.invokeApi(ADRoomTypesSrv.updateRoomTypes, data , editSuccessCallbackSave);
    };
   /*
    * To handle click event
    */	
	$scope.clickCancel = function(){
		if($scope.isAddMode){
			$scope.isAddMode =false;
			$scope.fileName = "";
        }
		else
		    $scope.currentClickedElement = -1;
	};	
   /*
    * To import form pms
    * 
    */		
	$scope.importFromPms = function(event){
		event.stopPropagation();
		
		$scope.successMessage = "Collecting rooms data from PMS and adding to Rover...";
		
		var successCallbackImport = function(data){	
	 		$scope.$emit('hideLoader');
	 		$scope.listRoomTypes();
	 		$scope.successMessage = "Completed!";
	 		$timeout(function() {
		        $scope.successMessage = "";
		    }, 1000);
	 		// $scope.data.departments.splice(index, 1);
	 	};
	 	var errorCallbackImport = function(data){
	 		$scope.$emit('hideLoader');
	 		$scope.successMessage ="";
	 		$scope.errorMessage = data;	
	 	}

	 	
		$scope.invokeApi(ADRoomTypesSrv.importFromPms, '' , successCallbackImport);
	};

  /*
    * To add new room type
    * 
    */		
	$scope.addNewRoomType = function(){
		$scope.currentClickedElement = -1;
		$scope.isAddMode = $scope.isAddMode ? false : true;
		$scope.fileName = "Choose File....";

		//reset data
			$scope.roomTypeData = {
				"room_type_id": "",
			"room_type_code": "",
			"room_type_name": "",
			"snt_description": "",
			"max_occupancy": "",
			"is_pseudo_room_type": "",
			"is_suite": "",
			"image_of_room_type": ""

		};
		$timeout(function() {
            $location.hash('new-form-holder');
            $anchorScroll();
    	});	
    	

	};
	$scope.sortByName = function(){
		if($scope.currentClickedElement == -1)
		$scope.tableParams.sorting({'name' : $scope.tableParams.isSortBy('name', 'asc') ? 'desc' : 'asc'});
	};
	$scope.sortByCode = function(){
		if($scope.currentClickedElement == -1)
		$scope.tableParams.sorting({'code' : $scope.tableParams.isSortBy('code', 'asc') ? 'desc' : 'asc'});
	};
	$scope.deleteRoomTypes = function(roomtype_id){
		var successCallBack = function(){
			$scope.$emit('hideLoader');
			//actualIndex holds the index of clicked element in $scope.data.room_types 
			var actualIndex = $scope.data.room_types.map(function(x){return x.id }).indexOf(roomtype_id);
      		$scope.data.room_types.splice(actualIndex, 1);
			$scope.tableParams.page(1);
        	$scope.tableParams.reload();        	
		}	
	$scope.invokeApi(ADRoomTypesSrv.deleteRoomTypes, {'roomtype_id': roomtype_id}, successCallBack);
	}
}]);

