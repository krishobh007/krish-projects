sntRover.service('RVReservationSummarySrv', ['$q', 'rvBaseWebSrvV2',
    function($q, rvBaseWebSrvV2) {
        var that = this;

        this.reservationData = {};
        this.reservationData.demographics = {};
        this.fetchPaymentMethods = function() {
            var deferred = $q.defer();
            var url = '/api/hotel_settings/payment_types';
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };


        this.fetchDemographicMarketSegments = function(deferred) {
            var url = '/api/market_segments?is_active=true';
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                that.reservationData.demographics.is_use_markets = data.is_use_markets;
                that.reservationData.demographics.markets = data.markets;
            }, function(errorMessage) {
                deferred.reject(errorMessage);
            });
        };

        this.fetchDemographicSources = function(deferred) {
            var url = '/api/sources?is_active=true'; //TODO: Whether we need active list only or all
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                that.reservationData.demographics.is_use_sources = data.is_use_sources;
                that.reservationData.demographics.sources = data.sources;
            }, function(errorMessage) {
                deferred.reject(errorMessage);
            });
        };

        this.fetchDemographicOrigins = function(deferred) {
            var url = '/api/booking_origins';
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                that.reservationData.demographics.origins = data.booking_origins;
                that.reservationData.demographics.origins = [];
                //We need only the booking origins activated in the admin
                that.reservationData.demographics.is_use_origins = data.is_use_origins;
                for (var i in data.booking_origins) {
                    if (data.booking_origins[i].is_active) {
                        that.reservationData.demographics.origins.push(data.booking_origins[i]);
                    }
                }

            }, function(errorMessage) {
                deferred.reject(errorMessage);
            });
        };

        this.fetchDemographicReservationTypes = function(deferred) {
            var url = '/api/reservation_types.json?is_active=true';
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                that.reservationData.demographics.reservationTypes = [];
                //We need only the active reservation types
                for (var i in data.reservation_types) {
                    if (data.reservation_types[i].is_active) {
                        that.reservationData.demographics.reservationTypes.push(data.reservation_types[i]);
                    }
                }
                deferred.resolve(that.reservationData);
            }, function(errorMessage) {
                deferred.reject(errorMessage);
            });

        };

        this.fetchInitialData = function() {
            //Please be care. Only last function should resolve the data
            var deferred = $q.defer();
            that.fetchDemographicMarketSegments(deferred);
            that.fetchDemographicOrigins(deferred);
            that.fetchDemographicSources(deferred);
            that.fetchDemographicReservationTypes(deferred);
            return deferred.promise;
        };

        /**
         * Call API to Save the reservation
         */
        this.saveReservation = function(data) {
            var deferred = $q.defer();
            var url = '/api/reservations';
            rvBaseWebSrvV2.postJSON(url, data).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        /**
         * Sends the confirmation email
         */
        this.sendConfirmationEmail = function(data) {
            var deferred = $q.defer();
            var url = '/api/reservations/' + data.reservationId + '/email_confirmation';
            delete data['reservationId'];

            rvBaseWebSrvV2.postJSON(url, data).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        /**
         * Sends the confirmation email
         */
        this.sendHourlyConfirmationEmail = function(data) {
            var deferred = $q.defer();
            // /api/reservations/hourly_confirmation_emails?reservation_ids[]=1311017&reservation_ids[]=1311016&reservation_ids[]=1311018]&emails[]=shiju@stayntouch.com
            var url = '/api/reservations/hourly_confirmation_emails?';
            _.each(data.reservation_ids, function(id) {
                url += 'reservation_ids[]=' + id + '&';
            })
            _.each(data.emails, function(mail) {
                url += 'emails[]=' + mail + '&';
            })

            delete data['reservation_ids'];
            delete data['emails'];

            rvBaseWebSrvV2.postJSON(url, data).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        /**
         * Call API to Update the reservation
         */
        this.updateReservation = function(data) {
            var deferred = $q.defer();
            var url = '/api/reservations/' + data.reservationId;
            rvBaseWebSrvV2.putJSON(url, data).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        /**
         * Call API to do the payment - SIX payment
         */
        this.paymentAction = function(data) {
            var deferred = $q.defer();
            var url = '/api/ipage/store_payments';
            rvBaseWebSrvV2.postJSON(url, data).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.startPayment = function(data) {
            var deferred = $q.defer();
            var url = '/api/cc/get_token';
            rvBaseWebSrvV2.postJSON(url, data).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };
        this.fetchRooms = function() {
            var deferred = $q.defer();
            var url = '/api/rooms';
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.getRateName = function(params) {
            var deferred = $q.defer();
            var url = '/api/rates/' + params.id;
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                deferred.resolve(data.name);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.getRateDetails = function(params) {
            var deferred = $q.defer();
            var url = '/api/rates/' + params.id;
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.getTaxDetails = function(rates) {
            var deferred = $q.defer();
            var url = '/api/rates/tax_information/';
            rvBaseWebSrvV2.getJSON(url, rates).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.fetchDefaultRoutingInfo = function(params){
            var deferred = $q.defer();            
            var url = '/api/default_account_routings/routings_count/';
            rvBaseWebSrvV2.postJSON(url, params).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.applyDefaultRoutingToReservation = function(params){
            var deferred = $q.defer();
            var url = '/api/default_account_routings/attach_reservation';
            rvBaseWebSrvV2.postJSON(url, params).then(function(data) {
                deferred.resolve(data);
            },function(data){
                deferred.reject(data);
            }); 

            return deferred.promise;
        };
    }
]);