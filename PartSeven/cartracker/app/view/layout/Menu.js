/**
 * Main top-level navigation for application
 */
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
                    iconCls: 'icon_gear',
                    menu: [
                        {
                            text: 'Car Makes',
                            itemId: 'option/make',
                            iconCls: 'icon_make'
                        },
                        {
                            text: 'Car Models',
                            itemId: 'option/model',
                            iconCls: 'icon_model'
                        },
                        {
                            text: 'Car Categories',
                            itemId: 'option/category',
                            iconCls: 'icon_category'
                        },
                        {
                            text: 'Car Colors',
                            itemId: 'option/color',
                            iconCls: 'icon_color'
                        },
                        {
                            text: 'Car Features',
                            itemId: 'option/feature',
                            iconCls: 'icon_feature'
                        },
                        {
                            text: 'Staff Positions',
                            itemId: 'option/position',
                            iconCls: 'icon_position'
                        },
                        {
                            text: 'Statuses',
                            itemId: 'option/status',
                            iconCls: 'icon_status'
                        },
                        {
                            text: 'Drive Trains',
                            itemId: 'option/drivetrain',
                            iconCls: 'icon_drivetrain'
                        }
                    ]
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