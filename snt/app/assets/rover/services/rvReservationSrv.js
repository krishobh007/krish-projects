sntRover.service('RVReservationCardSrv', ['$http', '$q', 'RVBaseWebSrv', 'rvBaseWebSrvV2', '$rootScope',
	function($http, $q, RVBaseWebSrv, rvBaseWebSrvV2, $rootScope) {

		this.reservationData = {};
		var that = this;

		/**
		 * To fetch the list of users
		 * @return {object} users list json
		 */
		this.fetch = function(data) {

			var deferred = $q.defer();
			//Commented. Since we are using another API to get country list
			// var fetchCountryList = function(data) {
			// var url = 'api/countries.json';
			// RVBaseWebSrv.getJSON(url).then(function(data) {
			// that.reservationData.countries = data;
			// deferred.resolve(that.reservationData);
			// }, function(data) {
			// deferred.reject(data);
			// });
			// 
			// };
			var reservationId = data.reservationId;
			var isRefresh = data.isRefresh;
			var isReservationIdAlreadyCalled = false;
			angular.forEach(that.reservationIdsArray, function(value, key) {
				if (!isRefresh || isRefresh == null || isRefresh == '') {
					if (value === reservationId)
						isReservationIdAlreadyCalled = true;
				}
			});
			if (!isReservationIdAlreadyCalled) {
				that.storeReservationIds(reservationId);
				var url = 'api/reservations/' + reservationId + '.json';

				RVBaseWebSrv.getJSON(url).then(function(data) {
					that.reservationData[reservationId] = data;
					deferred.resolve(data);
				}, function(data) {
					deferred.reject(data);
				});
			} else {
				deferred.resolve(that.reservationData[reservationId]);
			}

			return deferred.promise;

		};

		this.reservationDetails = {};
		this.confirmationNumbersArray = [];

		this.reservationIdsArray = [];
		var that = this;

		this.emptyConfirmationNumbers = function() {
			that.confirmationNumbersArray = [];
			that.reservationDetails = {};
		};
		this.storeConfirmationNumbers = function(confirmationNumber) {
			that.confirmationNumbersArray.push(confirmationNumber);

		};

		this.storeReservationIds = function(reservationID) {
			that.reservationIdsArray.push(reservationID);

		};

		this.fetchReservationDetails = function(data) {
			var confirmationNumber = data.confirmationNumber;
			var isRefresh = data.isRefresh;
			var isConfirmationNumberAlreadyCalled = false;
			angular.forEach(that.confirmationNumbersArray, function(value, key) {
				if (!isRefresh || isRefresh == null) {
					if (value === confirmationNumber)
						isConfirmationNumberAlreadyCalled = true;
				}
			});

			var deferred = $q.defer();

			if (!isConfirmationNumberAlreadyCalled) {
				that.storeConfirmationNumbers(confirmationNumber);
				var url = '/staff/staycards/reservation_details.json?reservation=' + confirmationNumber;

				RVBaseWebSrv.getJSON(url).then(function(data) {
					that.reservationDetails[confirmationNumber] = data;
					deferred.resolve(data);
				}, function(data) {
					deferred.reject(data);
				});
			} else {
				deferred.resolve(that.reservationDetails[confirmationNumber]);
			}

			return deferred.promise;
		};


		this.updateResrvationForConfirmationNumber = function(confirmationNumber, reservationData) {
			that.reservationDetails[confirmationNumber] = reservationData;
		};
		this.getResrvationForConfirmationNumber = function(confirmationNumber) {
			return that.reservationDetails[confirmationNumber];
		};
		this.guestData = "";
		this.setGuestData = function(data) {
			this.guestData = data;
		};
		this.getGuestData = function() {
			return this.guestData;
		};

		this.fetchGuestcardData = function(param) {
			var deferred = $q.defer();
			var url = '/staff/guestcard/show.json';
			RVBaseWebSrv.getJSON(url, param).then(function(data) {
				deferred.resolve(data);
			}, function(data) {
				deferred.reject(data);
			});
			return deferred.promise;
		};

		this.fetchCancellationPolicies = function(param) {
			var deferred = $q.defer();
			var url = '/api/reservations/' + param.id + '/policies';
			rvBaseWebSrvV2.getJSON(url, param).then(function(data) {
				deferred.resolve(data);
			}, function(data) {
				deferred.reject(data);
			});
			return deferred.promise;
		};

		this.cancelReservation = function(param) {
			var deferred = $q.defer();
			var url = '/api/reservations/' + param.id + '/cancel';
			rvBaseWebSrvV2.postJSON(url, param).then(function(data) {
				deferred.resolve(data);
			}, function(data) {
				deferred.reject(data);
			});
			return deferred.promise;
		};

		this.tokenize = function(data) {
			var deferred = $q.defer();
			var url = '/staff/payments/tokenize';

			RVBaseWebSrv.postJSON(url, data).then(function(data) {
				deferred.resolve(data);
			}, function(data) {
				deferred.reject(data);
			});
			return deferred.promise;
		};

		this.saveReservationNote = function(data) {
			var deferred = $q.defer();
			var url = '/reservation_notes';
			RVBaseWebSrv.postJSON(url, data).then(function(data) {
				deferred.resolve(data);
			}, function(data) {
				deferred.reject(data);
			});
			return deferred.promise;
		};
		this.deleteReservationNote = function(reservationID) {
			var deferred = $q.defer();
			var url = '/reservation_notes/' + reservationID;
			RVBaseWebSrv.deleteJSON(url, "").then(function(data) {
				deferred.resolve(data);
			}, function(data) {
				deferred.reject(data);
			});
			return deferred.promise;
		};

		this.getGuestDetails = function(guestData) {
			var deferred = $q.defer();
			var url = '/api/guest_details/' + guestData.id;
			rvBaseWebSrvV2.getJSON(url).then(function(data) {
				deferred.resolve(data);
			}, function(data) {
				deferred.reject(data);
			});
			return deferred.promise;
		};
		this.modifyRoomQueueStatus = function(data) {
			var deferred = $q.defer();
			var postData = {
				"status": data.status
			};

			var url = '/api/reservations/' + data.reservationId + '/queue';
			rvBaseWebSrvV2.postJSON(url, postData).then(function(postData) {
				deferred.resolve(data);
			}, function(data) {
				deferred.reject(data);
			});
			return deferred.promise;
		};
		 this.fetchDepositDetails = function(id) {
            var deferred = $q.defer();
            var url = 'api/reservations/'+id+'/deposit_policy';
           //var url = '/sample_json/reservations/res_deposit.json';
            rvBaseWebSrvV2.getJSON(url).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };
        
        this.sendConfirmationEmail = function(data){
        	var deferred = $q.defer();
            var url = '/api/reservations/'+data.reservationId+'/email_confirmation';
           //var url = '/sample_json/reservations/res_deposit.json';
            rvBaseWebSrvV2.postJSON(url, data.postData).then(function(data) {
                deferred.resolve(data);
            }, function(data) {
                deferred.reject(data);
            });
            return deferred.promise;
        };

        this.sendConfirmationEmail = function(data){
			var deferred = $q.defer();
			var url = '/api/reservations/'+data.reservationId+'/email_confirmation';
			//var url = '/sample_json/reservations/res_deposit.json';
			rvBaseWebSrvV2.postJSON(url, data.postData).then(function(data) {
			deferred.resolve(data);
			}, function(data) {
			deferred.reject(data);
			});
			return deferred.promise;
		};

	}
]);