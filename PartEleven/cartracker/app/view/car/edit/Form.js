/**
 * Form used for creating and editing Staff Members
 */
Ext.define('CarTracker.view.car.edit.Form', {
    extend: 'Ext.form.Panel',
    alias: 'widget.car.edit.form',
    id: 'CarForm',
    requires: [
        'Ext.tab.Panel',
        'Ext.form.FieldContainer',
        'Ext.form.FieldSet',
        'Ext.form.field.Date',
        'Ext.form.field.Text',
        'Ext.form.field.ComboBox',
        'Ext.form.field.HtmlEditor',
        'Ext.form.field.File',
        'Ext.layout.container.Form',
        'Ext.ux.form.ItemSelector',
        'CarTracker.ux.form.field.RemoteComboBox',
        'CarTracker.ux.form.field.plugin.ClearTrigger',
        'CarTracker.view.car.edit.tab.Detail',
        'CarTracker.view.car.edit.tab.Feature',
        'CarTracker.view.car.edit.tab.Image'
    ],
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            fieldDefaults: {
                allowBlank: false,
                labelAlign: 'top',
                flex: 1,
                margins: 5
            },
            items: [
                {
                    xtype: 'tabpanel',
                    bodyPadding: 5,
                    // set to false to disable lazy render of non-active tabs...IMPORTANT!!!
                    deferredRender: false,
                    items: [
                        {
                            xtype: 'car.edit.tab.detail',
                            title: 'Details'
                        },
                        {
                            xtype: 'car.edit.tab.feature',
                            title: 'Available Features'
                        },
                        {
                            xtype: 'car.edit.tab.image',
                            title: 'Images'
                        }
                    ]
                }
            ]
        });
        me.callParent( arguments );
    }
});