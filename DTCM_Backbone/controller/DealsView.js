var DealsView = BaseView.extend({
	initialize: function(templateName){
		console.log("Dealsview page initialize");
		this.templateName = "deals";
		return this;
	},
	pageinit: function(){
		console.log("Dealsview pageinit");
		this.deals = new Deals();
		//this.deals.create({dealName: "Today's Deals"});
		this.deals.fetch();
	},
	pageshow: function(){
		console.log("Dealsview pageshow");
		this.loadDeals();
	},
	loadDeals : function () {
		 var listItem = _.template(tpl.get('dealItem'));
		 ul = $(this.el).find('ul');
		 this.deals.each(function(dealItem) {
			 ul.append(listItem({item: dealItem.get("dealName")}));
		 });
		 $('#dealList').listview('refresh');
	}
});

