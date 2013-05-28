Ext.define('CarTracker.view.option.List', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.option.list',
    requires: [
        'Ext.grid.plugin.RowEditing',
        'Ext.toolbar.Paging'
    ],
    initComponent: function() {
        var me = this;
        Ext.applyIf(me,{
            selType: 'rowmodel',
            plugins: [
                {
                    ptype: 'rowediting',
                    clicksToEdit: 2
                }
            ],
            columns: {
                defaults: {},
                items: [
                    {
                        text: 'Abbreviation',
                        dataIndex: 'ShortName',
                        editor: {
                            xtype: 'textfield'
                        },
                        flex: .2
                    },
                    {
                        text: 'Name',
                        dataIndex: 'LongName',
                        editor: {
                            xtype: 'textfield',
                            allowBlank: false
                        },
                        flex: .5
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
                            text: 'Add Item'
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