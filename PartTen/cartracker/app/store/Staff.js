/**
 * Store for managing staff
 */
Ext.define('CarTracker.store.Staff', {
	extend: 'CarTracker.store.Base',
    alias: 'store.staff',
    requires: [
        'CarTracker.model.Staff'
    ],
    restPath: '/api/staff',
    storeId: 'Staff',
    model: 'CarTracker.model.Staff'
});