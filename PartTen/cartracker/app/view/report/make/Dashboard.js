Ext.define('CarTracker.view.report.make.Dashboard', {
	extend: 'Ext.panel.Panel',
	alias: 'widget.report.make.dashboard',
	layout: 'border',
	initComponent: function() {
		var me = this;
		Ext.applyIf(me, {
			items: [
				{
					region: 'west',
					xtype: 'report.make.list',
					width: 500,
					split: true
				},
				{
					region: 'center',
					xtype: 'report.make.chart',
				}
			],
			dockedItems: [
				{
					xtype: 'toolbar',
					dock: 'top',
					ui: 'footer',
					items: [
						{
							xtype: 'button',
							iconCls: 'icon_refresh',
							text: 'Reload Data',
							itemId: 'refresh'
						}
					]
				}
			]
		});
		me.callParent();
	}
})