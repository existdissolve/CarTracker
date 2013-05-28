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
                    exception: function( proxy, response, operation, eOpts ) {
                        console.log( 'Danger Will Robinson! We had a proxy error!' );
                    }
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
        Ext.util.History.add( token );
        me.fireEvent( 'tokenchange', token )
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
            case 'staff':
                config = {
                    xtype: 'panel',
                    title: 'Staff',
                    html: 'Some staff content'
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
            case 'inventory':
                config = {
                    xtype: 'panel',
                    title: 'Inventory',
                    html: 'Some inventory content' 
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
    }
});