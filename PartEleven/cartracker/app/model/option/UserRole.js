/**
 * Model representing a UserRole object
 */
Ext.define('CarTracker.model.option.UserRole', {
   extend: 'CarTracker.model.option.Base',
   idProperty: 'UserRoleID',
   fields: [
       // id field
       {
           name: 'UserRoleID',
           type: 'int',
           useNull : true
       }
   ] 
});