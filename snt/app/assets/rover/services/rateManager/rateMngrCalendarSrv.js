sntRover.service('RateMngrCalendarSrv',['$q', 'BaseWebSrvV2', function( $q, BaseWebSrvV2){
	var that = this;
	that.allRestrictionTypes = [];



	this.fetchAllRestrictionTypes = function(){
		//TODO: Modify to handle case of date range changes, if needed.
		var url =  '/api/restriction_types';	
		var deferred = $q.defer();
		if(that.allRestrictionTypes.length > 0){
			deferred.resolve(that.allRestrictionTypes)
		} else{
			BaseWebSrvV2.getJSON(url).then(function(data) {
				//Only the editable restrictions should be shown in the UI
				for(var i in data.results) {
					if(data.results[i].activated && !data.results[i].editable){
						that.allRestrictionTypes.push(data.results[i]); 
					}	
				}
				deferred.resolve(data);
			},function(data){
				deferred.reject(data);
			});
		}
		return deferred.promise;
	};


	/**
    * To fetch All Calendar data
    */
	this.fetchCalendarData = function(params){
		//var url = {"from_date":"2014-05-20","to_date":"2014-05-27","rate_type_ids":[],"rate_ids":[51,46],"name_card_ids":[]} 
		var deferred = $q.defer();
		var rejectDeferred = function(data){
			deferred.reject(data);
		};
		var getDailyRates = function(d){
			var url = "/api/daily_rates";
			var dateString = url + '?from_date=' + params.from_date 
								+ '&to_date=' + params.to_date
								+ '&per_page=' + params.per_page;
			var rateString = "";
			for(var i in params.rate_ids){
				rateString = rateString + "&rate_ids[]=" + params.rate_ids[i];
			}
			var rateTypeString = "";
			for(var i in params.rate_type_ids){
				rateTypeString = rateTypeString + "&rate_type_ids[]=" + params.rate_type_ids[i];
			}

			var nameCardString = "";
				for(var i in params.name_card_ids){
				nameCardString = nameCardString + "&name_card_ids[]=" + params.name_card_ids[i];
			}

			var urlString = dateString + rateString + rateTypeString + nameCardString;
			//var url =  '/sample_json/rate_manager/daily_rates.json';	
			BaseWebSrvV2.getJSON(urlString).then(function(data) {
				that.dailyRates = data; 

				var calendarData = that.calculateRateViewCalData();
				//If only one rate exists in the search results, 
				//then room type calendar for that rate should be displayed.
				//Fetch the room type details for that rate.
				if(calendarData.data.length == 1){
					var roomDetailsParams = {};
					roomDetailsParams.from_date = params.from_date;
					roomDetailsParams.to_date = params.to_date;
					roomDetailsParams.id = calendarData.data[0].id;
					roomDetailsParams.rate = calendarData.data[0].name;
					roomDetailsParams.isHourly = calendarData.data[0].is_hourly;

					that.fetchRoomTypeCalenarData(roomDetailsParams, deferred);
				}else{
					calendarData.type = "RATES_LIST"
					deferred.resolve(calendarData);	
				}
				
			},rejectDeferred);

		};

		that.fetchAllRestrictionTypes().then(getDailyRates, rejectDeferred);
				
		return deferred.promise;

	};

	this.fetchRoomTypeCalenarData = function(params, deferred){

		if(typeof deferred == 'undefined'){
			deferred = $q.defer();
		}
		var rejectDeferred = function(data){
			deferred.reject(data);
		};
		var getRoomTypeRates = function(d){
			
			/* It is the case of All-Rates from Rate Calendar. 
			 * TODO: Handle this case at the calling place itself.
			 */
			if(typeof(params.id) === "undefined") {
				deferred.resolve( {} );	
				return;
			};
			
			var url = "/api/daily_rates/" + params.id;
			//To pass the selected rate id and name to the controller.
			//In situations where the rate is not manually selected by user, 
			//but single rate is returned in the webservice fetch for rates list.
			//So we fetch the room details for that rate id and display the room type calendar
			if(typeof params.id != "undefined" && typeof params.rate != "undefined"){
				var selectedRate = {};
				selectedRate.id = params.id;
				selectedRate.name = params.rate;
			}
			delete params['id'];
			delete params['rate'];

			//var url =  '/sample_json/rate_manager/rate_details.json';	
			BaseWebSrvV2.getJSON(url, params).then(function(data) {
				that.roomTypeRates = data; 
				var calendarData = that.calculateRoomTypeViewCalData();
				calendarData.type = "ROOM_TYPES_LIST";
				//Pass the rate details to the controller
				calendarData.selectedRateDetails = selectedRate;
				deferred.resolve(calendarData);
			},rejectDeferred);

		};

		that.fetchAllRestrictionTypes().then(getRoomTypeRates, rejectDeferred);
				
		return deferred.promise;

	};

	this.updateRestrictions = function(params){

		var url =  '/api/daily_rates';	
		var deferred = $q.defer();
		BaseWebSrvV2.postJSON(url, params).then(function(data) {
			deferred.resolve(data);
		},function(data){
			deferred.reject(data);
		});
		return deferred.promise;

	};

	this.checkIfAnyHourlyRatePresent = function(rateData){
		var hasHourly = false;
		angular.forEach(rateData, function(rate){
			if(rate.is_hourly == true){
				hasHourly = true;
				return false;
			}

		});
		return hasHourly;
	};

	this.calculateRoomTypeViewCalData = function(){
		var calendarData = {};

		this.hasAnyHourlyRate = this.checkIfAnyHourlyRatePresent(that.roomTypeRates.results[0].room_rates);
		// Format restriction Types as required by UI, and make it a dict for easy lookup 
		var formattedRestrictionTypes = {};
		angular.forEach(that.allRestrictionTypes, function(item){
			formattedRestrictionTypes[item.id]= that.getRestrictionUIElements(item);
		});
		calendarData.restriction_types = formattedRestrictionTypes;
		
		// In UI, tables are represented as rows of columns. 
		//Input data is in opposite structure, restructuring here 
		var datesList = [];
		var ratesRestrictions = {};
		var roomRateData = [];

		angular.forEach(that.roomTypeRates.results, function(item){
		   	datesList.push(item.date);
		   	//UI requires al-rates separated from daily rates.
		   	ratesRestrictions[item.date] = item.rate_restrictions;

		   	//Adjusting Daily Rate Data - we require rows of colums - not the other way.
		   	for(var ri in item.room_rates){
		   		var rate = item.room_rates[ri];
		   		//Check if this rate is already pushed.
		   		var rateData = null;
		   		for (var i in roomRateData){
	   				if (roomRateData[i].id == rate.room_type.id)
	   				{
	   		  			rateData = roomRateData[i];
	   		  			//break;
	   				}
		   		}

		   	   	if (rateData === null){
		   	   		rateData ={
   				   				id : rate.room_type.id,
   				   				name : rate.room_type.name,
   				   				is_hourly : rate.is_hourly
   				   			};
		   			roomRateData.push(rateData);
		   		}
		   		var rr = {};
		   		rr.restrictions = rate.restrictions;
		   		rr.single = rate.single;
		   		rr["double"] = rate["double"];
		   		rr.extra_adult = rate.extra_adult;
		   		rr.child = rate.child;
		   		// ( CICO-9555 
		   		rr.isHourly	= rate.is_hourly;
		   		rr.nightly	= rate.nightly_rate;
		   		// CICO-9555 )
		   		rateData[item.date] = rr;
		   	}

		});

		calendarData.dates = datesList;
		calendarData.rate_restrictions = ratesRestrictions;
		calendarData.data = roomRateData;

		//close all/open all restriction status
		var enableDisableCloseAll = that.getCloseAllEnableDisableStatus(calendarData.data, "ROOM_TYPE");
		calendarData.disableCloseAllBtn = !enableDisableCloseAll.enableCloseAll;
		calendarData.disableOpenAllBtn = !enableDisableCloseAll.enableOpenAll;

		return calendarData;
	};


	this.calculateRateViewCalData = function(){
		var calendarData = {};
	
		this.hasAnyHourlyRate = this.checkIfAnyHourlyRatePresent(that.dailyRates.results[0].rates);
		// Format restriction Types as required by UI, and make it a dict for easy lookup 
		var formattedRestrictionTypes = {};
		angular.forEach(that.allRestrictionTypes, function(item){
			formattedRestrictionTypes[item.id]= that.getRestrictionUIElements(item);
		});
		calendarData.restriction_types = formattedRestrictionTypes;
		
		// In UI, tables are represented as rows of columns. 
		//Input data is in opposite structure, restructuring here 
		var datesList = [];
		var allRatesData = {};
		var dailyRatesData = [];

		angular.forEach(that.dailyRates.results, function(item){
		   	datesList.push(item.date);

		   	//UI requires al-rates separated from daily rates.
		   	allRatesData[item.date] = item.all_rate_restrictions;

		   	//Adjusting Daily Rate Data - we require rows of colums - not the other way.
		   	for(var ri in item.rates){
		   		var rate = item.rates[ri];
		   		//Check if this rate is already pushed.
		   		var rateData = null;
		   		for (var i in dailyRatesData){
	   				if (dailyRatesData[i].id == rate.id)
	   				{
	   		  			rateData = dailyRatesData[i];
	   		  			//break;
	   				}
		   		}

		   	   	if (rateData === null){
		   			rateData ={
		   				id : rate.id,
		   				name : rate.name,
		   				isHourly : rate.is_hourly
		   			};
		   			dailyRatesData.push(rateData);
		   		}
		   		rateData[item.date] = rate.restrictions;

		   	}

		});

		calendarData.dates = datesList;
		calendarData.all_rates = allRatesData;
		calendarData.data = dailyRatesData;
		//close all/open all restriction status
		var enableDisableCloseAll = that.getCloseAllEnableDisableStatus(calendarData.data, "RATE_TYPE");
		calendarData.disableCloseAllBtn = !enableDisableCloseAll.enableCloseAll;
		calendarData.disableOpenAllBtn = !enableDisableCloseAll.enableOpenAll;
		
		return calendarData;
	};

	//compute the closeall/openall restriction status beased on the total number of 
	//closed restrictions in the all_rates/all_restrictions section
	that.getCloseAllEnableDisableStatus = function(rateData, type) {
		//Check if CLOSE ALL restriction is available in all_rates section
		var closedRestrictionId = -1,
			dict = {};
		    dict.enableOpenAll = false,
		    dict.enableCloseAll = false;

		//Get the id for 'CLOSED' restriction
		for(var i in that.allRestrictionTypes){
			if (that.allRestrictionTypes[i].value == 'CLOSED'){
				closedRestrictionId = that.allRestrictionTypes[i].id;
				break;
			}
		}

		//Iterate through each calendar cell to find if 'CLOSED' restricion is available
		for(var i in rateData){
			var rate = rateData[i];
			var isDate = false;
			for(var date in rate){
				
				// Ignore keys other date object
				if (date == "id" || date == "name" || date == 'is_hourly' || date == 'isHourly') {
					continue;	
				} 

				// Ignore keys other date object
				// isDateKey = !isNaN(Date.parse(date));
				// if(!isDateKey){
				// 	continue;
				// }
				//We don't want to check the history dates
				if( (new Date(date).getTime() < new Date(that.businessDate).getTime()) ){
			   		continue;
		   		}
		   		
		   		var item = rate[date];
		   		if(type == "ROOM_TYPE") {
		   			var item = rate[date].restrictions;
		   		}
		   		//If the 'CLOSED' restriction is available in any of the cell, the openall button is enabled
		   		// If 'CLOSED' restriction is absent in any cell, close all button is enabled
		   		var isDateClosed = false;
		   		for (var j in item){
		   			if(item[j].restriction_type_id == closedRestrictionId){		
		   				dict.enableOpenAll = true;
		   				isDateClosed = true;
		   				break;
		   			}
		   		}
   				if(isDateClosed === false) {
   					dict.enableCloseAll = true;
   				}	

		   	}
		}
		return dict;
	};


	this.getRestrictionUIElements = function(restriction_type){
		var restriction_type_updated = {};
		//TODO: Add UI condition checks using "restrVal"
		restriction_type_updated.icon = "";
		//(CICO-9555
		restriction_type_updated.hideOnHourly = false;
		//CICO-9555)		
		if('CLOSED' == restriction_type.value) {
			restriction_type_updated.icon = "icon-cross";
		} 
		if('CLOSED_ARRIVAL' == restriction_type.value) {
			restriction_type_updated.icon = "icon-block";
		}
		restriction_type_updated.background_class = "";
		if(['CLOSED', 'CLOSED_ARRIVAL', 'CLOSED_DEPARTURE'].indexOf(restriction_type.value) >= 0){
			restriction_type_updated.background_class = "bg-red";
		}
		if('MIN_STAY_LENGTH' == restriction_type.value) {
			restriction_type_updated.background_class = "bg-blue";
			if(that.hasAnyHourlyRate){
				restriction_type_updated.hideOnHourly = true; // CICO-9555
			}
		}
		if('MAX_STAY_LENGTH' == restriction_type.value) {
			if(that.hasAnyHourlyRate){
				restriction_type_updated.hideOnHourly = true; // CICO-9555
			}
		}
		if('MIN_ADV_BOOKING' == restriction_type.value) {
			restriction_type_updated.background_class = "bg-green";
		}
		if('MIN_STAY_THROUGH' == restriction_type.value) {
			restriction_type_updated.background_class = "bg-violet";
			if(that.hasAnyHourlyRate){
				restriction_type_updated.hideOnHourly = true; // CICO-9555
			}
		}
		restriction_type_updated.id = restriction_type.id;
		restriction_type_updated.description = restriction_type.description;
		restriction_type_updated.value = restriction_type.value;
		restriction_type_updated.activated = restriction_type.activated;
		restriction_type_updated.editable = restriction_type.editable;
		


		return restriction_type_updated;
	};



}]);
