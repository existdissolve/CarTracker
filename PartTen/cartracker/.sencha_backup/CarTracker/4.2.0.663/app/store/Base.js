Ext.define('CarTracker.store.Base', {
    extend: 'Ext.data.Store',
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            storeId: 'Base'
        }, cfg)]);
    }
})