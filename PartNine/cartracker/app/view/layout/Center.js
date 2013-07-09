/**
 * Main content region for application
 */
Ext.define('CarTracker.view.layout.Center', {
    extend: 'Ext.container.Container',
    alias: 'widget.layout.center',
    region: 'center',
    layout: 'fit',
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{

        });
        me.callParent( arguments );
    } 
});