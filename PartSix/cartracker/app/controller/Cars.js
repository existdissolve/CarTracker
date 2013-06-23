/**
 * Controller for all car-related management functionality
 */
Ext.define('CarTracker.controller.Cars', {
    extend: 'CarTracker.controller.Base',
    stores: [
        'Cars',
        'Staff',
        'option.Makes',
        'option.Models',
        'option.Categories'
    ],
    views: [
        'car.List',
        'car.edit.Form',
        'car.edit.Window',
        'car.search.Form',
        'car.search.Window'
    ],
    refs: [
        {
            ref: 'CarList',
            selector: '[xtype=car.list]'
        },
        {
            ref: 'CarEditWindow',
            selector: '[xtype=car.edit.window]'
        },
        {
            ref: 'CarEditForm',
            selector: '[xtype=car.edit.form]'
        },
        {
            ref: 'CarSearchWindow',
            selector: '[xtype=car.search.window]'
        },
        {
            ref: 'CarSearchForm',
            selector: '[xtype=car.search.form]'
        }
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {
                'grid[xtype=car.list]': {
                    beforerender: this.loadRecords,
                    itemdblclick: this.edit,
                    itemcontextmenu: this.showContextMenu
                },
                'grid[xtype=car.list] button#add': {
                    click: this.add
                },
                'grid[xtype=car.list] button#search': {
                    click: this.showSearch
                },
                'grid[xtype=car.list] button#clear': {
                    click: this.clearSearch
                },
                'form[xtype=car.edit.form] itemselectorfield': {
                    beforerender: this.loadRecords
                },
                'window[xtype=car.edit.window] button#save': {
                    click: this.save
                },
                'window[xtype=car.edit.window] button#cancel': {
                    click: this.close
                },
                'window[xtype=car.search.window] button#search': {
                    click: this.search
                },
                'window[xtype=car.search.window] button#cancel': {
                    click: this.close
                }
            },
            global: {},
            store: {},
            proxy: {} 
        });
    },
    /**
     * Clears search form and resets results
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    clearSearch: function( button, e, eOpts ) {
        var me = this,
            grid = me.getCarList(),
            store = grid.getStore();
        // clear filter
        store.clearFilter( false );
    },
    /**
     * Displays search form
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    showSearch: function( button, e, eOpts ) {
        var me = this,
            win = me.getCarSearchWindow();
        // if window exists, show it; otherwise, create new instance
        if( !win ) {
            win = Ext.widget( 'car.search.window', {
                title: 'Search Inventory'
            });
        }
        // show window
        win.show();
    },
    /**
     * Executes search
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    search: function( button, e, eOpts ) {
        var me = this,
            win = me.getCarSearchWindow(),
            form = win.down( 'form' ),
            grid = me.getCarList(),
            store = grid.getStore(),
            values = form.getValues(),
            filters=[];
        // loop over values to create filters
        Ext.Object.each( values, function( key, value, myself ) {
            if( !Ext.isEmpty( value ) ) {
                filters.push({
                    property: key,
                    value: value
                })
            }
        });
        // clear store filters
        store.clearFilter( true );
        store.filter( filters );
        // close window
        win.hide();
    },
    /**
     * Displays context menu 
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record 
     * @param {HTMLElement} item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    showContextMenu: function( view, record, item, index, e, eOpts ) {
        var me = this;
        // stop event so browser's normal right-click action doesn't continue
        e.stopEvent();
        // if a menu doesn't already exist, create one
        if( !item.contextMenu ) {
            // add menu
            item.contextMenu = new Ext.menu.Menu({
                items: [
                    {
                        text: 'Edit Car',
                        iconCls: 'icon_edit',
                        handler: function( item, e ) {
                            me.edit( view, record, item, index, e, eOpts );
                        }
                    },
                    {
                        text: 'Delete Car',
                        iconCls: 'icon_delete',
                        handler: function( item, e ) {
                            me.remove( record );
                        }
                    }
                ]
            })
        }
        // show menu relative to item which was right-clicked
        item.contextMenu.showBy( item );
    },
    /**
     * Loads the component's store
     * @param {Ext.grid.Panel} grid
     * @param {Object} eOpts
     */
    loadRecords: function( cmp, eOpts ) {
        var me = this,
            store = cmp.getStore();
        // clear any fliters that have been applied
        store.clearFilter( true );
        // load the store
        store.load();
    },
    /**
     * Handles request to edit
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record 
     * @param {HTMLElement} item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    edit: function( view, record, item, index, e, eOpts ) {
        var me = this;
        // show window
        me.loadDetail( record, me, me.showEditWindow );
    },
    /**
     * Creates a new record and prepares it for editing
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    add: function( button, e, eOpts ) {
        var me = this,
            record = Ext.create( 'CarTracker.model.Car' );
        // show window
        me.showEditWindow( record );
    },
    /**
     * Persists edited record
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    save: function( button, e, eOpts ) {
        var me = this,
            grid = me.getCarList(),
            store = grid.getStore(),
            win = button.up( 'window' ),
            form = win.down( 'form' ),
            record = form.getRecord(),
            values = form.getValues(),
            callbacks;

        // set values of record from form
        record.set( values );
        // check if form is even dirty...if not, just close window and stop everything...nothing to see here
        if( !record.dirty ) {
            win.close();
            return;
        }
        // setup generic callback config for create/save methods
        callbacks ={
            success: function( records, operation ) {
                win.close();
            },
            failure: function( records, operation ) {
                // if failure, reject changes in store
                store.rejectChanges();
            }
        };
        // mask to prevent extra submits
        Ext.getBody().mask( 'Saving Car...' );
        // if new record...
        if( record.phantom ) {
            // reject any other changes
            store.rejectChanges();
            // add the new record
            store.add( record );
        }
        // persist the record
        store.sync( callbacks );
    },
    /**
     * Persists edited record
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    close: function( button, e, eOpts ) {
        var me = this,
            win = button.up( 'window' );
        // close the window
        win.close();
    },
    /**
     * Displays context menu 
     * @param {Ext.data.Model[]} record
     */
    remove: function( record ) {
        var me = this,
            store = record.store;
        // show confirmation before continuing
        Ext.Msg.confirm( 'Attention', 'Are you sure you want to delete this Car? This action cannot be undone.', function( buttonId, text, opt ) {
            if( buttonId=='yes' ) {
                store.remove( record );
                store.sync({
                    /**
                     * On failure, add record back to store at correct index
                     * @param {Ext.data.Model[]} records
                     * @param {Ext.data.Operation} operation
                     */
                    failure: function( records, operation ) {
                        store.rejectChanges();
                    }
                })
            }
        })
    },
    /**
     * Displays common editing form for add/edit operations
     * @param {Ext.data.Model} record
     */
    showEditWindow: function( record ) {
        var me = this,
            win = me.getCarEditWindow(),
            isNew = record.phantom;
        // if window exists, show it; otherwise, create new instance
        if( !win ) {
            win = Ext.widget( 'car.edit.window', {
                title: isNew ? 'Add Car' : 'Edit Car'
            });
        }
        // show window
        win.show();
        // load form with data
        win.down( 'form' ).loadRecord( record );
    }
});