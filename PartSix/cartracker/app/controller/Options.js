/**
 * Generic controller for managing simple options
 */
Ext.define('CarTracker.controller.Options', {
    extend: 'CarTracker.controller.Base',
    stores: [
        'option.Categories',
    	'option.Colors',
        'option.Features',
        'option.Positions',
        'option.Statuses',
        'option.Makes',
        'option.Models'
    ],
    views: [
    	'option.List'
    ],
    refs: [
    	{
            ref: 'OptionList',
            selector: '[xtype=option.list]'
        }
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {
            	'grid[xtype=option.list]': {
            		edit: this.save,
            		canceledit: this.cancel,
            		beforerender: this.loadRecords,
            		itemcontextmenu: this.showContextMenu
            	},
            	'grid[xtype=option.list] button#add': {
            		click: this.add
            	},
            	'grid[xtype=option.list] gridview': {
            		itemadd: this.edit
            	}
            },
            global: {},
            store: {},
            proxy: {} 
        });
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
    					text: 'Edit Item',
    					iconCls: 'icon_edit',
    					handler: function( item, e ) {
    						var grid = me.getOptionList(),
    							plugin = grid.editingPlugin;
    						// start row edit
    						plugin.startEdit( record, 0 );
    					}
    				},
                    {
                        text: 'Delete Item',
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
     * Loads the grid's store
     * @param {Ext.grid.Panel} grid
     * @param {Object} eOpts
     */
    loadRecords: function( grid, eOpts ) {
    	var me = this,
    		store = grid.getStore();
    	// clear any fliters that have been applied
    	store.clearFilter( true );
    	// load the store
    	store.load();
    },
    /**
     * Cancels the edit of a record
     * @param {Ext.grid.plugin.Editing} editor
     * @param {Object} context
     * @param {Object} eOpts
     */
    cancel: function( editor, context, eOpts ) {
    	// if the record is a phantom, remove from store and grid
    	if( context.record.phantom ) {
    		context.store.remove( context.record );
    	}
    },
    /**
     * Begins edit of selected record
     * @param {Ext.data.Model[]} records
     * @param {Number} index
     * @param {Object} node
     * @param {Object} eOpts
     */
    edit: function( records, index, node, eOpts ) {
    	var me = this,
    		grid = me.getOptionList(),
    		plugin = grid.editingPlugin;
    	// start edit of row
    	plugin.startEdit( records[ 0 ], 0 );
    },
    /**
     * Creates a new record and prepares it for editing
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    add: function( button, e, eOpts ) {
    	var me = this,
    		grid = me.getOptionList(),
    		plugin = grid.editingPlugin,
    		store = grid.getStore();
    	// if we're already editing, don't allow new record insert
    	if( plugin.editing ) {
    		// show error message
    		Ext.Msg.alert( 'Attention', 'Please finish editing before inserting a new record' );
    		return false;
    	}
    	store.insert( 0, {} );
    },
    /**
     * Displays context menu 
     * @param {Ext.grid.plugin.Editing} editor
     * @param {Object} context
     * @param {Object} eOpts
     */
    save: function( editor, context, eOpts ) {
    	var me = this,
    		store = context.record.store;
    	// save
    	store.sync();
    },
    /**
     * Displays context menu 
     * @param {Ext.data.Model[]} record
     */
    remove: function( record ) {
    	var me = this,
    		store = record.store;
    	// show confirmation before continuing
    	Ext.Msg.confirm( 'Attention', 'Are you sure you want to delete this item? This action cannot be undone.', function( buttonId, text, opt ) {
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
    }
});