/**
 * Override for {@link Ext.grid.RowEditor}. Fixes lack of change event on editor fields
 */
Ext.define('overrides.grid.RowEditor', {
    override: 'Ext.grid.RowEditor',
    addFieldsForColumn: function(column, initial) {
        var me = this,
            i,
            length, field;

        if (Ext.isArray(column)) {
            for (i = 0, length = column.length; i < length; i++) {
                me.addFieldsForColumn(column[i], initial);
            }
            return;
        }

        if (column.getEditor) {

            // Get a default display field if necessary
            field = column.getEditor(null, {
                xtype: 'displayfield',
                // Override Field's implementation so that the default display fields will not return values. This is done because
                // the display field will pick up column renderers from the grid.
                getModelData: function() {
                    return null;
                }
            });

            // BEGIN OVERRIDE
            me.mon( field, 'change', me.onFieldChange, me );
            // END OVERRIDE

            if (column.align === 'right') {
                field.fieldStyle = 'text-align:right';
            }

            if (column.xtype === 'actioncolumn') {
                field.fieldCls += ' ' + Ext.baseCSSPrefix + 'form-action-col-field'
            }

            if (me.isVisible() && me.context) {
                if (field.is('displayfield')) {
                    me.renderColumnData(field, me.context.record, column);
                } else {
                    field.suspendEvents();
                    field.setValue(me.context.record.get(column.dataIndex));
                    field.resumeEvents();
                }
            }
            if (column.hidden) {
                me.onColumnHide(column);
            } else if (column.rendered && !initial) {
                // Setting after initial render
                me.onColumnShow(column);
            }
        }
    }
});