Ext.define('CarTracker.view.layout.Menu', {
    extend: 'Ext.menu.Menu',
    alias: 'widget.layout.menu',
    floating: false,
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{
            items: [
                {
                    text: 'Options',
                    itemId: 'options',
                    iconCls: 'icon_gear'
                },
                {
                    xtype: 'menuseparator'
                },
                {
                    text: 'Sales Staff',
                    itemId: 'staff',
                    iconCls: 'icon_user'
                },
                {
                    xtype: 'menuseparator'
                },
                {
                    text: 'Inventory',
                    itemId: 'inventory',
                    iconCls: 'icon_tag'
                }
            ]
        });
        me.callParent( arguments );
    } 
});