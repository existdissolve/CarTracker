Ext.define('CarTracker.view.report.make.Chart', {
    extend: 'Ext.chart.Chart',
    alias: 'widget.report.make.chart',
    requires: [
        'Ext.chart.series.Pie',
        'Ext.data.JsonStore'
    ],
    store: Ext.create('Ext.data.JsonStore', {
        fields: [ 'Model', 'TotalSales' ]
    }),
    cls: 'x-panel-body-default',
    animate: true,
    border: false,
    shadow: true,
    legend: {
        position: 'right'
    },
    insetPadding: 60,
    theme: 'Base:gradients',
    series: [
        {
            type: 'pie',
            field: 'TotalSales',
            showInLegend: true,
            donut: 10,
            tips: {
                trackMouse: true,
                width: 170,
                height: 28,
                renderer: function( storeItem, item ) {
                    //calculate percentage.
                    var total = 0;
                    storeItem.store.each(function(rec) {
                        total += rec.get('TotalSales');
                    });
                    this.setTitle(storeItem.get( 'Model' ) + ': ' + Math.round( storeItem.get( 'TotalSales' ) / total * 100 ) + '% (' + Ext.util.Format.usMoney( storeItem.get( 'TotalSales' ) ) + ')' );
                }
            },
            highlight: {
                segment: {
                    margin: 20
                }
            },
            label: {
                field: 'Model',
                display: 'rotate',
                contrast: true,
                font: '18px Arial'
            }
        }
    ]
});