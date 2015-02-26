
var sntRover = angular.module('sntRover',[
		'ui.router', 
		'ui.utils', 
		'ng-iscroll', 
		'highcharts-ng', 
		'ngDialog',
		'ngAnimate', 
		'ngSanitize', 
		'pascalprecht.translate',
		'ui.date',
		'ui.calendar', 
		'dashboardModule', 
		'companyCardModule', 
		'stayCardModule', 
		'housekeepingModule', 
		'reportsModule', 
		'diaryModule',
		'FinancialsModule',
		'cacheVaultModule', 
		'twoMonthscalendar',
		'documentTouchMovePrevent', 
		'divTouchMoveStopPropogate', 
		'pasvaz.bindonce', 
		'sharedHttpInterceptor', 
		'orientationInputBlurModule',  
		'multi-select', 		
		'ngDragDrop',
		'iscrollStopPropagation',
		'ngReact']);


//adding shared http interceptor, which is handling our webservice errors & in future our authentication if needed
sntRover.config(function ($httpProvider) {
  $httpProvider.interceptors.push('sharedHttpInterceptor');
});

sntRover.run(['$rootScope', '$state', '$stateParams', function ($rootScope, $state, $stateParams) {
	$rootScope.$state = $state;
	$rootScope.$stateParams = $stateParams;

	$rootScope.setPrevState = {};
	$rootScope.setNextState = {};

	/**
	*	if this is true animation will be revesed, no more checks
	* 	keep track of the previous state and params
	* 
	*	@private
	*/
	var $_mustRevAnim = false,
		$_userReqBack = false,
		$_prevStateName = null,
		$_prevStateParam = null,
		$_prevStateTitle = null;

	var StateStore = function(stateName, checkAgainst) {
		var self = this;

		this.stateName    = stateName;
		this.checkAgainst = checkAgainst;

		this.fromState = false;
		this.fromParam = {};
		this.fromTitle = '';

		this.update = function(toState, fromState, fromParam) {
			if ( toState != this.stateName ) {
				return;
			};

			for (var i = 0; i < self.checkAgainst.length; i++) {
				if ( self.checkAgainst[i] == fromState ) {
					self.fromState = fromState;
					self.fromParam = fromParam;
					self.fromTitle = $rootScope.getPrevStateTitle();
					break;
				};
			};
		};

		this.getOriginState = function() {
			var ret, name, params, title;

			if (self.fromState) {
				name  = self.fromState;
				param = angular.copy(self.fromParam);
				title = self.fromTitle;

				ret = {
					'name'  : name,
					'param' : param,
					'title' : title
				};

				this.fromState = false;
				this.fromParam = {};
				this.fromTitle = '';
			} else {
				return false;
			}

			return ret;
		};

		this.useOriginal = function(title) {
			return title === self.fromTitle ? false : self.fromTitle ? true : false;
		};
	};

	$rootScope.diaryState = new StateStore('rover.diary', ['rover.dashboard.manager', 'rover.reservation.search']);



	var $_backTitleDict = {
		'SHOWING DASHBOARD' : 'DASHBOARD',
		'RESERVATIONS'      : 'CREATE RESERVATION'
	}

	var $_savePrevStateTitle = function(title) {
		var upperCase = title.toUpperCase();
		$_prevStateTitle = $_backTitleDict[upperCase] ? $_backTitleDict[upperCase] : title;
	};

	$rootScope.getPrevStateTitle = function() {
		return $_prevStateTitle;
	};


	/**
	*	revAnimList is an array of objects that holds
	*	state name sets that when transitioning
	*	the transition animation should be reversed 
	*	
	*	@private
	*/
	var $_revAnimList = [{
		fromState : 'rover.housekeeping.roomDetails',
		toState   : 'rover.housekeeping.roomStatus'
	}, {
		fromState : 'rover.reservation.staycard.billcard',
		toState   : 'rover.reservation.staycard.reservationcard.reservationdetails'
	}, {
		fromState : 'rover.staycard.nights',
		toState   : 'rover.reservation.staycard.reservationcard.reservationdetails'
	}, {
		fromState : 'rover.companycarddetails',
		toState   : 'rover.companycardsearch'
	}, {
		fromState : 'rover.reservation.staycard.roomassignment',
		toState   : 'rover.reservation.staycard.reservationcard.reservationdetails'
	}];


	/**
	*	A method on the $rootScope to determine if the
	*	slide animation during stateChange should run in reverse or forward
	*	Note: this is overridden when state change is via pressing back button action
	*
	*	@private
	*	@param {string} fromState - name of the fromState
	*	@param {string} toState - name of the toState
	*
	*	@return {boolean} - to indicate reverse or not
	*/
	var $_shouldRevDir = function(fromState, toState) {
		for (var i = 0, j = $_revAnimList.length; i < j; i++) {
			if ( $_revAnimList[i].fromState === fromState && $_revAnimList[i].toState === toState ) {
				return true;
				break;
			};
		};

		return false;
	};


	/**
	*	A very simple methods to go back to the previous state
	*	
	*	By default it will use the (saved) just previous state - '$_prevStateName', '$_prevStateParam'
	*	and always do the slide animation in reverse, unless overridden by callee.
	*
	*	Default behaviour can be overridden in two ways, by setting values to '$rootScope.setPrevState' in ctrl`:
	*	1. Pass in a callback with its scope - This callback will be responsible for the state change (total control)
	*	2. Pass in the state name and param - This will load the passed in state with its param
	* 
	* 	@param {Object} $rootScope.setPrevState - Uses this object as param which is set by the current state contoller
	*/
	$rootScope.loadPrevState = function() {

		// flag $_userReqBack as true
		$_userReqBack = true;

		// since these folks will be created anyway
		// so what the hell, put them here
		var options = $rootScope.setPrevState,
			name    = !!options.name ? options.name : $_prevStateName,
			param   = !!options.name && !!options.param ? options.param : (!!$_prevStateParam ? $_prevStateParam : {}),
			reverse = typeof options.reverse === 'boolean' ? true : false;

		// if currently disabled, return
		if ( options.disable ) {
			return;
		};

		// ok boys we are gonna sit this one out
		// 'scope.callback' is will be running the show
		if ( !!options.scope ) {

			// NOTE: if the controller explicitly says there is no actual state change
			// $_mustRevAnim must be set false, else check further
			$_mustRevAnim = options.noStateChange ? false : (reverse ? options.reverse : true);
			
			options.scope[options.callback]();
			return;
		};

		// check necessary as we can have a case where both can be null
		if ( !!name ) {
			$_mustRevAnim = reverse ? options.reverse : true;
			$state.go( name, param );
		};
	};


	$rootScope.returnBack = false;
	$rootScope.isReturning = function() {
		return $rootScope.returnBack;
	};


	/**
	*	For certain state transitions
	*	the transition animation must be reversed
	*
	*	This is achived by adding class 'return-back'
	*	to the imediate parent of 'ui-view'
	*	check this template to see how this class is applied:
	*	app/assets/rover/partials/staycard/rvStaycard.html
	*/
	$rootScope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams) {

		// spiting state names so as to add them to '$_revAnimList', if needed
		console.debug( '[%s %O] >>> [%s %O]', fromState.name, fromParams, toState.name, toParams );

		// this must be reset with every state change
		// invidual controllers can then set it  
		// with its own desired values
		$rootScope.setPrevState = {};

		// choose slide animation direction
		if ( $_mustRevAnim || $_shouldRevDir(fromState.name, toState.name) ) {
			$rootScope.returnBack = true;
		} else {
			$rootScope.returnBack = false;
		}

		// reset this flag
		$_mustRevAnim = false;

		// saving the prevState name and params
		$_prevStateName  = fromState.name;
		$_prevStateParam = fromParams;
	});


	/**
	*	before the state can change, we need to inform the assiciated service that we are returning back
	*	based on this info the service will return the previously cached data, rather than requesting the server

	*	on such request the service will look for certain values in $vault, 
	*	if they are avaliable the cached data will be updated before returning the data
	*/
	$rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
		if ( $_userReqBack ) {
			toParams.useCache = true;
			$_userReqBack = false;
		};

		// reset this flag
		$rootScope.returnBack = false;

		// capture the prev state document title;
		$_savePrevStateTitle(document.title);

		if ( $rootScope.setNextState.data ) {
			_.extend(toParams, $rootScope.setNextState.data);
			$rootScope.setNextState = {};
		};
		
		$rootScope.diaryState.update(toState.name, fromState.name, fromParams);
	});
}]);
