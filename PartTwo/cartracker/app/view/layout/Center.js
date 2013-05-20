Ext.define('CarTracker.view.layout.Center', {
    extend: 'Ext.panel.Panel',
    xtype: 'layout.center',
    region: 'center',
    title: 'Center Content',
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{
            
        });
        me.callParent( arguments );
    } 
});