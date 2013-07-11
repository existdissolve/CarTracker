/**
 * Store for managing cars
 */
Ext.define('CarTracker.store.report.Makes', {
    extend: 'CarTracker.store.Base',
    alias: 'store.report.make',
    requires: [
        'CarTracker.model.report.Make'
    ],
    restPath: '/api/reports/make',
    storeId: 'report_Makes',
    model: 'CarTracker.model.report.Make',
    remoteSort: false,
    remoteGroup: false,
    groupField: 'Make'
});