/**
 * Controller for all car-related management functionality
 */
Ext.define('CarTracker.controller.Cars', {
    extend: 'CarTracker.controller.Base',
    stores: [
        'Cars',
        'Staff',
        'Images',
        'option.Makes',
        'option.Models',
        'option.Categories'
    ],
    views: [
        'car.List',
        'car.edit.Form',
        'car.edit.Window',
        'car.search.Form',
        'car.search.Window',
        'car.Detail'
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
        },
        {
            ref: 'CarImageView',
            selector: '[xtype=car.edit.tab.image]'
        },
        {
            ref: 'CarDetailWindow',
            selector: '[xtype=car.detail]'
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
                'form[xtype=car.edit.form] combobox[name=Make]': {
                    change: this.filterModel
                },
                'form[xtype=car.edit.form] combobox[name=Model]': {
                    beforequery: this.checkMake
                },
                'form[xtype=car.edit.form] button#upload': {
                    click: this.upload
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
                },
                '[xtype=car.edit.tab.image] dataview': {
                    itemcontextmenu: this.showImageContextMenu
                }
            },
            global: {},
            store: {},
            proxy: {} 
        });
    },
    /**
     * Interrupts Model combobox query to check if Make is defined
     * @param {Object} queryPlan
     * @param {Object} eOpts
     */
    checkMake: function( queryPlan, eOpts ) {
        var me = this,
            make = queryPlan.combo.up( 'form' ).down( '[name=Make]' );
        // don't allow selection until make is selected
        if( Ext.isEmpty( make.getValue() ) ) {
            Ext.Msg.alert( 'Please select a Make before choosing a Model' );
            // cancel query
            queryPlan.cancel = true;
        }
    },
    /**
     * Filters Model combobox based on selection in Make combobox
     * @param {Ext.form.field.ComboBox} combobox
     * @param {Object} newValue
     * @param {Object} oldValue
     * @param {Object} eOpts
     */
    filterModel: function( combobox, newValue, oldValue, eOpts ) {
        var me = this,
            model = combobox.up( 'form' ).down( '[name=Model]' ),
            store = model.getStore(),
            filters = [
                {
                    property: 'Make',
                    value: newValue
                }
            ];
        // clear filter
        store.clearFilter( true );
        // filter model
        store.filter( filters );
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
        // set up dynamic array of items, based on permissions, role, workflow status, etc.
        var items = [];
        // add edit options; workflow state-restricted
        if( me.application.getWorkflowsController().hasWorkflowPermission( record.get( 'Status' ) ) ) {
            // setup workflow actions
            switch( record.get( '_Status' ) ) {
                case 'In-Review':
                case 'In-Audit':
                    items.push({
                        text: 'Approve Workflow',
                        iconCls: 'icon_approve',
                        handler: function( item, e ) {
                            me.application.getWorkflowsController().fireEvent( 'approve', view, record, item, index, e, eOpts ); 
                        }
                    });
                    items.push({
                        text: 'Reject Workflow',
                        iconCls: 'icon_reject',
                        handler: function( item, e ) {
                            me.application.getWorkflowsController().fireEvent( 'reject', view, record, item, index, e, eOpts );
                        }
                    });
                    break;
                case 'Approved':
                case 'Rejected':
                    items.push({
                        text: 'Restart Workflow',
                        iconCls: 'icon_refresh',
                        handler: function( item, e ) {
                            me.application.getWorkflowsController().fireEvent( 'restart', view, record, item, index, e, eOpts ); 
                        }
                    });
                    break;
                case 'Initiated':
                    items.push({
                        text: 'Approve Workflow',
                        iconCls: 'icon_approve',
                        handler: function( item, e ) {
                            me.application.getWorkflowsController().fireEvent( 'approve', view, record, item, index, e, eOpts ); 
                        }
                    });
                    break;
            }
            items.push({
                text: 'Edit Car',
                iconCls: 'icon_edit',
                handler: function( item, e ) {
                    me.edit( view, record, item, index, e, eOpts );
                }
            });
        }
        // add view workflow option; no restrictions
        items.push({
            text: 'View Workflow History',
            iconCls: 'icon_workflow',
            handler: function( item, e ) {
                me.application.getWorkflowsController().fireEvent( 'view', view, record, item, index, e, eOpts );
            }
        });
        // add view option; no restrictions
        items.push({
            text: 'View Details',
            iconCls: 'icon_detail',
            handler: function( item, e ) {
                me.view( view, record, item, index, e, eOpts );
            }
        });
        // add delete option; admin role restriction
        if( CarTracker.LoggedInUser.inRole( 1 ) ) {
            items.push({
                text: 'Delete Car',
                iconCls: 'icon_delete',
                handler: function( item, e ) {
                    me.remove( record );
                }
            });
        }
        // add menu
        item.contextMenu = new Ext.menu.Menu({
            items: items
        })
        // show menu relative to item which was right-clicked
        item.contextMenu.showBy( item );
    },
    /**
     * Displays context menu for thumbnails
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record 
     * @param {HTMLElement} item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    showImageContextMenu: function( view, record, item, index, e, eOpts ) {
        var me = this;
        // stop event so browser's normal right-click action doesn't continue
        e.stopEvent();
        // if a menu doesn't already exist, create one
        if( !item.contextMenu ) {
            // add menu
            item.contextMenu = new Ext.menu.Menu({
                items: [
                    {
                        text: 'Remove Image',
                        iconCls: 'icon_delete',
                        handler: function( item, e ) {
                            me.removeImage( record );
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
     * Handles request to view details
     * @param {Ext.view.View} view
     * @param {Ext.data.Model} record 
     * @param {HTMLElement} item
     * @param {Number} index
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    view: function( view, record, item, index, e, eOpts ) {
        var me = this;
        // show window
        me.loadDetail( record, me, me.showDetailWindow );
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
            view = me.getCarImageView().down( 'dataview' ),
            callbacks;

        // get any images from image store
        values.ImagePaths = view.getStore().collect( 'Path' );
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
     * Removes record from store
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
            isNew = record.phantom,
            data = [];
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
        // prepare data for store
        data = me.prepareImageData( record.get( 'ImagePaths' ) );
        // load image view with data
        win.down( '#images' ).getStore().loadData( data );
    },
    /**
     * Displays details window for selected car
     * @param {Ext.data.Model} record
     */
    showDetailWindow: function( record ) {
        var me = this,
            win = me.getCarDetailWindow();
        // if window exists, show it; otherwise, create new instance
        if( !win ) {
            win = Ext.widget( 'car.detail', {
                title: 'Car Details'
            });
        }
        // show window
        win.show();
        // update data
        win.update( record.data );
    },
    /**
     * Manages uploading images
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    upload: function( button, e, eOpts ) {
        var me = this,
            form = button.up( 'form' ),
            image = form.down( '[name=ImagePath]' ),
            record = form.getRecord(),
            view = me.getCarImageView().down( 'dataview' ),
            uploadform = form.down( '#uploadform' );
        // validate upload
        if( Ext.isEmpty( image.getValue() ) ) {
            Ext.Msg.alert( 'Attention', 'Please choose an image' );
            return false;
        }
        // submit form
        uploadform.submit({
            url: '/api/images',
            params: {
                Car: record.get( 'CarID' ) ? record.get( 'CarID' ) : 'new',
                ImagePath: image.getValue()
            },
            waitMsg: 'Uploading Image...',
            success: function( form, action ) {
                // add new record to store
                view.getStore().add({
                    Path: action.result.data
                });
            },
            failure: function( form, action ) {
                Ext.Msg.alert( 'Uh-oh!', 'Sorry, there was an error uploading your file. Please make sure it is an image (.jpg, .gif, .png)' );
            } 
        })
    },
    /**
     * Removes record from store
     * @param {Ext.data.Model[]} record
     */
    removeImage: function( record ) {
        var me = this,
            dataview = me.getCarImageView().down( 'dataview' ),
            store = dataview.getStore();
        // remove the image
        store.remove( record );
    },
    /**
     * @private
     * Prepares raw image path data for store
     * @param {Array} paths
     */
    prepareImageData: function( paths ) {
        var data = [];
        Ext.Array.each( paths, function( item, index, allItems ) {
            if( !Ext.isEmpty( item ) ) {
                data.push({
                    'Path':item
                });    
            }
        });
        return data;
    }
});