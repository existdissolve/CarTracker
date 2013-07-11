/**
 * Abstract REST proxy 
 */
Ext.define('CarTracker.proxy.Rest', {
    extend: 'Ext.data.proxy.Rest',
    alias: 'proxy.baserest',
    format: 'json',
    limitParam: 'max',
    startParam: 'offset',
    sortParam: 'sortorder',
    writer: {
        type: 'json',
        writeAllFields: true
    },
    reader: {
        type: 'json',
        root: 'data',
        totalProperty: 'count'
    },
    afterRequest: function( request, success ) {
        var me = this;
        // fire requestcomplete event
        me.fireEvent( 'requestcomplete', request, success );
    }
});