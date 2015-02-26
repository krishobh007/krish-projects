var GridRowItem = React.createClass({
	getInitialState: function() {
		return {
			editing: this.props.edit.active,
			resizing: this.props.resizing,
			currentResizeItem: this.props.currentResizeItem,
			currentResizeItemRow: this.props.currentResizeItemRow
		};
	},
	
	componentWillReceiveProps: function(nextProps) {

		var meta_id = this.props.meta.occupancy.id,
			edit = nextProps.edit,
			editing = edit.active,
			creating;

		if(editing && (edit.originalItem[meta_id] === nextProps.data[meta_id])) {
			this.setState({
				editing: true,
				resizing: true,
				currentResizeItem: nextProps.currentResizeItem,
				currentResizeItemRow: nextProps.currentResizeItemRow
			});
		} else if(!editing && nextProps.currentResizeItem && (nextProps.currentResizeItem[meta_id] === nextProps.data[meta_id])) {
			this.setState({
				editing: nextProps.edit.active,
				resizing: true,
				currentResizeItem: nextProps.currentResizeItem,
				currentResizeItemRow: nextProps.currentResizeItemRow
			});
		} else if((!this.props.edit.active && this.props.currentResizeItem && !nextProps.currentResizeItem) || (this.props.edit.active && !editing)) {
			this.setState({
				editing: false,
				resizing: false,
				currentResizeItem: undefined,
				currentResizeItemRow: undefined
			});
		}
	},	
	__formInnerText: function(data, meta) {
		var caption,
			props   = this.props,
			display = props.display;
			
		switch(data[meta.status]) {
			case 'available':
				caption = display.currency_symbol + ' ' + parseFloat(data[meta.rate]).toFixed(2) + ' | ' + data[meta.room_type];
				break;
			case 'blocked':
				caption = 'Web Booking In Progress';
				break;
			default:
				caption = data[meta.guest];
				//in case of guest name is blank, we have to show account name againstg taht.
				if(!caption) {						
					caption = data[meta.tr_ag_name] ? data[meta.tr_ag_name] : data[meta.cmp_name];
				}
				
				//if there is any accomoanying guests
				if(!_.isEmpty(data[meta.accompanying_guests])) {
					caption = caption + "  |  ";
					_.each(data[meta.accompanying_guests], function(element, index, list){							
						caption += (element.guest_name);
						if(index !== (list.length - 1)){
							caption += ", ";
						}
					});
				}
				break
		}
		return caption;


	},

	__formHouseKeepingStyle: function(data, display, meta, end_time_ms){
		
		var style = {}, ms_fifteen_min	= 900000, end_of_reservation;
		
		style.width =  data[meta.maintenance] * display.px_per_int + 'px';
		end_of_reservation = (data[meta.maintenance] * ms_fifteen_min + end_time_ms);
		
		//(CICO-12358) when the reservation end is touching the end of the grid, we are hiding the house keeping task or showing the partial
		if( end_of_reservation > display.x_p){
			// reservation crossing the grid boundary we are hiding
			if(end_time_ms > display.x_p) {					
				style.display = 'none';
			}
			else{
				style.width = ((display.x_p - end_time_ms) * (display.px_per_ms)) + 'px';
			}
		}
		return style;

	},

	render: function() {

		var props 					= this.props,
			state 					= this.state,
			display 				= props.display,
			px_per_ms               = display.px_per_ms,
			px_per_int 				= display.px_per_int,
			x_origin   				= display.x_n, 			
			data 					= props.data,
			row_data 				= props.row_data,
			m                		= props.meta.occupancy,
			start_time_ms 			= !state.resizing ? data[m.start_date] : state.currentResizeItem[m.start_date],
			end_time_ms 			= !state.resizing ? data[m.end_date] : state.currentResizeItem[m.end_date],
			maintenance_time_span 	= data[m.maintenance] * px_per_int, 
			reservation_time_span 	= (end_time_ms - start_time_ms) * px_per_ms,  
			is_temp_reservation 	= data[m.status] === 'available',
			innerText 				= this.__formInnerText(data, m),
			className 				= (!is_temp_reservation ? 'occupied ' : '') + 
																data[m.status] + (state.editing ? ' editing' : '') + 
																(is_temp_reservation && data.selected ? ' reserved' : ''),
			houseKeepingTaskStyle	= this.__formHouseKeepingStyle(data, display, m, end_time_ms),
			left 					= (start_time_ms - x_origin) * px_per_ms + 'px';

			
		var start_date = new Date(start_time_ms);
				
		var display_start_time = (display.x_n instanceof Date ? display.x_n : new Date (display.x_n) );
		
		if(!display_start_time.isOnDST() && start_date.isOnDST()){
			var dateForCalculatingLeft = new Date(start_time_ms);
			dateForCalculatingLeft.setMinutes(dateForCalculatingLeft.getMinutes() + dateForCalculatingLeft.getDSTDifference());
			left = (dateForCalculatingLeft.getTime() - x_origin) * px_per_ms + 'px';			
		}
		else if(display_start_time.isOnDST() && !start_date.isOnDST()){
			var dateForCalculatingLeft = new Date(start_time_ms);
			dateForCalculatingLeft.setMinutes(dateForCalculatingLeft.getMinutes() + dateForCalculatingLeft.getDSTDifference());
			
			left = (dateForCalculatingLeft.getTime() - x_origin) * px_per_ms + 'px';

			//The special case adjustment
			if(dateForCalculatingLeft.isOnDST()){
				left = (dateForCalculatingLeft.getTime() +3600000 - x_origin) * px_per_ms + 'px';
			}


		}

		return GridRowItemDrag({
			key: 				data.key,
			className: 		    'occupancy-block' + (state.editing ? ' editing' : ''),
			row_data: 			row_data,
			meta:               props.meta,
			data:  				data,
			display: 			display,
			viewport: 			props.viewport,
			edit:               props.edit,
			iscroll:        	props.iscroll,
			angular_evt:    	props.angular_evt, 
			__onDragStart:  	props.__onDragStart,
			__onDragStop: 		props.__onDragStop,
			__onResizeCommand: 	props.__onResizeCommand,
			currentDragItem:    props.currentResizeItem,
			style: 			   { 
				display: 'block',
				left: left
			}
		}, 
		React.DOM.span({
			className: className,
			style: { 
				width: reservation_time_span + 'px' 
			}
		}, innerText),
		React.DOM.span({
			className: 'maintenance',
			style: houseKeepingTaskStyle
		}, ' '));
	}
});
