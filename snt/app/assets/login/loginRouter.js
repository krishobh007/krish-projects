
login.config([	
	'$stateProvider',
	'$urlRouterProvider',
	function($stateProvider, $urlRouterProvider) {

		// dashboard state
		$urlRouterProvider.otherwise('/login');
		
		$stateProvider.state('login', {
			url: '/login',
			templateUrl: '/assets/partials/login.html',
			controller: 'loginCtrl',
			title: 'Login'
		});
		
		$stateProvider.state('resetpassword', {
			url: '/reset/:token/:notifications',
			templateUrl: '/assets/partials/reset.html',
			controller: 'resetCtrl',
			title: 'Reset Password'
		});
		
		$stateProvider.state('activateuser', {
			url: '/activate/:token/:user',
			templateUrl: '/assets/partials/activate.html',
			controller: 'activateCtrl',
			title: 'Activate User'
		});

	}
]);