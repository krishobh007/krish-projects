angular.module('adminModuleTwo', []).config(function($stateProvider, $urlRouterProvider, $translateProvider){
     //define module-specific routes here
        $stateProvider.state('admin.departments', {
			templateUrl: '/assets/partials/departments/adDepartmentsList.html',
			controller: 'ADDepartmentListCtrl',
			url : '/departments'
		});

		$stateProvider.state('admin.rates', {
			templateUrl: '/assets/partials/rates/adRatesList.html',
			controller: 'ADRatesListCtrl',
			url : '/rates'
		});

		$stateProvider.state('admin.ratetypes', {
			templateUrl: '/assets/partials/rateTypes/adRateTypeList.html',
			controller: 'ADRateTypeCtrl',
			url : '/ratetypes'
		});

		$stateProvider.state('admin.upselllatecheckout', {
			templateUrl: '/assets/partials/upsellLatecheckout/upsellLatecheckout.html',
			controller: 'ADUpsellLateCheckoutCtrl',
			url : '/upselllatecheckout'
		});
		

		$stateProvider.state('admin.hotelLoyaltyProgram', {
			templateUrl: '/assets/partials/hotelLoyalty/hotelLoyaltyList.html',
			controller: 'ADHotelLoyaltyCtrl',
			url : '/hotelloyalty'
		});
		$stateProvider.state('admin.roomupsell', {
			templateUrl: '/assets/partials/roomUpsell/roomUpsell.html',
			controller: 'ADRoomUpsellCtrl',
			url : '/roomupsell'
		});
		
		$stateProvider.state('admin.roomtypes', {
			templateUrl: '/assets/partials/roomTypes/adRoomTypesList.html',
			controller: 'ADRoomTypesCtrl',
			url : '/roomtypes'
		});

		$stateProvider.state('admin.floorsetups', {
			templateUrl: '/assets/partials/floorSetups/adFloorSetupList.html',
			controller: 'ADFloorSetupCtrl',
			url : '/floorsetups'
		});

		$stateProvider.state('admin.billingGroups', {
			templateUrl: '/assets/partials/billingGroups/adBillingGroupList.html',
			controller: 'ADBillingGroupCtrl',
			url : '/billingGroups'
		});
		$stateProvider.state('admin.accountsReceivables', {
			templateUrl: '/assets/partials/accountReceivables/adAccountReceivables.html',
			controller: 'ADAccountReceivablesCtrl',
			url : '/accountReceivables'
		});

		$stateProvider.state('admin.reservationTypes', {
			templateUrl: '/assets/partials/reservationTypes/adReservationTypeList.html',
			controller: 'ADReservationTypeListController',
			url : '/reservationtypes'
		});

		$stateProvider.state('admin.housekeeping', {
			templateUrl: '/assets/partials/housekeeping/adHousekeeping.html',
			controller: 'adHousekeepingCtrl',
			url : '/housekeeping'
		});

		$stateProvider.state('admin.roomKeyDelivery', {
			templateUrl: '/assets/partials/roomKeyDelivery/roomKeyDelivery.html',
			controller: 'ADRoomKeyDeliveryCtrl',
			url : '/roomKeyDelivery'
		});

		$stateProvider.state('admin.rooms', {
			templateUrl: '/assets/partials/rooms/adRoomList.html',
			controller: 'adRoomListCtrl',
			url : '/rooms'
		});	
			
		$stateProvider.state('admin.roomdetails', {
			templateUrl: '/assets/partials/rooms/adRoomDetails.html',
			controller: 'adRoomDetailsCtrl',
			url : '/roomdetails/:roomId'
		});

		$stateProvider.state('admin.hotellikes', {
			templateUrl: '/assets/partials/Likes/adHotelLikes.html',
			controller: 'ADHotelLikesCtrl',
			url : '/likes'

		});

		$stateProvider.state('admin.items', {
			templateUrl: '/assets/partials/items/adItemList.html',
			controller: 'ADItemListCtrl',
			url : '/items'
		});	

		$stateProvider.state('admin.itemdetails', {
			templateUrl: '/assets/partials/items/adItemDetails.html',
			controller: 'ADItemDetailsCtrl',
			url : '/itemdetails/:itemid'
		});				

		
		$stateProvider.state('admin.chargeGroups', {
			templateUrl: '/assets/partials/chargeGroups/adChargeGroups.html',
			controller: 'ADChargeGroupsCtrl',
			url : '/chargeGroups'
		});
		
		$stateProvider.state('admin.paymentMethods', {
			templateUrl: '/assets/partials/paymentMethods/adPaymentMethods.html',
			controller: 'ADPaymentMethodsCtrl',
			url : '/paymentMethods'
		});

		$stateProvider.state('admin.chargeCodes', {
			templateUrl: '/assets/partials/chargeCodes/adChargeCodes.html',
			controller: 'ADChargeCodesCtrl',
			url : '/chargeCodes'
		});
		
		$stateProvider.state('admin.externalPmsConnectivity', {
			templateUrl: '/assets/partials/externalPms/adExternalPmsConnectivity.html',
			controller: 'ADExternalPmsConnectivityCtrl',
			url : '/externalPmsConnectivity'
		});

		$stateProvider.state('admin.addRate', {
			templateUrl: '/assets/partials/rates/adNewRate.html',
		    controller: 'ADAddnewRate',
			url : '/addNewRate',
			resolve: {
				rateInitialData: function(ADRatesAddDetailsSrv) {
					return ADRatesAddDetailsSrv.fetchRateTypes();
				},
				rateDetails: function(){
					return {};
				}
			}
		});

		$stateProvider.state('admin.rateDetails', {
			templateUrl: '/assets/partials/rates/adNewRate.html',
			controller: 'ADAddnewRate',
			url : '/ratedetails/:rateId',
			resolve: {
				rateInitialData: function(ADRatesAddDetailsSrv) {
					return ADRatesAddDetailsSrv.fetchRateTypes();
				},
				rateDetails: function(ADRatesSrv, $stateParams) {
                 	var params = {
			 		  	rateId: $stateParams.rateId
		 		  	}; 
                    return ADRatesSrv.fetchDetails(params);
                }
			}
		});

		$stateProvider.state('admin.rulesRestrictions', {
			templateUrl: '/assets/partials/rulesRestriction/adRulesRestriction.html',
			controller: 'ADRulesRestrictionCtrl',
			url : '/restriction_types'
		});


		$stateProvider.state('admin.hotelannouncementsettings', {
			templateUrl: '/assets/partials/hotelAnnouncementSettings/adHotelAnnounceSettings.html',
			controller: 'ADHotelAnnouncementSettingsCtrl',
			url : '/hotelannouncementsettings'
		});	

		$stateProvider.state('admin.sociallobbysettings', {
			templateUrl: '/assets/partials/hotelSocialLobbySettings/adHotelSocialLobbySettings.html',
			controller: 'ADSocialLobbySettingsCtrl',
			url : '/sociallobbysettings'
		});			

		$stateProvider.state('admin.guestreviewsetup', {
			templateUrl: '/assets/partials/reviews_setups/adGuestReviewSetup.html',
			controller: 'ADGuestReviewSetupCtrl',
			url : '/guestreviewsetup'
		});	

		$stateProvider.state('admin.checkin', {
			templateUrl: '/assets/partials/checkin/adCheckin.html',
			controller: 'ADCheckinCtrl',
			url : '/checkin',
			resolve: {
				rateCodeData: function(adCheckinSrv) {
					return adCheckinSrv.getRateCodes();
				},
				blockCodeData : function(adCheckinSrv){
					return adCheckinSrv.getBlockCodes();
				}
			}
		});

		$stateProvider.state('admin.checkout', {
			templateUrl: '/assets/partials/checkout/adCheckout.html',
			controller: 'ADCheckoutCtrl',
			url : '/checkout'
		});

		$stateProvider.state('admin.cmscomponentSettings', {
			templateUrl: '/assets/partials/contentManagement/adContentManagement.html',
			controller: 'ADContentManagementCtrl',
			url : '/contentManagement'
		});

		$stateProvider.state('admin.contentManagementSectionDetails', {
			templateUrl: '/assets/partials/contentManagement/adContentManagementSectionDetail.html',
			controller: 'ADContentManagementSectionDetailCtrl',
			url : '/contentManagement/section/:id'
		});

		$stateProvider.state('admin.contentManagementCategoryDetails', {
			templateUrl: '/assets/partials/contentManagement/adContentManagementCategoryDetail.html',
			controller: 'ADContentManagementCategoryDetailCtrl',
			url : '/contentManagement/category/:id'
		});
		$stateProvider.state('admin.contentManagementItemDetails', {
			templateUrl: '/assets/partials/contentManagement/adContentManagementItemDetail.html',
			controller: 'ADContentManagementItemDetailCtrl',
			url : '/contentManagement/item/:id'
		});


		$stateProvider.state('admin.checkinEmail', {
			templateUrl: '/assets/partials/emailList/adCheckinCheckoutemail.html',
			controller: 'ADCheckinEmailCtrl',
			url : '/checkinEmail'
		});
        $stateProvider.state('admin.maintenanceReasons', {
			templateUrl: '/assets/partials/maintenanceReasons/adMaintenanceReasons.html',
			controller: 'ADMaintenanceReasonsCtrl',
			url : '/maintenanceReasons'
		});

		$stateProvider.state('admin.markets', {
			templateUrl: '/assets/partials/markets/adMarkets.html',
			controller: 'ADMarketsCtrl',
			url : '/markets'
		});

		$stateProvider.state('admin.sources', {
			templateUrl: '/assets/partials/sources/adSources.html',
			controller: 'ADSourcesCtrl',
			url : '/sources'
		});

		$stateProvider.state('admin.bookingOrigins', {
			templateUrl: '/assets/partials/origins/adOrigins.html',
			controller: 'ADOriginsCtrl',
			url : '/origins'
		});

		$stateProvider.state('admin.ratesAddons', {
			templateUrl: '/assets/partials/rates/adRatesAddons.html',
			controller: 'ADRatesAddonsCtrl',
			url : '/rates_addons'
		});

		$stateProvider.state('admin.userRoles', {
			templateUrl: '/assets/partials/UserRoles/adUserRoles.html',
			controller: 'ADUserRolesCtrl',
			url : '/UserRoles',
			resolve: {
				userRolesData: function(ADUserRolesSrv) {
					return ADUserRolesSrv.fetchUserRoles();
				}
			}
		});


		$stateProvider.state('admin.reservationSettings', {
			templateUrl: '/assets/partials/reservations/adReservationSettings.html',
			controller: 'ADReservationSettingsCtrl',
			url : '/reservationSettings',
			resolve: {
				reservationSettingsData: function(ADReservationSettingsSrv) {
					return ADReservationSettingsSrv.fetchReservationSettingsData();
				}
			}
		});


		$stateProvider.state('admin.ibeaconSettings', {
			templateUrl: '/assets/partials/iBeaconSettings/adibeaconSettings.html',
			controller: 'ADiBeaconSettingsCtrl',
			url : '/ibeaconSettings'
		});

		$stateProvider.state('admin.earlyCheckin', {
			templateUrl: '/assets/partials/earlyCheckin/adEarlyCheckin.html',
			controller: 'ADEarlyCheckinCtrl',
			url : '/earlyCheckin'
		});

		$stateProvider.state('admin.iBeaconDetails', {
			templateUrl: '/assets/partials/iBeaconSettings/adiBeaconDetails.html',
			controller: 'ADiBeaconDetailsCtrl',
			url : '/iBeaconDetails/:action',
			resolve: {
				beaconNeighbours: function(adiBeaconSettingsSrv){
					return adiBeaconSettingsSrv.fetchBeaconList();
				},
				triggerTypes: function(adiBeaconSettingsSrv) {
					return adiBeaconSettingsSrv.fetchBeaconTriggerTypes();
				},
				beaconTypes: function(adiBeaconSettingsSrv) {
					return adiBeaconSettingsSrv.fetchBeaconTypes();
				},
				beaconDetails: function(adiBeaconSettingsSrv, $stateParams) {
                 	var params = {
			 		  	"id":$stateParams.action
		 		  	}; 
                    return adiBeaconSettingsSrv.fetchBeaconDetails(params);
                },
                defaultBeaconDetails: function() {
                    return {};
                }
			}
		});

		$stateProvider.state('admin.iBeaconNewDetails', {
			templateUrl: '/assets/partials/iBeaconSettings/adiBeaconDetails.html',
			controller: 'ADiBeaconDetailsCtrl',
			url : '/iBeaconDetails/:action',
			resolve: {
				beaconNeighbours: function(adiBeaconSettingsSrv){
					return adiBeaconSettingsSrv.fetchBeaconList();
				},
				triggerTypes: function(adiBeaconSettingsSrv) {
					return adiBeaconSettingsSrv.fetchBeaconTriggerTypes();
				},
				beaconTypes: function(adiBeaconSettingsSrv) {
					return adiBeaconSettingsSrv.fetchBeaconTypes();
				},
				beaconDetails: function() {
                    return {};
                },
                defaultBeaconDetails: function(adiBeaconSettingsSrv) {
                    return adiBeaconSettingsSrv.fetchBeaconDeafultDetails();
          	   }
			}
		});

		$stateProvider.state('admin.settingsAndParams', {
			templateUrl: '/assets/partials/settingsAndParams/adSettingsAndParams.html',
			controller: 'settingsAndParamsCtrl',
			url : '/settingsAndParams',
			resolve: {
				settingsAndParamsData: function(settingsAndParamsSrv) {
					return settingsAndParamsSrv.fetchsettingsAndParams();
				},
				chargeCodes: function(settingsAndParamsSrv){
					return settingsAndParamsSrv.fetchChargeCodes();
				}
			}
		});
		
        $stateProvider.state('admin.dailyWorkAssignment', {
        	templateUrl: '/assets/partials/housekeeping/adDailyWorkAssignment.html',
        	controller: 'ADDailyWorkAssignmentCtrl',
        	url: '/daily_work_assignment'
        });
		$stateProvider.state('admin.checkoutEmail', {
			templateUrl: '/assets/partials/emailList/adCheckinCheckoutemail.html',
			controller: 'ADCheckoutEmailCtrl',
			url : '/checkoutEmail'
		});
		
		$stateProvider.state('admin.deviceMapping', {
			templateUrl: '/assets/partials/deviceMapping/adDeviceMappingList.html',
			controller: 'ADDeviceMappingsCtrl',
			url : '/deviceMappingsList'
		});

		$stateProvider.state('admin.stationary', {
			templateUrl: '/assets/partials/stationary/adStationary.html',
			controller: 'ADStationaryCtrl',
			url : '/stationary'
		});

		$stateProvider.state('admin.analyticsSetup', {
			templateUrl: '/assets/partials/AnalyticSetup/adAnalyticSetup.html',
			controller: 'adAnalyticSetupCtrl',
			url : '/analyticSetup'
		});

		$stateProvider.state('admin.emailBlacklist', {
			templateUrl: '/assets/partials/EmailBlackList/adEmailBlackList.html',
			controller: 'ADEmailBlackListCtrl',
			url : '/emailBlacklist'
		});
});