/**
 * Generic landing page for application
 */
Ext.define('CarTracker.view.layout.Landing', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.layout.landing',
    title: 'Welcome!',
    bodyPadding: 10,
    html: 'Welcome to the Car Tracker Administration Site!',
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{

        });
        me.callParent( arguments );
    } 
});