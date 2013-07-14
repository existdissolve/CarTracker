Ext.define('CarTracker.view.report.month.List', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.report.month.list',
    requires: [
        'Ext.grid.feature.Summary'
    ],
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            store: {
                type: 'report.month'
            },
            features: [
                {
                    ftype: 'summary'
                }
            ],
            columns: {
                items: [
                    {
                        text: 'Month',
                        dataIndex: 'Month',
                        sortable: false
                    },
                    {
                        text: 'No. Sold',
                        dataIndex: 'TotalSold',
                        summaryType: 'sum',
                        summaryRenderer: function( value, summaryData, dataIndex ) {
                            return '<strong>Total Sold: ' + value + '</strong>'; 
                        },
                        flex: 1,
                        sortable: false
                    },
                    {
                        text: 'Total Sales',
                        dataIndex: 'TotalSales',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return Ext.util.Format.usMoney( value );
                        },
                        summaryType: 'sum',
                        summaryRenderer: function( value, summaryData, dataIndex ) {
                            return '<strong>Grand Total: ' + Ext.util.Format.usMoney( value ) + '</strong>'; 
                        },
                        flex: 1,
                        sortable: false
                    }
                ]
            }
        });
        me.callParent( arguments );
    }
});