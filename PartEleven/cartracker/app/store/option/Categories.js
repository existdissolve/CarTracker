/**
 * Store for managing car categories
 */
Ext.define('CarTracker.store.option.Categories', {
    extend: 'CarTracker.store.option.Base',
    alias: 'store.option.category',
    requires: [
        'CarTracker.model.option.Category'
    ],
    restPath: '/api/option/categories',
    storeId: 'Categories',
    model: 'CarTracker.model.option.Category'
});