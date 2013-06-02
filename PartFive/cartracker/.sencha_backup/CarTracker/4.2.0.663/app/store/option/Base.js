Ext.define('CarTracker.store.option.Base', {
    extend: 'CarTracker.store.Base',
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            storeId: 'option_Base'
        }, cfg)]);
    }
})