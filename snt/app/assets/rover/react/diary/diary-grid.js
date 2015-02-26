var Grid = React.createClass({
	componentDidMount: function() {
		var iscroll = this.props.iscroll;

		iscroll.grid = new IScroll($('.diary-grid .wrapper')[0], { 
			probeType: 2, 
			scrollbars: 'custom',
			interactiveScrollbars: true,
			scrollX: true, 
			scrollY: true, 
			bounce: false,
			momentum: false,
			preventDefaultException: { className: /(^|\s)(occupied|available|reserved)(\s|$)/ },
			mouseWheel: true,
			useTransition: true,
		});

		iscroll.grid._scrollFn = _.throttle(this.props.__onGridScroll.bind(null, iscroll.grid), 10, { leading: false, trailing: true });

		iscroll.grid.on('scroll', iscroll.grid._scrollFn);
		iscroll.grid.on('scrollEnd', this.props.__onGridScrollEnd);
																																																																			
		setTimeout(function () {
	        iscroll.grid.refresh();
	    }.bind(this), 1000);
	},
	componentWillUnmount: function() {
		this.props.iscroll.grid.destroy();
		this.props.iscroll.grid = null; 
	},
	render: function() {
		var props 		= this.props,
			display 	= props.display,
			grid_width 	= display.width + 'px',
			self 		= this;

		/*OUTPUT VIEWPORT/GRID and eventually TIMELINE*/
		return  React.DOM.div({
					id: 'grid-wrapper',
					className: 'wrapper scrollable'
				},
				React.DOM.ul({ 
					className: 'grid',
					style: {
						width: grid_width//, 
						//left: -1 * (display.x_offset - display.x_n) * display.px_per_ms + 'px'
					}
				}, 
				_.map(this.props.data, function(row, idx) {
					return GridRow({
						key: 				row.key,
						data: 				row,
						row_number: 		idx,
						display: 			display,
						viewport: 			props.viewport,
						filter: 			props.filter,
						meta:               props.meta,
						edit:               props.edit,
						iscroll:            props.iscroll, 
						angular_evt: 		props.angular_evt,
						currentResizeItem:  props.currentResizeItem,
						currentResizeItemRow: props.currentResizeItemRow,
						__onResizeCommand: 	props.__onResizeCommand,
						__onDragStart: 		props.__onDragStart,
						__onDragStop: 		props.__onDragStop			
					});
				})
		));
	}
});
