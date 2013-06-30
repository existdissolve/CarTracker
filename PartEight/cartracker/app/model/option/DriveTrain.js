/**
 * Model representing a DriveTrain object
 */
Ext.define('CarTracker.model.option.DriveTrain', {
   extend: 'CarTracker.model.option.Base',
   idProperty: 'DriveTrainID',
   fields: [
       // id field
       {
           name: 'DriveTrainID',
           type: 'int',
           useNull : true
       }
   ] 
});