/**
 * Grid for displaying Staff details
 */
Ext.define('CarTracker.view.car.List', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.car.list',
    requires: [
        'Ext.grid.column.Boolean',
        'Ext.grid.column.Date',
        'Ext.grid.column.Number'
    ],
    title: 'Manage Inventory',
    iconCls: 'icon_tag',
    store: 'Cars',
    viewConfig: {
        deferEmptyText: false,
        emptyText: 'Sorry, no cars matched your search criteria!'
    },
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            columns: {
                defaults: {},
                items: [
                    {
                        text: 'Make',
                        dataIndex: 'Make',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return record.get( '_Make' )
                        },
                        width: 100
                    },
                    {
                        text: 'Model',
                        dataIndex: 'Model',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return record.get( '_Model' )
                        },
                        width: 100
                    },
                    {
                        text: 'Category',
                        dataIndex: 'Category',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return record.get( '_Category' )
                        },
                        width: 100
                    },
                    {
                        text: 'Year',
                        dataIndex: 'Year'
                    },
                    {
                        text: 'Color',
                        dataIndex: 'Color',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return record.get( '_Color' )
                        },
                        width: 200
                    },
                    {
                        xtype: 'datecolumn',
                        text: 'Acquired',
                        dataIndex: 'AcquisitionDate',
                        dateFormat: 'Y-m-d',
                        hidden: true
                    },
                    {
                        xtype: 'numbercolumn',
                        text: 'List Price',
                        dataIndex: 'ListPrice'
                    },
                    {
                        xtype: 'numbercolumn',
                        text: 'Sale Price',
                        dataIndex: 'SalePrice'
                    },
                    {
                        xtype: 'booleancolumn',
                        text: 'Sold?',
                        dataIndex: 'IsSold',
                        trueText: 'Yes',
                        falseText: 'No'
                    },
                    {
                        xtype: 'datecolumn',
                        text: 'Sale Date',
                        dataIndex: 'SaleDate',
                        dateFormat: 'Y-m-d',
                        hidden: true
                    },
                    {
                        text: 'Status',
                        dataIndex: 'Status',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return record.get( '_Status' )
                        },
                        width: 200
                    }
                ]
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    ui: 'footer',
                    items: [
                        {
                            xtype: 'button',
                            itemId: 'add',
                            iconCls: 'icon_add',
                            text: 'Add to Inventory'
                        },
                        '-',
                        {
                            xtype: 'button',
                            itemId: 'search',
                            iconCls: 'icon_search',
                            text: 'Search Inventory'
                        },
                        '-',
                        {
                            xtype: 'button',
                            itemId: 'clear',
                            iconCls: 'icon_delete',
                            text: 'Clear Search'
                        }
                    ]
                },
                {
                    xtype: 'pagingtoolbar',
                    ui: 'footer',
                    defaultButtonUI: 'default',
                    dock: 'bottom',
                    displayInfo: true,
                    store: me.getStore()
                }
            ]
        });
        me.callParent( arguments );
    }
});