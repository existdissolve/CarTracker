/**
 * This class implements the data proxy event domain. All classes extending from 
 * {@link Ext.data.proxy.Server} are included in this domain. The selectors are simply
 * store id's or the wildcard "*" to match any store.
 *
 * @protected
 */

Ext.define('CarTracker.domain.Proxy', {
    extend: 'Ext.app.EventDomain',
    singleton: true,
    requires: [
        'Ext.data.proxy.Server'
    ],
    type: 'proxy',
    idProperty: 'type',
    constructor: function() {
        var me = this;    
        me.callParent();
        me.monitor( Ext.data.proxy.Server );
    }
});