$( "#slider" ).slider();

		$(function() {

			//Store frequently elements in variables
			var slider  = $('#slider'),
				tooltip = $('.tooltip');

			//Hide the Tooltip at first
			tooltip.hide();

			//Call the Slider
			slider.slider({
				//Config
				range: "min",
				min: 0,
				max:100,
				value: 50,

				start: function(event,ui) {
					tooltip.fadeIn('fast');
				},
				
				//Slider Event
				slide: function(event, ui) { //When the slider is sliding
					
					var value  = slider.slider('value'),
						volume = $('.volume');
						value=value/10;
					
					if(value<=1) volumeControl(0);
					else volumeControl(value);
					
					console.log("value==="+value);
					tooltip.css('left', value).text(ui.value);
					
					if(value <= 1) { 
						volume.css('background-position', '0 0');
					} 
					else if (value <= 2) {
						volume.css('background-position', '0 -39px');
					} 
					else if (value <= 4) {
						volume.css('background-position', '0 -78px');
					} 
					else if (value <= 6) {
						volume.css('background-position', '0 -117px');
					}
					else {
						volume.css('background-position', '0 -156px');
					};

				},
				stop: function(event,ui) {
					tooltip.fadeOut('fast');
				},
			});

		});
