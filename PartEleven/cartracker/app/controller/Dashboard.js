/**
 * Controller for Executive Dashboard functionality
 */
Ext.define('CarTracker.controller.Dashboard', {
    extend: 'CarTracker.controller.Base',
    stores: [
        'report.Makes',
        'report.Months'
    ],
    views: [
        'executive.Dashboard'
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {
                '[xtype=executive.dashboard]': {
                    beforerender: this.loadDashboards,
                }
            },
            global: {},
            store: {},
            proxy: {} 
        });
    },
    /**
     * Handles initial loading of the executive dashboard
     * @param {Ext.panel.Panel} panel
     * @param {Object} eOpts
     */
    loadDashboards: function( panel, eOpts ) {
        var me = this,
            makereport = panel.down( '[xtype=report.make.chart]' ),
            monthreport= panel.down( '[xtype=report.month.chart]' );
        // call report stores manually
        makereport.getStore().load({
            params: {
                filter: Ext.encode([
                    {
                        property: 'SalesByMake',
                        value: true
                    },
                    {
                        property: 'IsSold',
                        value: true
                    }
                ])
            }
        });
        monthreport.getStore().load({
            params: {
                filter: Ext.encode([
                    {
                        property: 'SalesByMonth',
                        value: true
                    },
                    {
                        property: 'IsSold',
                        value: true
                    }
                ])
            }
        });
    }
});