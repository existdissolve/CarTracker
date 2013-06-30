/**
 * Form used for creating and editing Staff Members
 */
Ext.define('CarTracker.view.staff.edit.Form', {
    extend: 'Ext.form.Panel',
    alias: 'widget.staff.edit.form',
    requires: [
        'Ext.form.FieldContainer',
        'Ext.form.field.Date',
        'Ext.form.field.Text',
        'Ext.form.field.ComboBox',
        'CarTracker.ux.form.field.RemoteComboBox'
    ],
    bodyPadding: 5,
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            fieldDefaults: {
                allowBlank: false,
                labelAlign: 'top',
                flex: 1,
                margins: 5
            },
            defaults: {
                layout: 'hbox',
                margins: '0 10 0 10'                
            },
            items: [
                {
                    xtype: 'fieldcontainer',
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'FirstName',
                            fieldLabel: 'First Name'
                        },
                        {
                            xtype: 'textfield',
                            name: 'LastName',
                            fieldLabel: 'Last Name'
                        },
                        {
                            xtype: 'datefield',
                            name: 'DOB',
                            fieldLabel: 'DOB'
                        }
                    ]
                },
                {
                    xtype: 'fieldcontainer',
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'Username',
                            fieldLabel: 'Username'
                        }
                    ]
                },
                {
                    xtype: 'fieldcontainer',
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'Address1',
                            fieldLabel: 'Address1'
                        },
                        {
                            xtype: 'textfield',
                            name: 'Address2',
                            allowBlank: true,
                            fieldLabel: 'Address2'
                        }
                    ]
                },
                {
                    xtype: 'fieldcontainer',
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'City',
                            fieldLabel: 'City'
                        },
                        {
                            xtype: 'textfield',
                            name: 'State',
                            fieldLabel: 'State'
                        },
                        {
                            xtype: 'textfield',
                            name: 'PostalCode',
                            fieldLabel: 'Postal Code'
                        }
                    ]
                },
                {
                    xtype: 'fieldcontainer',
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'Phone',
                            fieldLabel: 'Phone'
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
                            editable: false,
                            forceSelection: true
                        },
                        {
                            xtype: 'datefield',
                            name: 'HireDate',
                            allowBlank: false,
                            fieldLabel: 'Hire Date'
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: 'Admin Roles',
                    items: [
                        {
                            xtype: 'itemselectorfield',
                            name: 'UserRoles',
                            anchor: '100%',
                            store: {
                                type: 'option.userrole'
                            },
                            displayField: 'LongName',
                            valueField: 'UserRoleID',
                            allowBlank: false,
                            msgTarget: 'side',
                            fromTitle: 'Available Roles',
                            toTitle: 'Selected Roles',
                            buttons: [ 'add', 'remove' ],
                            delimiter: null
                        }
                    ]
                }
            ]
        });
        me.callParent( arguments );
    }
});