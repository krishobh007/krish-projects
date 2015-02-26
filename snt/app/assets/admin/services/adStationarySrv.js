admin.service('ADStationarySrv',['$http', '$q', 'ADBaseWebSrvV2', function($http, $q, ADBaseWebSrvV2){

	/**
    * To fetch the details of stationary details.
    * @return {object} details of stationary details json
    */
	this.fetch = function(){
		var deferred = $q.defer();
		var url = '/api/stationary';

		ADBaseWebSrvV2.getJSON(url).then(function(data) {
		    deferred.resolve(data);
		},function(data){
		    deferred.reject(data);
		});	
		return deferred.promise;
	};
   	/*
    * To save stationary details
    * @return {object} status
    */
	this.saveStationary = function(data){
		var deferred = $q.defer();
		var url = '/api/stationary/save';	

		ADBaseWebSrvV2.postJSON(url, data).then(function(data) {
		    deferred.resolve(data);
		},function(data){
		    deferred.reject(data);
		});	
		return deferred.promise;
	};

}]);