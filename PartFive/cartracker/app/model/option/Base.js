/**
 * Base {@link CarTracker.model.Base} from which all other "Option" models will extend
 */
Ext.define('CarTracker.model.option.Base', {
   extend: 'CarTracker.model.Base',
   fields: [
       // non-relational properties
       {
           name: 'LongName',
           type: 'string'
       },
       {
           name: 'ShortName',
           type: 'string'
       }
   ] 
});