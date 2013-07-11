Ext.define('CarTracker.view.report.month.Chart', {
    extend: 'Ext.chart.Chart',
    alias: 'widget.report.month.chart',
    requires: [
        'Ext.data.JsonStore',
        'Ext.chart.series.Column',
        'Ext.chart.axis.Numeric',
        'Ext.chart.axis.Category'
    ],
    store: Ext.create('Ext.data.JsonStore', {
        fields: [ 'Month', 'TotalSales' ]
    }),
    cls: 'x-panel-body-default',
    animate: true,
    border: false,
    shadow: true,
    axes: [
        {
            type: 'Numeric',
            position: 'left',
            fields: [ 'TotalSales' ],
            label: {
                renderer: Ext.util.Format.numberRenderer( '0,0' )
            },
            title: 'Sales ($)',
            grid: true,
            minimum: 0
        }, 
        {
            type: 'Category',
            position: 'bottom',
            fields: [ 'Month' ],
            title: 'Month of the Year'
        }
    ],
    series: [
        {
            type: 'column',
            axis: 'left',
            highlight: true,
            tips: {
                trackMouse: true,
                width: 140,
                height: 28,
                renderer: function( storeItem, item ) {
                    this.setTitle( storeItem.get( 'Month' ) + ': $' + Ext.util.Format.number( storeItem.get( 'TotalSales' ), '0,000' ) );
                }
            },
            label: {
                display: 'insideEnd',
                'text-anchor': 'middle',
                field: 'TotalSales',
                renderer: Ext.util.Format.numberRenderer( '0,000' ),
                orientation: 'vertical',
                color: '#333'
            },
            xField: 'Month',
            yField: 'TotalSales'
        }
    ]
});