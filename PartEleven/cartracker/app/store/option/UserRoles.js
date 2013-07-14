/**
 * Store for managing car makes
 */
Ext.define('CarTracker.store.option.UserRoles', {
    extend: 'CarTracker.store.option.Base',
    alias: 'store.option.userrole',
    requires: [
        'CarTracker.model.option.UserRole'
    ],
    restPath: '/api/option/userroles',
    storeId: 'UserRoles',
    model: 'CarTracker.model.option.UserRole'
});