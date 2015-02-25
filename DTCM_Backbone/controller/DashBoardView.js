var DashBoardView = BaseView.extend({
	 initialize: function(){
		console.log("dashboard page initialize");
		this.templateName = "dashboard";
		return this;
	 },
	 events: {
		 "click #info": function(){app.navigate('info', {trigger: true});},
		 "click #deals": function(){app.navigate('deals', {trigger: true});},
	 }
});