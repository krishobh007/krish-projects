var GridRow = React.createClass({
	shouldComponentUpdate: function(nextProps, nextState) {
		var render = true; //false;

		/*if(this.props.viewport !== nextProps.viewport ||
		   this.props.display !== nextProps.display) {
			render = true;
		} else {
			if(this.props.data.reservations.length !== nextProps.data.reservations.length) {
				render = true;
			} else if(nextProps.currentResizeItem) {
				if(nextProps.data.id === nextProps.currentResizeItemRow.id) {
					render = true;
				}
				//render = true;
			} else {
				for(var i = 0, len = this.props.data.reservations.length; i < len; i++) {
					if(this.props.data.reservations[i] !== nextProps.data.reservations[i]) {
						render = true;
						return render;
					}
				}
			}		
		}*/

		return render;
	},
	componentDidMount: function(){
		$(this.getDOMNode()).droppable();
	},
	render: function() {
		var props 				= this.props,
			display 			= props.display,
			px_per_hr 			= display.px_per_hr + 'px',
			hourly_divs 		= [],
			room_meta 			= props.meta.room,
			room_meta_children 	= room_meta.row_children,
			room_meta_inactive	= room_meta.inactive_slots,
			room_inactives		= [],
			self 				= this;

		/*Create hourly spans across each grid row*/
		for(var i = 0, len = display.hours; i < len; i++) {
			hourly_divs.push(React.DOM.span({ 
				className: 	'hour',
				style: {
					width: px_per_hr
				}
			}));
		}
		
		/** Creating in active slots */
		_.each(props.data[room_meta_inactive], function(inactive_slot) {			
			room_inactives.push(GridRowInactive({
				data: 			inactive_slot,
				display: 		display,
				viewport:    	props.viewport, 
			}));
		});


		/*Create grid row and insert each occupany item as child into that row*/
		return React.DOM.li({
			key: 		props.key,
			className: 	'grid-row'
		},
		hourly_divs,
		room_inactives,
		_.map(props.data[room_meta_children], function(occupancy) {
			return GridRowItem({
				key: 			occupancy.key,
				display: 		display,
				viewport:    	props.viewport, 
				filter: 		props.filter,
				edit:           props.edit,
				iscroll:        props.iscroll,
				angular_evt: 	props.angular_evt,
				meta:           props.meta,				
				data: 			occupancy,
				row_data:       props.data, 
				row_offset: 	props.row_number * (display.row_height + display.row_height_margin),
				__onDragStart:  props.__onDragStart,
				__onDragStop: 	props.__onDragStop,
				__onResizeCommand: 	props.__onResizeCommand,
				currentResizeItem: props.currentResizeItem,
				currentResizeItemRow: props.currentResizeItemRow
			});
		})); //GridRowBackground({ display: this.props.display })); //hourly_divs);
	}	
});
