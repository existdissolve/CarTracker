/**
 * Store for managing statuses
 */
Ext.define('CarTracker.store.option.Statuses', {
    extend: 'CarTracker.store.option.Base',
    alias: 'store.option.status',
    requires: [
        'CarTracker.model.option.Status'
    ],
    restPath: '/api/option/statuses',
    storeId: 'Statuses',
    model: 'CarTracker.model.option.Status'
});