admin.controller('settingsAndParamsCtrl',['$scope','settingsAndParamsSrv','settingsAndParamsData','chargeCodes', function($scope,settingsAndParamsSrv,settingsAndParamsData,chargeCodes){

	BaseCtrl.call(this, $scope);
	$scope.hours = ["01","02","03","04","05","06","07","08","09","10","11","12"];
	$scope.minutes = ["00","15","30","45"];


    $scope.data = settingsAndParamsData.business_date;
    $scope.chargeCodes = chargeCodes;
    $scope.selected_charge_code = settingsAndParamsData.no_show_charge_code_id;
  
    /**
    * To handle save button action
    *
    */ 
    $scope.saveClick = function(){

        var saveDetailsSuccessCallback = function(){
             $scope.$emit('hideLoader');
             $scope.goBackToPreviousState();

             var eodSubMenu =  {
                        title: "MENU_END_OF_DAY",
                        action: "staff#/staff/dashboard/changeBussinessDate"
                      };

            var frontDeskSubmenu = [];
            angular.forEach($scope.menu, function(menu, index) {
                if(menu.title === 'MENU_FRONT_DESK'){
                    frontDeskSubmenu =  menu.submenu;
                }
            });

            if(!$scope.data.is_auto_change_bussiness_date){
                 var eodSubmenuPresent = false;
                 angular.forEach(frontDeskSubmenu, function(submenu, index) {
                    if(submenu.title === 'MENU_END_OF_DAY'){
                        eodSubmenuPresent = true;
                    }
                });
                if(!eodSubmenuPresent)
                {
                    frontDeskSubmenu.push(eodSubMenu);  
                }                
            }
            else{
                angular.forEach(frontDeskSubmenu, function(submenu, index) {
                    if(submenu.title === 'MENU_END_OF_DAY'){
                       frontDeskSubmenu.splice(index,1)
                    }
                });
            };
        }
        var selectedChargeCode = ( typeof $scope.selected_charge_code == 'undefined' ) ? "" : $scope.selected_charge_code;
        var dataToSend = { "no_show_charge_code_id" : selectedChargeCode , "business_date" : $scope.data };
        
        $scope.invokeApi(settingsAndParamsSrv.saveSettingsAndParamsSrv, dataToSend ,saveDetailsSuccessCallback);
    };


}]);