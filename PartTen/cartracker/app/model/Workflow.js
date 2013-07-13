/**
 * Model representing a Staff object
 */
Ext.define('CarTracker.model.Workflow', {
    extend: 'CarTracker.model.Base',    
    idProperty: 'WorkflowID',
    fields: [
        // id field
        {
            name: 'WorkflowID',
            type: 'int',
            useNull : true
        },
        // simple values
        {
            name: 'Notes',
            type: 'string'
        },
        {
            name: 'Approved',
            type: 'boolean'
        },
        // relational properties
        {
            name: 'LastStatus',
            type: 'auto'
        },
        {
            name: 'NextStatus',
            type: 'auto'
        },
        {
            name: 'Staff',
            type: 'auto'
        },
        // decorated properties
        {
            name: '_LastStatus',
            type: 'string',
            persist: false
        },
        {
            name: '_NextStatus',
            type: 'string',
            persist: false
        },
        {
            name: 'LastName',
            type: 'string',
            persist: false
        },
        {
            name: 'FirstName',
            type: 'string',
            persist: false
        }
    ] 
});