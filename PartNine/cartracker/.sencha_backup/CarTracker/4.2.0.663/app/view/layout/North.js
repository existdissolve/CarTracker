/**
 * "Header" for the application (logo, title, etc.)
 */
Ext.define('CarTracker.view.layout.North', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.layout.north',
    region: 'north',
    bodyPadding: 5,
    html: '<img src="resources/images/car.png" /><h1>Car Tracker</h1>',
    cls: 'header',                  
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{
            
        });
        me.callParent( arguments );
    } 
});