/**
 * {@link Ext.data.Model} for Month Sales object
 */
Ext.define('CarTracker.model.report.Month', {
    extend: 'Ext.data.Model',
    fields: [
        // non-relational properties
        {
            name: 'Month',
            type: 'string',
            persist: false
        },
        {
            name: 'TotalSold',
            type: 'int',
            persist: false
        },
        {
            name: 'TotalSales',
            type: 'int',
            persist: false
        }
    ]
});