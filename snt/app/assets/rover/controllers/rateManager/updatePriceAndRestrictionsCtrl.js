sntRover.controller('UpdatePriceAndRestrictionsCtrl', ['$q', '$scope','$rootScope', 'ngDialog','dateFilter', 'RateMngrCalendarSrv', 'UpdatePriceAndRestrictionsSrv',
    function ($q, $scope, $rootScope, ngDialog, dateFilter, RateMngrCalendarSrv, UpdatePriceAndRestrictionsSrv) {
    
    $scope.init = function(){
        $scope.showRestrictionDayUpdate = false;
        $scope.showExpandedView = false;

        $scope.data = {};
        $scope.data.showEditView = false;

        if($scope.popupData.fromRoomTypeView){
            computePopupdataForRoomTypeCal();
        }else{
            computePopUpdataForRateViewCal();
            fetchPriceDetailsForRate();
        }

        if($scope.popupData.all_data_selected){
            $scope.data.isHourly = $scope.calendarData.data[0][$scope.popupData.selectedDate].isHourly;
        }

        $scope.updatePopupWidth();
    };

    $scope.$parent.myScrollOptions = {
        'restictionsList' : {            
            scrollbars : true,
            interactiveScrollbars : true,
            click : true,
            snap : false             
        },
        'priceList' : {
            scrollbars : true,
            interactiveScrollbars : true,
            click : true, 
            snap : false
        }
    };

    $scope.refreshPopUpScrolls = function(){
        setTimeout(function(){
            if(typeof $scope.myScroll['restictionsList'] != 'undefined')
            $scope.myScroll['restictionsList'].refresh();
            if(typeof $scope.myScroll['priceList'] != 'undefined')
            $scope.myScroll['priceList'].refresh();
            if(typeof $scope.myScroll['restictionWeekDaysScroll'] != 'undefined')
            $scope.myScroll['restictionWeekDaysScroll'].refresh();
        },1000);
    }

    $scope.restrictionsList = {
        selectedIndex : -1
    };

    //To display the day options in the popup expanded view
    $scope.daysOptions = {  "days":[ 
                            {key:"MON",day:"MONDAY",value:false},
                            {key:"TUE",day:"TUESDAY",value:false},
                            {key:"WED",day:"WEDNESDAY",value:false},
                            {key:"THU",day:"THURSDAY",value:false},
                            {key:"FRI",day:"FRIDAY",value:false},
                            {key:"SAT",day:"SATURDAY",value:false},
                            {key:"SUN",day:"SUNDAY",value:false}
                        ],
                    "numOfWeeks" : 1,
                    "applyToPrice" : true,
                    "applyToRestrictions" : true
                 };

    $scope.hideUpdatePriceAndRestrictionsDialog = function(){
        ngDialog.close();
    };

    /**
    * For displaying the price in expanded view
    * Fetch the price info and update the $scope data variable
    */
    var fetchPriceDetailsForRate = function() {
        var data = {};
        data.id = $scope.popupData.selectedRate;
        data.from_date = dateFilter($scope.popupData.selectedDate, 'yyyy-MM-dd');
        data.to_date = dateFilter($scope.popupData.selectedDate, 'yyyy-MM-dd');
        var priceDetailsFetchSuccess = function(response) {
            var roomPriceData = [];
            for (var i in response.data){
                var roomType = {};
                roomType.name = response.data[i].name;
                roomType.rate = response.data[i][$scope.popupData.selectedDate].single;
                roomPriceData.push(roomType);
            }
            $scope.data.roomPriceData = roomPriceData;
            $scope.$emit('hideLoader');
        };
        $scope.invokeApi(RateMngrCalendarSrv.fetchRoomTypeCalenarData, data, priceDetailsFetchSuccess);


    };

    /**
    * If the popup is opened from room type calendar view.
    * Compute the data structure for the popup display using the 'calendarData' info 
    */
    var computePopupdataForRoomTypeCal = function(){
        $scope.data = {};
        $scope.data.id = '';
        $scope.data.name = '';

        $scope.data.single = '';
        $scope.data.double = '';
        $scope.data.extra_adult = '';
        $scope.data.child = '';
        $scope.data.nightly = '';

        $scope.data.nightly_sign = '+';
        $scope.data.nightly_extra_amnt = '';
        $scope.data.nightly_amnt_diff = $rootScope.currencySymbol;
        
        $scope.data.single_sign = '+';
        $scope.data.single_extra_amnt = '';
        $scope.data.single_amnt_diff = $rootScope.currencySymbol;
        
        $scope.data.double_sign = '+';
        $scope.data.double_extra_amnt = '';
        $scope.data.double_amnt_diff = $rootScope.currencySymbol;
        
        $scope.data.extra_adult_sign = '+';
        $scope.data.extra_adult_extra_amnt = '';
        $scope.data.extra_adult_amnt_diff = $rootScope.currencySymbol;
        
        $scope.data.child_sign = '+';
        $scope.data.child_extra_amnt = '';
        $scope.data.child_amnt_diff = $rootScope.currencySymbol;

        

        //Flag to check if the rate set amounts are configured for the selected date
        $scope.data.hasAmountConfigured = true;

                
               
        selectedDateInfo = {};

        //Get the rate/restriction details for the selected cell
        if($scope.popupData.all_data_selected) {
            selectedDateInfo.restrictions = $scope.calendarData.rate_restrictions[$scope.popupData.selectedDate];
            $scope.data.isHourly= $scope.calendarData.data[0][$scope.popupData.selectedDate].isHourly;                        
        } else {
            for(var i in $scope.calendarData.data){
                if($scope.calendarData.data[i].id == $scope.popupData.selectedRoomType){
                    selectedDateInfo = $scope.calendarData.data[i][$scope.popupData.selectedDate];
                    $scope.data.id = $scope.calendarData.data[i].id;
                    $scope.data.name = $scope.calendarData.data[i].name;
                    if(typeof selectedDateInfo != "undefined"){
                        $scope.data.isHourly= selectedDateInfo.isHourly;
                        //Check if the rate set amounts are configured for the selected date
                        if(selectedDateInfo.single == undefined &&
                            selectedDateInfo.double == undefined &&
                            selectedDateInfo.extra_adult == undefined &&
                            selectedDateInfo.child == undefined && 
                            (selectedDateInfo.isHourly && !selectedDateInfo.nightly == undefined)){ //CICO-9555
                            $scope.data.hasAmountConfigured = false;
                        } else {
                            $scope.data.single = selectedDateInfo.single;
                            $scope.data.double = selectedDateInfo.double;
                            $scope.data.extra_adult = selectedDateInfo.extra_adult;
                            $scope.data.child = selectedDateInfo.child;
                            //(CICO-9555                            
                            $scope.data.nightly= selectedDateInfo.nightly;
                            //CICO-9555)
                        }
                    }
                }
            }
        }
        
        var restrictionTypes = {};
        var rTypes = dclone($scope.calendarData.restriction_types);
        for(var i in rTypes){
            restrictionTypes[rTypes[i].id] = rTypes[i];
            var item =  rTypes[i];
            var itemID = rTypes[i].id;
            item.days = "";
            item.isRestrictionEnabled = false;
            item.isMixed = false;
            item.hasChanged = false;
            item.showEdit = false;
            item.hasEdit = isRestictionHasDaysEnter(rTypes[i].value);

            if(selectedDateInfo != undefined){
                for(var i in selectedDateInfo.restrictions){
                    if(selectedDateInfo.restrictions[i].restriction_type_id == itemID){
                        item.days = selectedDateInfo.restrictions[i].days;
                        item.isOnRate = selectedDateInfo.restrictions[i].is_on_rate;
                        item.isRestrictionEnabled = true;
                        break;
                    }
                }
            }
            //In all data section, if the restriction is disabled(if enabled, all rates have the restriction enabled for that date, hence not mixed),
            //we should check if the restriction is mixed restriction
            if($scope.popupData.all_data_selected && !item.isRestrictionEnabled && isMixed(itemID)) {
                item.isMixed = true;
            }
            
            restrictionTypes[itemID] = item;
        }
        $scope.data.restrictionTypes = restrictionTypes;
		
    };

    /**
    * If the popup is opened from rate type calendar view.
    * Compute the data structure for the popup display using the 'calendarData' info 
    */
    var computePopUpdataForRateViewCal = function(){
        $scope.data = {};
        $scope.data.id = "";
        $scope.data.name = "";

        var selectedDateInfo = {};
        //Get the rate/restriction details for the selected cell
        if($scope.popupData.all_data_selected) {
            selectedDateInfo = $scope.calendarData.all_rates[$scope.popupData.selectedDate];

        } else {
            for(var i in $scope.calendarData.data){
                if($scope.calendarData.data[i].id == $scope.popupData.selectedRate){
                    selectedDateInfo = $scope.calendarData.data[i][$scope.popupData.selectedDate];
                    $scope.data.id = $scope.calendarData.data[i].id;
                    $scope.data.name = $scope.calendarData.data[i].name;
                    $scope.data.isHourly = $scope.calendarData.data[i].isHourly;
                }
            }
        }

        var restrictionTypes = {};
        var rTypes = dclone($scope.calendarData.restriction_types);
        for(var i in rTypes){
            restrictionTypes[rTypes[i].id] = rTypes[i];
            var item =  rTypes[i];
            var itemID = rTypes[i].id;
			item.days = "";
            item.isRestrictionEnabled = false;
            item.isMixed = false;
            item.hasChanged = false;
            item.showEdit = false;
            item.hasEdit = isRestictionHasDaysEnter(rTypes[i].value);

            if(selectedDateInfo != undefined){
                for(var i in selectedDateInfo){
                    if(selectedDateInfo[i].restriction_type_id == itemID){
                        item.days = selectedDateInfo[i].days;
                        item.isOnRate = selectedDateInfo[i].is_on_rate;
                        item.isRestrictionEnabled = true;
                        break;
                    }
                }
            }
            //In all data section, if the restriction is disabled(if enabled, all roomrates have the restriction enabled for that date, hence not mixed),
            //we should check if the restriction is mixed restriction
            if($scope.popupData.all_data_selected && !item.isRestrictionEnabled && isMixed(itemID)) {
                item.isMixed = true;
            }

            restrictionTypes[itemID] = item;
        }
        $scope.data.restrictionTypes = restrictionTypes;
    };

    var isRestictionHasDaysEnter = function(restriction){
        var ret = false;
        if(['MIN_STAY_LENGTH', 'MAX_STAY_LENGTH', 'MIN_STAY_THROUGH', 'MIN_ADV_BOOKING', 'MAX_ADV_BOOKING'].indexOf(restriction) >= 0){
            ret = true;
        }
        return ret;
    }

    /* This does not handle the case of "Selected for all Rates", as this can be deduced from allData
    */
    var isMixed = function(id){
        var mixed = false;
        for (var row in $scope.calendarData.data){
            if($scope.popupData.fromRoomTypeView){
                var datedata = $scope.calendarData.data[row][$scope.popupData.selectedDate].restrictions;
            }else{
                var datedata = $scope.calendarData.data[row][$scope.popupData.selectedDate];
            }
            for (var restriction in datedata){
                if (datedata[restriction]['restriction_type_id'] === id) {
                    mixed =true;
                    break;
                }
            }
        }
        return mixed;
    }
    /**
    * Click handler for restriction on/off buttons
    * Enable disable restriction. 
    */
    $scope.toggleRestrictions = function(id, days, selectedIndex) {
        var action = $scope.data.restrictionTypes[id].isRestrictionEnabled;
        
        $scope.onOffRestrictions(id, (action) ? 'DISABLE' : 'ENABLE', days,selectedIndex);
    };
    /**
    * Click handler for restriction on/off buttons
    * Enable disable restriction. 
    */
    $scope.onOffRestrictions = function(id, action, days,selectedIndex){
        $scope.data.showEditView = false;
        $scope.restrictionsList.selectedIndex = selectedIndex;

    	angular.forEach($scope.data.restrictionTypes, function(value, key){
    		value.showEdit =  false;
    	});

        /*Prompt the user for number of days
         * Only if enabling a restriction.
         */
        var shouldShowEdit =false;
        if($scope.data.restrictionTypes[id].hasEdit && action === "ENABLE"){
            shouldShowEdit = true;
        }

        if($scope.popupData.all_data_selected && action === "ENABLE" && $scope.data.restrictionTypes[id].isMixed){
            shouldShowEdit = true;
        }


        if(shouldShowEdit){
            $scope.data.showEditView = true;
            $scope.data.restrictionTypes[id].showEdit = true;
            $scope.updatePopupWidth();
            return false;
        }
        if(action === "ENABLE"){
            $scope.data.restrictionTypes[id].isRestrictionEnabled = true; 
            $scope.data.restrictionTypes[id].hasChanged = true; 
            $scope.data.restrictionTypes[id].isMixed = false; 
        }
        if(action === "DISABLE"){
            $scope.data.restrictionTypes[id].isRestrictionEnabled = false; 
            $scope.data.restrictionTypes[id].hasChanged = true; 
            $scope.data.restrictionTypes[id].isMixed = false;
        }
        $scope.updatePopupWidth();

    };

    $scope.updatePopupWidth = function() {
        var width = 270;
        if($scope.data.showEditView) {
            width = width + 400;
        }
        if($scope.showExpandedView) {
            width = width + 270;
        }
        if($scope.popupData.fromRoomTypeView && !$scope.data.showEditView && $scope.data.hasAmountConfigured) {
            width = width + 400;
        }
        if($scope.showExpandedView && !$scope.popupData.fromRoomTypeView && !$scope.popupData.all_data_selected) {
            width = width + 270;
        }
        $(".ngdialog-content").css("width", width);

    }

    $scope.expandButtonClicked = function(){
        $scope.showExpandedView = !$scope.showExpandedView;
        $scope.updatePopupWidth();
        $scope.refreshPopUpScrolls();
    };

    /**
    * Computes all the selected dates
    */
    var getAllSelectedDates = function() {

        var datesList = [];
        //First entry in the dates list is the current date
        datesList.push($scope.popupData.selectedDate);
        //If the day value is true, then it is a checked(selected) day
        var selectedDays = [];

        $($scope.daysOptions.days).each(function(){
            if(this.value === true){
                selectedDays.push(this.key.toUpperCase());
            }
        });
        
        //We dont have to add more dates to the dates list if no day is checked            
        if(selectedDays.length <= 0) {
            return datesList;
        }

        //For the selected date range, if the day matches the selected day of week,
        //Add the date to the datesList
        for (var i=1 ; i<($scope.daysOptions.numOfWeeks) * 7 ; i++){
            var date = new Date($scope.popupData.selectedDate);
            var newDate = new Date(date.getTime() + (i * 24 * 60 * 60 * 1000));
            var dayOfWeek = dateFilter(newDate, 'EEE');
            if(selectedDays.indexOf(dayOfWeek.toUpperCase()) >= 0) {
                datesList.push(getDateString(newDate));

            }
        }

        return datesList;
    };

    var calculateDetailsToSave = function(datesSelected){
        var details = [];

        // We do not show the apply to restrictions option if not from room type calendar view
        // So setting the flag by default as true
        if(!$scope.popupData.fromRoomTypeView){
            $scope.daysOptions.applyToRestrictions = true;
        }

        for(var i in datesSelected) {
            var restrictionDetails = {};
            if(!$scope.daysOptions.applyToRestrictions && !$scope.daysOptions.applyToPrice && i> 0) {
                break;
            }
            restrictionDetails.from_date = datesSelected[i];
            restrictionDetails.to_date = datesSelected[i];
            restrictionDetails.restrictions = [];
            
            if($scope.daysOptions.applyToRestrictions || (!$scope.daysOptions.applyToRestrictions && i== 0)) {
                angular.forEach($scope.data.restrictionTypes, function(value, key){
                    if(value.hasChanged){
                        var action = "";
                        if(value.isRestrictionEnabled) {
                            action = "add";
                        } else {
                            action = "remove";
                        }

                        var restrictionData = {
                            "action": action,
                            "restriction_type_id": value.id,
                            "days": value.days
                        };
                        restrictionDetails.restrictions.push(restrictionData);
                    }
                });
            }

            //The popup appears by from the rate calendar view
            if($scope.popupData.fromRoomTypeView){
                if($scope.daysOptions.applyToPrice || (!$scope.daysOptions.applyToPrice && i== 0)) {
                    restrictionDetails.single = {};
                    restrictionDetails.double = {};
                    restrictionDetails.extra_adult = {};
                    restrictionDetails.child = {};
                    restrictionDetails.nightly = {};

                    //(CICO-9555
                    if($scope.data.nightly_extra_amnt !== ""){
                        restrictionDetails.nightly.value = $scope.data.nightly_sign + $scope.data.nightly_extra_amnt;
                        
                        if($scope.data.nightly_amnt_diff_sign !== "%"){
                            restrictionDetails.nightly.type = "amount_diff";
                        } else {
                            restrictionDetails.nightly.type = "percent_diff";
                        }
                        
                    } else {
                        restrictionDetails.nightly.value = $scope.data.nightly;
                        restrictionDetails.nightly.type = "amount_new";
                    }
                    //CICO-9555)

                    if($scope.data.single_extra_amnt !== ""){
                        restrictionDetails.single.value = $scope.data.single_sign + $scope.data.single_extra_amnt;
                        
                        if($scope.data.single_amnt_diff !== "%"){
                            restrictionDetails.single.type = "amount_diff";
                        } else {
                            restrictionDetails.single.type = "percent_diff";
                        }
                        
                    } else {
                        restrictionDetails.single.value = $scope.data.single;
                        restrictionDetails.single.type = "amount_new";
                    }
                    
                    if($scope.data.double_extra_amnt !== ""){
                        restrictionDetails.double.value = $scope.data.double_sign + $scope.data.double_extra_amnt;
                        if($scope.data.double_amnt_diff !== "%"){
                            restrictionDetails.double.type = "amount_diff";
                        } else {
                            restrictionDetails.double.type = "percent_diff";
                        }
                        
                    } else {
                        restrictionDetails.double.value = $scope.data.double;
                        restrictionDetails.double.type = "amount_new";
                    }
                    
                    if($scope.data.extra_adult_extra_amnt !== ""){
                        restrictionDetails.extra_adult.value = $scope.data.extra_adult_sign + $scope.data.extra_adult_extra_amnt;
                        if($scope.data.extra_adult_amnt_diff !== "%"){
                            restrictionDetails.extra_adult.type = "amount_diff";
                        } else {
                            restrictionDetails.extra_adult.type = "percent_diff";
                        }
                        
                    } else {
                        restrictionDetails.extra_adult.value = $scope.data.extra_adult;
                        restrictionDetails.extra_adult.type = "amount_new";
                    }
                    
                    if($scope.data.child_extra_amnt !== ""){
                        restrictionDetails.child.value = $scope.data.child_sign + $scope.data.child_extra_amnt;
                        if($scope.data.child_amnt_diff !== "%"){
                            restrictionDetails.child.type = "amount_diff";
                        } else {
                            restrictionDetails.child.type = "percent_diff";
                        }
                        
                    } else {
                        restrictionDetails.child.value = $scope.data.child;
                        restrictionDetails.child.type = "amount_new";
                    }
                    restrictionDetails.single.value = parseFloat(restrictionDetails.single.value);
                    restrictionDetails.double.value = parseFloat(restrictionDetails.double.value);
                    restrictionDetails.extra_adult.value = parseFloat(restrictionDetails.extra_adult.value);
                    restrictionDetails.child.value = parseFloat(restrictionDetails.child.value);
                    restrictionDetails.nightly.value = parseFloat(restrictionDetails.nightly.value);
                }
            }
            details.push(restrictionDetails);

        }
        
        return details;
        

    }

    /**
    * Click handler for save button in popup.
    * Calls the API and dismiss the popup on success
    */
    $scope.saveRestriction = function(){
        //The dates to which the restriction should be applied
        var datesSelected = getAllSelectedDates();
    	
    	var data = {};
        data.rate_id = $scope.popupData.selectedRate;

        if($scope.popupData.fromRoomTypeView){
            data.room_type_id = $scope.popupData.selectedRoomType;
        }
    	data.details = calculateDetailsToSave(datesSelected);
        var saveRestrictionSuccess = function() {
            $scope.refreshCalendar();
            ngDialog.close();
        };

    	$scope.invokeApi(UpdatePriceAndRestrictionsSrv.savePriceAndRestrictions, data, saveRestrictionSuccess);
    	
    };


    $scope.init();
        
}]);
