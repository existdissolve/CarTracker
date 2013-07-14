/**
 * {@link Ext.data.Model} for Security User
 */
Ext.define('CarTracker.model.security.User', {
    extend: 'Ext.data.Model',
    fields: [
        // non-relational properties
        {
            name: 'FirstName',
            type: 'string',
            persist: false
        },
        {
            name: 'LastName',
            type: 'string',
            persist: false
        },
        {
            name: 'Username',
            type: 'string',
            persist: false
        },
        {
            name: 'Roles',
            type: 'any',
            persist: false
        },
        {
            name: 'StaffID',
            type: 'int',
            persist: false
        }
    ],
    inRole: function( RoleID ) {
        var me = this;
        return Ext.Array.contains( me.get( 'Roles' ), RoleID );
    } 
});