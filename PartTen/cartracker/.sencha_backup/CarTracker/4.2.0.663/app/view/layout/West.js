/**
 * West (sidebar) region for use within application
 */
Ext.define('CarTracker.view.layout.West', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.layout.west',
    requires: [
        'CarTracker.view.layout.Menu'
    ],
    region: 'west',
    title: 'Menu',
    split: true,
    bodyPadding: 5,
    minWidth: 175,
    width: 175,
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{
            items: [
                {
                    xtype: 'layout.menu'
                }
            ]
        });
        me.callParent( arguments );
    } 
});