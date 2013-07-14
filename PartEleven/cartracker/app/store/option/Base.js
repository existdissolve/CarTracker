/**
 * Store from which all other option stores will extend
 */
Ext.define('CarTracker.store.option.Base', {
    extend: 'CarTracker.store.Base',
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            storeId: 'option_Base'
        }, cfg)]);
    },
    sorters: [
        {
            property: 'LongName',
            direction: 'ASC'
        }
    ] 
})