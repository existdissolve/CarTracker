/**
 * Model representing a Status object
 */
Ext.define('CarTracker.model.option.Status', {
   extend: 'CarTracker.model.option.Base',
   idProperty: 'StatusID',
   fields: [
       // id field
       {
           name: 'StatusID',
           type: 'int',
           useNull : true
       }
   ] 
});