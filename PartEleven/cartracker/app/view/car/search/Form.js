/**
 * Form used for creating and editing Staff Members
 */
Ext.define('CarTracker.view.car.search.Form', {
    extend: 'Ext.form.Panel',
    alias: 'widget.car.search.form',
    requires: [
        'Ext.form.FieldContainer',
        'Ext.form.FieldSet',
        'Ext.form.field.Date',
        'Ext.form.field.Text',
        'Ext.form.field.ComboBox',
        'Ext.slider.Multi',
        'CarTracker.ux.form.field.RemoteComboBox',
        'CarTracker.ux.form.field.plugin.ClearTrigger'
    ],
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            fieldDefaults: {
                labelAlign: 'top',
                flex: 1,
                margins: 5
            },
            items: [
                {
                    xtype: 'fieldset',
                    title: 'Car Details',
                    collapsible: true,
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            items: [
                                {
                                    xtype: 'ux.form.field.remotecombobox',
                                    name: 'Make',
                                    fieldLabel: 'Make',
                                    displayField: 'LongName',
                                    valueField: 'MakeID',
                                    store: {
                                        type: 'option.make'
                                    },
                                    plugins: [
                                        { ptype: 'cleartrigger' }
                                    ],
                                    editable: false,
                                    forceSelection: true,
                                    multiSelect: true
                                },
                                {
                                    xtype: 'ux.form.field.remotecombobox',
                                    name: 'Model',
                                    fieldLabel: 'Model',
                                    displayField: 'LongName',
                                    valueField: 'ModelID',
                                    store: {
                                        type: 'option.model'
                                    },
                                    plugins: [
                                        { ptype: 'cleartrigger' }
                                    ],
                                    editable: false,
                                    forceSelection: true,
                                    multiSelect: true
                                }
                            ]    
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            items: [
                                {
                                    xtype: 'ux.form.field.remotecombobox',
                                    name: 'Status',
                                    fieldLabel: 'Status',
                                    displayField: 'LongName',
                                    valueField: 'StatusID',
                                    store: {
                                        type: 'option.status'
                                    },
                                    plugins: [
                                        { ptype: 'cleartrigger' }
                                    ],
                                    editable: false,
                                    forceSelection: true,
                                    multiSelect: true
                                },
                                {
                                    xtype: 'ux.form.field.remotecombobox',
                                    name: 'Category',
                                    fieldLabel: 'Category',
                                    displayField: 'LongName',
                                    valueField: 'CategoryID',
                                    store: {
                                        type: 'option.category'
                                    },
                                    plugins: [
                                        { ptype: 'cleartrigger' }
                                    ],
                                    editable: false,
                                    forceSelection: true,
                                    multiSelect: true
                                }
                            ]    
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            items: [
                                {
                                    xtype: 'multislider',
                                    name: 'ListPrice',
                                    fieldLabel: 'List Price',
                                    minValue: 0,
                                    maxValue: 60000,
                                    increment: 500,
                                    values: [ 5000, 30000]
                                }
                            ]    
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            items: [
                                {
                                    xtype: 'datefield',
                                    name: 'AcquisitionStartDate',
                                    fieldLabel: 'Acquisition (Start)'
                                },
                                {
                                    xtype: 'datefield',
                                    name: 'AcquisitionEndDate',
                                    fieldLabel: 'Acquisition (End)'
                                }
                            ]    
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: 'Car Options',
                    collapsible: true,
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            items: [
                                {
                                    xtype: 'ux.form.field.remotecombobox',
                                    name: 'Color',
                                    fieldLabel: 'Color',
                                    displayField: 'LongName',
                                    valueField: 'ColorID',
                                    store: {
                                        type: 'option.color'
                                    },
                                    plugins: [
                                        { ptype: 'cleartrigger' }
                                    ],
                                    editable: false,
                                    forceSelection: true,
                                    multiSelect: true
                                },
                                {
                                    xtype: 'ux.form.field.remotecombobox',
                                    name: 'Features',
                                    fieldLabel: 'Features',
                                    displayField: 'LongName',
                                    valueField: 'FeatureID',
                                    store: {
                                        type: 'option.feature'
                                    },
                                    plugins: [
                                        { ptype: 'cleartrigger' }
                                    ],
                                    editable: false,
                                    forceSelection: true,
                                    multiSelect: true
                                }
                            ]    
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: 'Sales',
                    collapsible: true,
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            items: [
                                {
                                    xtype: 'multislider',
                                    name: 'SalePrice',
                                    fieldLabel: 'Sale Price',
                                    minValue: 0,
                                    maxValue: 60000,
                                    increment: 500,
                                    values: [ 5000, 30000]
                                }
                            ]    
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            items: [
                                {
                                    xtype: 'datefield',
                                    name: 'SaleStartDate',
                                    fieldLabel: 'Sale Date (Start)'
                                },
                                {
                                    xtype: 'datefield',
                                    name: 'SaleEndDate',
                                    fieldLabel: 'Sale Date (End)'
                                }
                            ]    
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            items: [
                                {
                                    xtype: 'ux.form.field.remotecombobox',
                                    name: 'SalesPeople',
                                    fieldLabel: 'Sales Person',
                                    displayField: 'LastName',
                                    valueField: 'StaffID',
                                    store: {
                                        type: 'staff'
                                    },
                                    plugins: [
                                        { ptype: 'cleartrigger' }
                                    ],
                                    editable: false,
                                    forceSelection: true,
                                    multiSelect: true
                                },
                                {
                                    xtype: 'ux.form.field.remotecombobox',
                                    name: 'Position',
                                    fieldLabel: 'Position',
                                    displayField: 'LongName',
                                    valueField: 'PositionID',
                                    store: {
                                        type: 'option.position'
                                    },
                                    plugins: [
                                        { ptype: 'cleartrigger' }
                                    ],
                                    editable: false,
                                    forceSelection: true,
                                    multiSelect: true
                                }
                            ]    
                        }
                    ]
                }
            ]
        });
        me.callParent( arguments );
    }
});