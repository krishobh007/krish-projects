sntRover.service('RVKeyPopupSrv',['$q', 'RVBaseWebSrv', 'rvBaseWebSrvV2', function($q, RVBaseWebSrv, rvBaseWebSrvV2){
	/*
	 * Service function to get data for Email popup
	 */	
	this.fetchKeyEmailData = function(param){
		
		var deferred = $q.defer();
		var url =  "staff/reservations/" + param.reservationId + "/get_key_setup_popup";			
		
		RVBaseWebSrv.getJSON(url).then(function(data) {
			deferred.resolve(data);
		},function(data){
			deferred.reject(data);
		});
		return deferred.promise;		
		
	};
	/*
	 * Service function to get data for QR Code popup
	 */
	this.fetchKeyQRCodeData = function(param){
		
		var deferred = $q.defer();
		var url =  "staff/reservations/" + param.reservationId + "/get_key_on_tablet.json";	
		
		RVBaseWebSrv.getJSON(url).then(function(data) {
			deferred.resolve(data);
		},function(data){
			deferred.reject(data);
		});
		return deferred.promise;		
		
	};


	/**
	* service function to get key from server by passing id from the card
	*/
	this.fetchKeyFromServer = function(params){
		var deferred = $q.defer();
		var url =  "/staff/reservation/print_key";	
		//var url = '/ui/show?format=json&json_input=keys/fetch_encode_key.json';

		
		RVBaseWebSrv.postJSON(url, params).then(function(data) {
			deferred.resolve(data);
		},function(data){
			deferred.reject(data);
		});
		return deferred.promise;		
	};


	/**
	* service function to add smartband to server
	*/
	this.addNewSmartBand = function(params){
		var deferred = $q.defer();
		var reservationId = params.reservationId;
		//we are removing the unwanted keys and that will be posted to API
 		var unWantedKeysToRemove = ['reservationId', 'index'];
		var data = dclone(params, unWantedKeysToRemove);
		
		var url = '/api/reservations/' + reservationId + '/smartbands';
		//var url = '/ui/show?format=json&json_input=keys/save_smartbands.json';

		
		rvBaseWebSrvV2.postJSON(url, params).then(function(data) {
			deferred.resolve(data);
		},function(data){
			deferred.reject(data);
		});
		return deferred.promise;
	};

	this.fetchActiveEncoders = function(){
		
		var deferred = $q.defer();
		var url =  "/api/key_encoders/active";			
		rvBaseWebSrvV2.getJSON(url).then(function(data) {
			console.log(data);
			deferred.resolve(data);
		},function(data){
			deferred.reject(data);
		});
		return deferred.promise;		
		
	};

}]);