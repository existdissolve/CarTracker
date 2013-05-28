/**
 * Model representing a Feature object
 */
Ext.define('CarTracker.model.option.Feature', {
   extend: 'CarTracker.model.option.Base',
   idProperty: 'FeatureID',
   fields: [
       // id field
       {
           name: 'FeatureID',
           type: 'int',
           useNull : true
       }
   ] 
});