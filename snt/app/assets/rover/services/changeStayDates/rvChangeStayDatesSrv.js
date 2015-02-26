sntRover.service('RVChangeStayDatesSrv', ['$q', 'rvBaseWebSrvV2', 'RVBaseWebSrv',
    function ($q, rvBaseWebSrvV2, RVBaseWebSrv) {

    	var that = this;
        this.changeStayDetails = {};


        //function to fetch staydate details against a reservation id
        this.fetchStayBasicDetails = function (reservationId, deferred){
            var url = '/staff/change_stay_dates/' + reservationId + '.json';
            RVBaseWebSrv.getJSON(url).then(function(data) {
                that.changeStayDetails.details = data;
            }, function(errorMessage){
                deferred.reject(errorMessage);
            });
        }; 

    	//function to fetch calender details against a reservation id
    	this.fetchCalenderDetails = function (reservationId, deferred){
            var url = '/staff/change_stay_dates/' + reservationId + '/calendar.json';
            //var url = '/ui/show?format=json&json_input=change_staydates/rooms_available.json';

            RVBaseWebSrv.getJSON(url).then(function(data) {
                that.changeStayDetails.calendarDetails = data;
                deferred.resolve(that.changeStayDetails);
            }, function(errorMessage){
                deferred.reject(errorMessage);
            });
        }; 


        this.fetchInitialData = function (reservationId){
            //Please be care. Only last function should resolve the data
            var deferred = $q.defer ();
            that.fetchStayBasicDetails (reservationId, deferred);
            that.fetchCalenderDetails (reservationId, deferred);
            return deferred.promise;
        };

        this.checkUpdateAvaibale = function (data){
            var url = '/staff/change_stay_dates/' + data.reservation_id + '/update.json';
            //var url = '/ui/show?format=json&json_input=change_staydates/reservation_updates.json';
            var data = {'arrival_date': data.arrival_date, 'dep_date': data.dep_date};            
            var deferred = $q.defer ();
            RVBaseWebSrv.getJSON(url, data).then(function(data) {  
                deferred.resolve(data);
            }, function(errorMessage){
                deferred.reject(errorMessage);
            });
            return deferred.promise;
        };


        this.confirmUpdates = function(data){
            var url = '/staff/change_stay_dates/' + data.reservation_id + '/confirm';  

            var postData = {"arrival_date": data.arrival_date, "dep_date": data.dep_date, "room_number": data.room_selected};      
            var deferred = $q.defer ();
            RVBaseWebSrv.postJSON(url, postData).then(function(data) {  
                deferred.resolve(data);
            }, function(errorMessage){
                deferred.reject(errorMessage);
            });
            return deferred.promise;

        }
}]);