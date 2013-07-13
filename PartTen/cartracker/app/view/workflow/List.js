/**
 * Grid for displaying Workflow details for the selected Car
 */
Ext.define('CarTracker.view.workflow.List', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.workflow.list',
    requires: [
        'Ext.grid.column.Date',
        'Ext.grid.plugin.RowExpander'
    ],
    store: 'Workflows',
    CarID: null,
    viewConfig: {
        deferEmptyText: false,
        emptyText: 'No workflow history was found for the selected record',
        markDirty: false
    },
    plugins: [
        {
            ptype: 'rowexpander',
            rowBodyTpl : new Ext.XTemplate(
                '<b>Notes:</b> {Notes}'
            )
        }
    ],
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            columns: {
                defaults: {
                    sortable: false
                },
                items: [
                    {
                        text: 'From',
                        dataIndex: '_LastStatus',
                        width: 100
                    },
                    {
                        text: 'To',
                        dataIndex: '_NextStatus',
                        width: 100
                    },
                    {
                        text: 'Submitted By',
                        dataIndex: 'LastName',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return value + ', ' + record.get( 'FirstName' )
                        },
                        width: 200
                    },
                    {
                        xtype: 'datecolumn',
                        text: 'Submitted',
                        dataIndex: 'CreatedDate',
                        format: 'Y-m-d',
                        flex: 1
                    }
                ]
            }
        });
        me.callParent( arguments );
    }
});