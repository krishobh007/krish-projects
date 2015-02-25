var DealItem = Backbone.Model.extend({
	defaults:{
		dealName: ""
	}
  }); 
var Deals = Backbone.Collection.extend({
	model: DealItem,
	localStorage: new Store("deal-store")
  });