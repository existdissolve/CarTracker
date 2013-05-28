/**
 * Model representing a Category object
 */
Ext.define('CarTracker.model.option.Category', {
   extend: 'CarTracker.model.option.Base',
   idProperty: 'CategoryID',
   fields: [
       // id field
       {
           name: 'CategoryID',
           type: 'int',
           useNull : true
       }
   ] 
});