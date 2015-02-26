admin.service('ADRatesSrv', ['$http', '$q', 'ADBaseWebSrvV2', 'ADBaseWebSrv',
    function ($http, $q, ADBaseWebSrvV2, ADBaseWebSrv) {

        /*
         * Service function to toggle activate/de-activate rate
         * @params {object} id
         */
        this.toggleRateActivate = function (params) {

            var deferred = $q.defer();
            var url = "/api/rates/enable_disable";

            ADBaseWebSrvV2.putJSON(url,params).then(function (data) {
                deferred.resolve(data);
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };
        /*
         * Service function to delete rate
         * @params {object} id
         */
        this.deleteRate = function (id) {

            var deferred = $q.defer();
            var url = "/api/rates/" + id;

            ADBaseWebSrvV2.deleteJSON(url).then(function (data) {
                deferred.resolve(data);
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.fetchRates = function (data) {
            var deferred = $q.defer();

            var url = "/api/rates.json";
            ADBaseWebSrvV2.getJSON(url, data).then(function (data) {
                deferred.resolve(data);
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.fetchRateTypes = function () {
            var deferred = $q.defer();

            //var url = " /sample_json/ng_admin/rate_types.json";
            var url = "/api/rate_types.json";
            ADBaseWebSrvV2.getJSON(url).then(function (data) {
                var results = [];
                for(var i = 0; i < data.results.length; i++){
                    if(data.results[i].activated){
                        results.push(data.results[i]);
                    }
                }
                deferred.resolve(results);
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.importRates = function () {
            var deferred = $q.defer();
            var url = "/api/rates/import";
            ADBaseWebSrvV2.postJSON(url).then(function (data) {
                deferred.resolve(data.results);
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.fetchDateRanges = function (params) {
            var deferred = $q.defer();

            var url = "/api/rates/" + params.rate_id + "/rate_date_ranges";
            ADBaseWebSrvV2.getJSON(url).then(function (data) {
                deferred.resolve(data);
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.getRateDetailsForNonstandalone = function (params) {
            var deferred = $q.defer();

            var url = "/admin/rates/"+ params.id +"/edit.json";

            ADBaseWebSrv.getJSON(url).then(function (data) {
                deferred.resolve(data);
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.updateRateForNonStandalone = function(data){
            var deferred = $q.defer();

            var url = "/admin/rates/" + data.id;
            delete data['id'];
            ADBaseWebSrv.putJSON(url, data).then(function (data) {
                deferred.resolve(data);
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;

        };

        var that = this;
        this.rateDetails = {};

        // get rate details
        this.fetchDetails = function (params) {
            var deferred = $q.defer();
             /*
             * Service function to fetch add ons
             * @return {object} add ons
             */
            that.fetchAddons = function () {
                var params = {"is_active":true, "is_not_reservation_only":true};
                var url = "/api/addons";
                ADBaseWebSrvV2.getJSON(url, params).then(function (data) {
                    that.rateDetails.allAddOns = data.results;
                    deferred.resolve(that.rateDetails);
                }, function (data) {
                    deferred.reject(data);
                });
            };

            // fetch hotel business date
            that.fetchHotelInfo = function () {
                var url = "/api/rover_header_info";
                ADBaseWebSrvV2.getJSON(url).then(function (data) {
                    data = data.data;
                    that.rateDetails.business_date = data.business_date;
                    that.fetchAddons();
                }, function (data) {
                    deferred.reject(data);
                });

            }

            var url = "/api/rates/" + params.rateId;
            ADBaseWebSrvV2.getJSON(url).then(function (data) {
                that.rateDetails = data;
                that.fetchHotelInfo();
            }, function (data) {
                deferred.reject(data);
            });
            return deferred.promise;
        }

    }
]);
