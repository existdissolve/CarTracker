/**
 * Store for managing car images
 */
Ext.define('CarTracker.store.Images', {
	extend: 'Ext.data.Store',
    alias: 'store.image',
    requires: [
        'CarTracker.model.Image'
    ],
    storeId: 'Images',
    model: 'CarTracker.model.Image'
});