/**
 * Store for managing car drive trains
 */
Ext.define('CarTracker.store.option.DriveTrains', {
    extend: 'CarTracker.store.option.Base',
    alias: 'store.option.drivetrain',
    requires: [
        'CarTracker.model.option.DriveTrain'
    ],
    restPath: '/api/option/drivetrains',
    storeId: 'DriveTrains',
    model: 'CarTracker.model.option.DriveTrain'
});