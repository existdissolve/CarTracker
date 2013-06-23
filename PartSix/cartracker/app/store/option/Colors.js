/**
 * Store for managing car colors
 */
Ext.define('CarTracker.store.option.Colors', {
    extend: 'CarTracker.store.option.Base',
    alias: 'store.option.color',
    requires: [
        'CarTracker.model.option.Color'
    ],
    restPath: '/api/option/colors',
    storeId: 'Colors',
    model: 'CarTracker.model.option.Color'
});