Ext.define('CarTracker.view.executive.Dashboard', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.executive.dashboard',
    layout: 'border',
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            items: [
                // column 1
                {
                    xtype: 'container',
                    region: 'west',
                    width: '50%',
                    layout: 'anchor',
                    split: true,
                    items: [
                        {
                            xtype: 'panel',
                            title: 'Monthly Sales',
                            iconCls: 'icon_barchart',
                            anchor: '100% 50%',
                            layout: 'fit',
                            items: [
                                {
                                    xtype: 'report.month.chart',
                                    store: {
                                        type: 'report.month'
                                    }
                                }
                            ]
                        },
                        {
                            xtype: 'car.list',
                            dockedItems: false,
                            title: 'Latest Additions',
                            anchor: '100% 50%',
                            store: {
                                type: 'car',
                                pageSize: 6,
                                sorters: [
                                    {
                                        property: 'CreatedDate',
                                        direction: 'DESC'
                                    }
                                ]
                            }
                            
                        }
                    ]
                },
                // column 2
                {
                    xtype: 'container',
                    region: 'center',
                    width: '50%',
                    layout: 'anchor',
                    items: [
                        {
                            xtype: 'car.list',
                            dockedItems: false,
                            anchor: '100% 50%',
                            title: 'Audits Awaiting Approval',
                            iconCls: 'icon_workflow',
                            viewConfig: {
                                deferEmptyText: false,
                                emptyText: 'No audits awaiting approval!',
                                markDirty: false
                            },
                            store: {
                                type: 'car',
                                remoteFilter: true,
                                pageSize: 6,
                                sorters: [
                                    {
                                        property: 'CreatedDate',
                                        direction: 'DESC'
                                    }
                                ],
                                listeners: {
                                    beforeload: function( store, operation, eOpts ) {
                                        store.getProxy().extraParams = {
                                            filter: Ext.encode([
                                                {
                                                    property: 'Status',
                                                    value: [3]
                                                }
                                            ]) 
                                        };
                                    }
                                }
                            }
                        },
                        {
                            xtype: 'panel',
                            title: 'Sales by Model',
                            iconCls: 'icon_piechart',
                            anchor: '100% 50%',
                            layout: 'fit',
                            items: [
                                {
                                    xtype: 'report.make.chart',
                                    title: 'Sales by Make',
                                    store: {
                                        type: 'report.make'
                                    }
                                }
                            ]
                        }
                    ]
                }
            ],
        });
        me.callParent( arguments );
    }
});