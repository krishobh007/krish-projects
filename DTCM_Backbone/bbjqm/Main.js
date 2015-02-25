$(document).ready(function() {
	var templates = ['dashboard', 'info', 'deals', 'dealItem'];
	console.log('document ready');
	
	//loads all the templates
	tpl.loadTemplates(templates, appInit);
	
	function appInit(){
		app = new AppRouter();
		Backbone.history.start();
	}
	
	
});
