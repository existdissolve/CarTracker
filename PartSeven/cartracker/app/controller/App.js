/**
 * Main controller for all top-level application functionality
 */
Ext.define('CarTracker.controller.App', {
    extend: 'CarTracker.controller.Base',
    views: [
        'layout.Menu',
        'layout.Center',
        'layout.Landing'
    ],
    refs: [
        {
            ref: 'Menu',
            selector: '[xtype=layout.menu]'
        },
        {
            ref: 'CenterRegion',
            selector: '[xtype=layout.center]'
        }
    ],
    init: function() {
        this.listen({
            controller: {
                '#App': {
                    tokenchange: this.dispatch
                }
            },
            component: {
                'menu[xtype=layout.menu] menuitem': {
                    click: this.addHistory
                } 
            },
            global: {},
            store: {},
            proxy: {
                '#baserest': {
                    requestcomplete: this.handleRESTResponse
                }
            } 
        });
    },
    /**
     * Add history token to Ext.util.History
     * @param {Ext.menu.Item} item
     * @param {Object} e
     * @param {Object} opts
     */
    addHistory: function( item, e, opts ) {
        var me = this,
            token = item.itemId;
        if( !Ext.isEmpty( token ) ) {
            Ext.util.History.add( token );
            me.fireEvent( 'tokenchange', token )
        }
    },
    /**
     * Handles token change and directs creation of content in center region
     * @param {String} token
     */
    dispatch: function( token ) {
        var me = this,
            config;
        // switch on token to determine which content to create
        switch( token ) {
            case 'option/make':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Car Makes',
                    iconCls: 'icon_make',
                    store: Ext.create( 'CarTracker.store.option.Makes', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/model':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Car Models',
                    iconCls: 'icon_model',
                    store: Ext.create( 'CarTracker.store.option.Models', {
                        pageSize: 30
                    }),
                    extraColumns: {
                        text: 'Make',
                        dataIndex: 'Make',
                        renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                            return record.get( '_Make' )
                        },
                        editor: {
                            xtype: 'ux.form.field.remotecombobox',
                            displayField: 'LongName',
                            valueField: 'MakeID',
                            store: {
                                type: 'option.make'
                            },
                            allowBlank: false
                        }
                    }
                };
                break;
            case 'option/category':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Car Categories',
                    iconCls: 'icon_category',
                    store: Ext.create( 'CarTracker.store.option.Categories', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/color':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Car Colors',
                    iconCls: 'icon_color',
                    store: Ext.create( 'CarTracker.store.option.Colors', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/feature':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Car Features',
                    iconCls: 'icon_feature',
                    store: Ext.create( 'CarTracker.store.option.Features', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/position':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Staff Positions',
                    iconCls: 'icon_position',
                    store: Ext.create( 'CarTracker.store.option.Positions', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/status':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Statuses',
                    iconCls: 'icon_status',
                    store: Ext.create( 'CarTracker.store.option.Statuses', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/drivetrain':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Drive Trains',
                    iconCls: 'icon_drivetrain',
                    store: Ext.create( 'CarTracker.store.option.DriveTrains', {
                        pageSize: 30
                    })
                };
                break;
            case 'staff':
                config = {
                    xtype: 'staff.list'
                };
                break;
            case 'inventory':
                config = {
                    xtype: 'car.list'
                };
                break;
            default: 
                config = {
                    xtype: 'layout.landing'
                };
                break;
        }
        me.updateCenterRegion( config );
    },
    /**
     * Updates center region of app with passed configuration
     * @param {Object} config
     * @private
     */
    updateCenterRegion: function( config ) {
        var me = this,
            center = me.getCenterRegion();
        
        // remove all existing content
        center.removeAll( true );
        // add new content
        center.add( config );
    },
    /**
     * After a REST response is completed, this method will marshall the response data and inform other methods with relevant data
     * @param {Object} request
     * @param {Boolean} success The actual success of the AJAX request. For success of {@link Ext.data.Operation}, see success property of request.operation
     */
    handleRESTResponse: function( request, success ) {
        var me = this,
            rawData = request.proxy.reader.rawData;
        // in all cases, let's hide the body mask
        Ext.getBody().unmask();
        // if proxy success
        if( success ) {
            // if operation success
            if( request.operation.wasSuccessful() ) {

            }
            // if operation failure
            else {
                // switch on operation failure type
                switch( rawData.type ) {
                    case 'validation':
                        me.showValidationMessage( rawData.data, rawData.success, rawData.message, rawData.type );
                        break;
                }
            }
        }
        // otherwise, major failure...
        else {

        }
    },
    /**
     * Displays errors from JSON response and tries to mark offending fields as invalid
     * @param {CarTracker.proxy.Rest} proxy
     * @param {Array} data
     * @param {Boolean} success
     * @param {String} message
     * @param {String} type
     */
    showValidationMessage: function( data, success, message, type ) {
        var me = this,
            errorString = '<ul>';
        // looping over the errors
        for( var i in data ) {
            var error = data[ i ];
            errorString += '<li>' + error.message + '</li>';
            // match form field with same field name
            var fieldMatch = Ext.ComponentQuery.query( 'field[name=' + error.field + ']' );
            // match?
            if( fieldMatch.length ) {
                // add extra validaiton message to the offending field
                fieldMatch[ 0 ].markInvalid( error.message );
            }
        }
        errorString += '</ul>';
        // display error messages in modal alert
        Ext.Msg.alert( message, errorString );
    }
});