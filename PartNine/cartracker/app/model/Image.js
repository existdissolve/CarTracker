/**
 * Model representing an Image object
 */
Ext.define('CarTracker.model.Image', {
    extend: 'CarTracker.model.Base',    
    idProperty: 'ImageID',
    fields: [
        // id field
        {
            name: 'ImageID',
            type: 'int',
            useNull : true
        },
        // simple values
        {
            name: 'Path',
            type: 'string'
        },
        // relational properties
        {
            name: 'Car',
            type: 'auto'
        }
    ] 
});