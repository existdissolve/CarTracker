/**
 * Model representing a Position object
 */
Ext.define('CarTracker.model.option.Position', {
   extend: 'CarTracker.model.option.Base',
   idProperty: 'PositionID',
   fields: [
       // id field
       {
           name: 'PositionID',
           type: 'int',
           useNull : true
       }
   ] 
});