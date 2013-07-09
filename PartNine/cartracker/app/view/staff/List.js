/**
 * Grid for displaying Staff details
 */
Ext.define('CarTracker.view.staff.List', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.staff.list',
    requires: [
        'Ext.grid.column.Boolean',
        'Ext.grid.column.Date'
    ],
    title: 'Manage Staff Members',
    iconCls: 'icon_user',
    store: 'Staff',
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            columns: {
                defaults: {},
                items: [
                    {
                        text: 'Position',
                        dataIndex: '_Position',
                        width: 200
                    },
                    {
                        text: 'Name',
                        dataIndex: 'LastName',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return value + ', ' + record.get( 'FirstName' )
                        },
                        width: 200
                    },
                    {
                        xtype: 'datecolumn',
                        text: 'Hire Date',
                        dataIndex: 'HireDate',
                        dateFormat: 'Y-m-d'
                    },
                    {
                        text: 'Phone',
                        dataIndex: 'Phone'
                    },
                    {
                        xtype: 'booleancolumn',
                        text: 'Active',
                        dataIndex: 'Active',
                        trueText: 'Yes',
                        falseText: 'No'
                    },
                    {
                        xtype: 'datecolumn',
                        text: 'DOB',
                        dataIndex: 'DOB',
                        dateFormat: 'Y-m-d',
                        hidden: true
                    },
                    {
                        text: 'Address1',
                        dataIndex: 'Address1',
                        hidden: true
                    },
                    {
                        text: 'Address2',
                        dataIndex: 'Address2',
                        hidden: true
                    },
                    {
                        text: 'City',
                        dataIndex: 'City',
                        hidden: true
                    },
                    {
                        text: 'State',
                        dataIndex: 'State',
                        hidden: true
                    },
                    {
                        text: 'Postal Code',
                        dataIndex: 'PostalCode',
                        hidden: true
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
                            text: 'Add Staff Member'
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