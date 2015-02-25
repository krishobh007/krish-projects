var BaseView = Backbone.View.extend({
	initialize: function(){
		console.log("base initialize");
		this.templateName = "default";
		return this;
	 },
	 pageload: function() {
		 var template = _.template(tpl.get(this.templateName));
		 $(this.el).html(template);
		 return this;
	 },
	 pageinit: function(){
		 console.log("baseview pageinit");
	 },
	 pageshow: function(){
		 console.log("baseview pageshow");
	 },
});