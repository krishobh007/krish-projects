var AppRouter = Backbone.Router.extend({
    routes:{
        "":"dashboard",
        "info": "infoPage",//function() {this.changePage(new InfoView());},
        "deals":"dealsPage",
    },
    initialize:function () {
    	// Handle back button throughout the application
    	 $('.back').live('click', function(event) {
             window.history.back();
             return false;
         });
    },
    dashboard:function () {
        console.log('#dashboard');
        this.changePage(new DashBoardView());
    },
    infoPage:function () {            
    	console.log('#info');
    	this.changePage(new InfoView());
    },
    dealsPage:function () {   
    	console.log('#deals');
    	this.changePage(new DealsView());
    },
    changePage:function (page, id) {
    	
        $(page.el).attr('data-role','page');
        $('body').append($(page.el));
        page.pageload(); 
        
        $(page.el).live('pageinit',function(){page.pageinit();});
        $(page.el).live('pageshow',function(){page.pageshow();});
        
        $.mobile.changePage($(page.el), {changeHash:false, transition: $.mobile.defaultPageTransition});
      
    }
});


