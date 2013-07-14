/**
 * Controller for all car-related management functionality
 */
Ext.define('CarTracker.controller.Reports', {
    extend: 'CarTracker.controller.Base',
    stores: [
        'report.Makes',
        'report.Months'
    ],
    views: [
        'report.make.Dashboard',
        'report.make.List',
        'report.make.Chart',
        'report.month.Dashboard',
        'report.month.List',
        'report.month.Chart'
    ],
    refs: [
        {
            ref: 'SalesByMakeDashboard',
            selector: '[xtype=report.make.dashboard]'
        },
        {
            ref: 'SalesByMonthDashboard',
            selector: '[xtype=report.month.dashboard]'
        }
    ],
    requires: [
        'Ext.data.JsonStore'
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {
                '[xtype=report.make.dashboard]': {
                    beforerender: this.loadSalesByMake,
                },
                '[xtype=report.month.dashboard]': {
                    beforerender: this.loadSalesByMonth,
                },
                '[xtype=report.make.dashboard] button#refresh': {
                    click: this.loadSalesByMakeFullChart,
                },
                '[xtype=report.make.list]': {
                    itemclick: this.loadSalesByMakeDetailChart
                }
            },
            global: {},
            store: {},
            proxy: {} 
        });
    },
    /**
     * Loads the component's store
     * @param {Ext.panel.Panel} panel
     * @param {Object} eOpts
     */
    loadSalesByMake: function( panel, eOpts ) {
        var me = this,
            store = panel.down( 'grid' ).getStore(),
            chart = panel.down( 'chart' ),
            data=[];
        // add extra params
        store.getProxy().extraParams = {
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
        };
        // load the store
        store.load({
            callback: function( records, operation, success ) {
                me.loadSalesByMakeFullChart();
            }
        });
    },
    /**
     * Reloads chart from full grid data
     */
    loadSalesByMakeFullChart: function() {
        var me = this,
            view = me.getSalesByMakeDashboard(),
            grid = view.down( 'grid' ),
            store = grid.getStore(),
            chart = view.down( 'chart' ),
            chartStore = chart.getStore();
        // clear any filters
        chartStore.clearFilter( false );
        // load full range of data
        chartStore.loadData( store.getRange() );
    },
    /**
     * Filters chart store by selected Make
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record
     * @param {Object} item
     * @param {Number} index
     * @param {Object} e
     * @param {Object} eOpts
     */
    loadSalesByMakeDetailChart: function( view, record, item, index, e, eOpts ) {
        var me = this,
            make = record.get( 'Make' ),
            data = [],
            chart = view.up( '[xtype=report.make.dashboard]' ).down( 'chart' ),
            store = chart.getStore();
        // clear filter
        store.clearFilter( true );
        // filter by make
        store.filter( 'Make', make );
    },
    /**
     * Loads the component's store
     * @param {Ext.panel.Panel} panel
     * @param {Object} eOpts
     */
    loadSalesByMonth: function( panel, eOpts ) {
        var me = this,
            view = me.getSalesByMonthDashboard(),
            store = view.down( 'grid' ).getStore(),
            chart = view.down( 'chart' ),
            data=[];
        // add extra params
        store.getProxy().extraParams = {
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
        };
        // load the store
        store.load({
            callback: function( records, operation, success ) {
                chart.getStore().loadData( store.getRange() );
            }
        });
    },
});