/**
 * Model representing a Staff object
 */
Ext.define('CarTracker.model.Car', {
    extend: 'CarTracker.model.Base',    
    idProperty: 'CarID',
    fields: [
        // id field
        {
            name: 'CarID',
            type: 'int',
            useNull : true
        },
        // simple values
        {
            name: 'Description',
            type: 'string'
        },
        {
            name: 'Year',
            type: 'int'
        },
        {
            name: 'ListPrice',
            type: 'int'
        },
        {
            name: 'SalePrice',
            type: 'int'
        },
        {
            name: 'AcquisitionDate',
            type: 'date',
            dateWriteFormat: 'Y-m-d'
        },
        {
            name: 'SaleDate',
            type: 'date',
            dateWriteFormat: 'Y-m-d'
        },
        {
            name: 'IsSold',
            type: 'boolean'
        },
        // relational properties
        {
            name: 'Status',
            type: 'auto'
        },
        {
            name: 'Make',
            type: 'auto'
        },
        {
            name: 'Model',
            type: 'auto'
        },
        {
            name: 'Category',
            type: 'auto'
        },
        {
            name: 'SalesPeople',
            type: 'auto'
        },
        {
            name: 'Color',
            type: 'auto'
        },
        {
            name: 'Features',
            type: 'auto'
        },
        // decorated properties
        {
            name: '_Status',
            type: 'string',
            persist: false
        },
        {
            name: '_Make',
            type: 'string',
            persist: false
        },
        {
            name: '_Model',
            type: 'string',
            persist: false
        },
        {
            name: '_Category',
            type: 'string',
            persist: false
        },
        {
            name: '_Color',
            type: 'string',
            persist: false
        },
        {
            name: '_Features',
            type: 'string',
            persist: false
        },
        {
            name: '_SalesPeople',
            type: 'string',
            persist: false
        }
    ] 
});