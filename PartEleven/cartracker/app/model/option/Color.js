/**
 * Model representing a Color object
 */
Ext.define('CarTracker.model.option.Color', {
   extend: 'CarTracker.model.option.Base',
   idProperty: 'ColorID',
   fields: [
       // id field
       {
           name: 'ColorID',
           type: 'int',
           useNull : true
       }
   ] 
});