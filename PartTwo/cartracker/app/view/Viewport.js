Ext.define('CarTracker.view.Viewport', {
    extend: 'Ext.container.Viewport',
    requires:[
        'Ext.layout.container.Border',
        'CarTracker.view.layout.North',
        'CarTracker.view.layout.West',
        'CarTracker.view.layout.Center'
    ],
    layout: {
        type: 'border'
    },
    items: [
        { xtype: 'layout.north' },
        { xtype: 'layout.west' },
        { xtype: 'layout.center' }
    ]
});