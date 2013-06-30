/**
 * Store for managing car makes
 */
Ext.define('CarTracker.store.option.Makes', {
    extend: 'CarTracker.store.option.Base',
    alias: 'store.option.make',
    requires: [
        'CarTracker.model.option.Make'
    ],
    restPath: '/api/option/makes',
    storeId: 'Makes',
    model: 'CarTracker.model.option.Make'
});