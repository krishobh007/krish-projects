sntRover.service('RVBillinginfoSrv',['$http', '$q', 'BaseWebSrvV2','RVBaseWebSrv', function($http, $q, BaseWebSrvV2, RVBaseWebSrv){
   
	this.fetchRoutes = function(reservationId){
		var deferred = $q.defer();
		var url = 'api/bill_routings/' + reservationId + '/attached_entities' ;
			BaseWebSrvV2.getJSON(url).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};	

	this.fetchAttachedCards = function(reservationId){
		var deferred = $q.defer();
		var url = 'api/bill_routings/' + reservationId + '/attached_cards' ;
			BaseWebSrvV2.getJSON(url).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};

	this.fetchAvailableBillingGroups = function(data){
		var deferred = $q.defer();
		//var url = 'api/bill_routings/billing_groups?id=12847';
		var url = 'api/bill_routings/billing_groups?id='+ data.id+'&to_bill='+data.to_bill + '&is_new=' + data.is_new;
			BaseWebSrvV2.getJSON(url).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};

	this.fetchAvailableChargeCodes = function(data){
		var deferred = $q.defer();
		//var url = 'api/bill_routings/charge_codes?id=12847';
		var url = 'api/bill_routings/charge_codes?id='+ data.id+'&to_bill='+data.to_bill + '&is_new=' + data.is_new;
			BaseWebSrvV2.getJSON(url).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};

	this.fetchAllBillingGroups = function(){
		var deferred = $q.defer();
		var url = '/api/bill_routings/billing_groups?is_default_routing=true'
			BaseWebSrvV2.getJSON(url).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;

	};  

	this.fetchAllChargeCodes = function(){
		var deferred = $q.defer();
		var url = '/api/bill_routings/charge_codes?is_default_routing=true'
			BaseWebSrvV2.getJSON(url).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;

	};

	this.fetchBillsForReservation = function(reservationId){
		var deferred = $q.defer();
		var url = 'api/bill_routings/' + reservationId + '/bills.json';
			BaseWebSrvV2.getJSON(url).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};

	this.saveRoute = function(data){
		var deferred = $q.defer();
		var url = 'api/bill_routings/save_routing';
			BaseWebSrvV2.postJSON(url, data).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};

	this.saveDefaultAccountRouting = function(data){
		var deferred = $q.defer();
		var url = 'api/default_account_routings/save';
			BaseWebSrvV2.postJSON(url, data).then(function(data) {
		   	 	deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};

	this.deleteRoute = function(data){
		var deferred = $q.defer();
		var url = 'api//bill_routings/delete_routing';
			BaseWebSrvV2.postJSON(url, data).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};

	this.fetchDefaultAccountRouting = function(params){
		var deferred = $q.defer();
		var url = '/api/default_account_routings/' + params.id;
			BaseWebSrvV2.getJSON(url).then(function(data) {
				
			   	 deferred.resolve(data);
			},function(data){
			    deferred.reject(data);
			});	

		return deferred.promise;
	};

   
}]);