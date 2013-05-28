/**
 * Base {@link Ext.data.Model} from which all other models will extend
 */
Ext.define('CarTracker.model.Base', {
   extend: 'Ext.data.Model',
   fields: [
       // non-relational properties
       {
           name: 'CreatedDate',
           type: 'date',
           persist: false
       },
       {
           name: 'Active',
           type: 'boolean',
           defaultValue: true
       }
   ] 
});