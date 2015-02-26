admin.service('ADChargeCodesSrv',['$http', '$q', 'ADBaseWebSrv', function($http, $q, ADBaseWebSrv){
	
	/**
    *   A getter method to return the charge codes list
    */
	this.fetch = function(params){
		var deferred = $q.defer();
		var url = '/admin/charge_codes/list.json';
		console.log("here");
		console.log(params);
		ADBaseWebSrv.getJSON(url, params).then(function(data) {
		    deferred.resolve(data);
		},function(data){
		    deferred.reject(data);
		});	
		return deferred.promise;
	};
	/**
    *   A delete method to delete the charge code item.
    */
	this.deleteItem = function(data){
		var deferred = $q.defer();
		var url = '/admin/charge_codes/'+data.value+'/delete';
		
		ADBaseWebSrv.getJSON(url,data).then(function(data) {
		    deferred.resolve(data);
		},function(data){
		    deferred.reject(data);
		});	
		return deferred.promise;
	};
	/**
    *   A getter method to return add new the charge codes data.
    */
	this.fetchAddData = function(){
		var deferred = $q.defer();
		var url = '/admin/charge_codes/new';
		
		ADBaseWebSrv.getJSON(url).then(function(data) {
		    deferred.resolve(data);
		},function(data){
		    deferred.reject(data);
		});	
		return deferred.promise;
	};
	/**
    *   A getter method to return add new the charge codes data.
    */
	this.fetchEditData = function(data){
		var deferred = $q.defer();
		var url = '/admin/charge_codes/'+data.editId+'/edit.json';
		
		ADBaseWebSrv.getJSON(url).then(function(data) {
		    deferred.resolve(data);
		},function(data){
		    deferred.reject(data);
		});	
		return deferred.promise;
	};
	/**
    *   A post method to add/edit the charge codes data.
    */
	this.save = function(data){
		var deferred = $q.defer();
		var url = '/admin/charge_codes/save';
		
		ADBaseWebSrv.postJSON(url,data).then(function(data) {
		    deferred.resolve(data);
		},function(data){
		    deferred.reject(data);
		});	
		return deferred.promise;
	};
	/**
    *   A post method to import charge codes data.
    */
	this.importData = function(data){
		var deferred = $q.defer();
		var url = '/admin/charge_codes/import';
		
		ADBaseWebSrv.getJSON(url).then(function(data) {
		    deferred.resolve(data);
		},function(data){
		    deferred.reject(data);
		});	
		return deferred.promise;
	};
	
	
	

}]);