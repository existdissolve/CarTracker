Ext.define('CarTracker.view.report.month.Dashboard', {
	extend: 'Ext.panel.Panel',
	alias: 'widget.report.month.dashboard',
	layout: 'border',
	initComponent: function() {
		var me = this;
		Ext.applyIf(me, {
			items: [
				{
					region: 'west',
					xtype: 'report.month.list',
					width: 500,
					split: true
				},
				{
					region: 'center',
					xtype: 'report.month.chart',
				}
			]
		});
		me.callParent();
	}
})