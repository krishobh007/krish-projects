sntRover.controller('staycardController', ['$scope', 'RVGuestCardSrv', 'ngDialog', '$timeout',
	function($scope, RVGuestCardSrv, ngDialog, $timeout) {

		// Browser chokes when he tries to do the following two thing at the same time:
		// 		1. Slide in staycard
		// 		2. Update the UI with all the fetched data
		// So we have the following throtel to easy the pain by display:none; staycard while browser updates the UI
		// Show after a delay which is slightly greater that @uiViewDuration + @uiViewDelay (/assets/stylesheets/less/common/01-D_mixins-animations.less)
		var delay = 700;
		$scope.staycardReady = false;
		$timeout(function() { $scope.staycardReady = true; }, delay);

		$scope.depositPopupData = {};
		$scope.depositPopupData.hasShown = false;


		// $scope.guestCardData = {};
		// $scope.guestCardData.contactInfo = {};
		$scope.countriesListForGuest = [];
		// $scope.guestCardData.userId = '';
		// $scope.guestCardData.contactInfo.birthday = '';
		$scope.paymentData = {};
		/*
		 * To get the payment tab payments list
		 */
		$scope.$on('GUESTPAYMENT', function(event, paymentData) {
			
			if(paymentData.user_id){
				$scope.paymentData = paymentData;
			}
		});


		$scope.$on('guestCardUpdateData', function(event, data) {

			$scope.guestCardData.contactInfo.avatar = data.avatar;
			$scope.guestCardData.contactInfo.vip = data.vip;
			
			$scope.countriesListForGuest = data.countries;
			
			$scope.guestCardData.userId = data.userId;
			$scope.guestCardData.guestId = data.guestId;
		});

		$scope.$on('staycardGuestData', function(event, data) {
			$scope.guestCardData.contactInfo.first_name = data.guest_details.first_name;
			$scope.guestCardData.contactInfo.last_name = data.guest_details.last_name;
			$scope.guestCardData.contactInfo.avatar = data.guest_details.avatar;
		});

		$scope.$on('reservationCardClicked', function() {
			$scope.$broadcast('reservationCardisClicked');
		});

		$scope.$on('CHANGEAVATAR', function(event, data) {

			var imageName = $scope.guestCardData.contactInfo.avatar.split('/')[$scope.guestCardData.contactInfo.avatar.split('/').length - 1];

			for (var key in avatharImgs) {
				if ((avatharImgs[key]) == imageName) {
					$scope.guestCardData.contactInfo.avatar = data;
				}
			}
		});

		//setting the heading of the screen to "Search"		
		$scope.menuImage = "back-arrow";

		$scope.$on('HeaderChanged', function(event, data) {
			/**
			 * CICO-9081
			 * $scope.heading = value was creating a heading var in local scope! Hence the title was not being set for the page.
			 * Changing code to refer the parent's heading variable to override this behaviour.
			 */			
			$scope.$parent.heading = data;
			
			if(data == "Guest Bill") $scope.$parent.addNoPrintClass = true;
			else if(data == "Stay Card") $scope.$parent.isLogoPrint = true;
			else $scope.$parent.addNoPrintClass = false;
		});

		$scope.$on('SHOWPAYMENTLIST', function(event, data) {
			$scope.openPaymentList(data);
		});
		$scope.openPaymentList = function(data) {
			//	$scope.paymentData.payment_id = id;
			//  $scope.paymentData.index = index;
			$scope.dataToPaymentList = data;
			ngDialog.open({
				template: '/assets/partials/payment/rvShowPaymentList.html',
				controller: 'RVShowPaymentListCtrl',
				className: '',
				scope: $scope
			});
		};

	}
]);