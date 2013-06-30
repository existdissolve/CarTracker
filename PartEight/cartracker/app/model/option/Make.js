/**
 * Model representing a Make object
 */
Ext.define('CarTracker.model.option.Make', {
   extend: 'CarTracker.model.option.Base',
   idProperty: 'MakeID',
   fields: [
       // id field
       {
           name: 'MakeID',
           type: 'int',
           useNull : true
       }
   ] 
});