/**
 * Controller for all workflow-related management functionality
 */
Ext.define('CarTracker.controller.Workflows', {
    extend: 'CarTracker.controller.Base',
    stores: [
        'Workflows'
    ],
    views: [
        'workflow.List'
    ],
    refs: [
        {
            ref: 'WorkflowList',
            selector: '[xtype=workflow.list]'
        }
    ],
    init: function() {
        this.listen({
            controller: {
                '#Workflows': {
                    approve: this.approveWorkflow,
                    reject: this.rejectWorkflow,
                    restart: this.restartWorkflow,
                    view: this.showHistory
                }
            },
            component: {
                'grid[xtype=workflow.list]': {
                    beforerender: this.loadWorkflowHistory
                }
            },
            global: {},
            store: {},
            proxy: {} 
        });
    },
    /**
     * Loads workflow history store
     * @param {Ext.grid.Panel}
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    loadWorkflowHistory: function( grid, eOpts ) {
        var me = this,
            store = grid.getStore();

        store.getProxy().url = '/api/workflows/' + grid.CarID;
        store.load();
    },
    /**
     * Displays all workflow history for the selected Car
     * @param {Ext.view.View} view
     * @param {Ext.data.Record} record The record that belongs to the item
     * @param {HTMLElemen} item The item's element
     * @param {Number} index The item's index
     * @param {Ext.EventObject} e The raw event object
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    showHistory: function( view, record, item, index, e, eOpts ) {
        var me = this,
            win;
        // create ad-hoc window
        Ext.create('Ext.window.Window', {
            title: 'Workflow History',
            iconCls: 'icon_workflow',
            width: 600,
            maxHeight: 600,
            autoScroll: true,
            modal: true,
            y: 100,
            items: [
                {
                    xtype: 'workflow.list',
                    CarID: record.get( 'CarID' )
                }
            ]
        }).show();
    },
    /**
     * Submits an "Approve" workflow action
     * @param {Ext.view.View} view
     * @param {Ext.data.Record} record The record that belongs to the item
     * @param {HTMLElemen} item The item's element
     * @param {Number} index The item's index
     * @param {Ext.EventObject} e The raw event object
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    approveWorkflow: function( view, record, item, index, e, eOpts ) {
        var me = this;
        me.handleWorkflowAction( 'Approve', record );
    },
    /**
     * Submits a "Reject" workflow action
     * @param {Ext.view.View} view
     * @param {Ext.data.Record} record The record that belongs to the item
     * @param {HTMLElemen} item The item's element
     * @param {Number} index The item's index
     * @param {Ext.EventObject} e The raw event object
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    rejectWorkflow: function( view, record, item, index, e, eOpts ) {
        var me = this;
        me.handleWorkflowAction( 'Reject', record );
    },
    /**
     * Submits a "Restart" workflow action
     * @param {Ext.view.View} view
     * @param {Ext.data.Record} record The record that belongs to the item
     * @param {HTMLElemen} item The item's element
     * @param {Number} index The item's index
     * @param {Ext.EventObject} e The raw event object
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    restartWorkflow: function( view, record, item, index, e, eOpts ) {
        var me = this;
        me.handleWorkflowAction( 'Restart', record );
    },
    /**
     * Common interface for submitting workflow action to the server
     * @param {String} action
     * @param {Ext.data.Record} record
     */
    handleWorkflowAction: function( action, record ) {
        var me = this,
            msg;
        switch( action ) {
            case 'Approve':
            case 'Reject':
                msg = 'To <strong>' + action + '</strong> this workflow step, please enter a justification below.';
                break;
            case 'Restart':
                msg = 'To <strong>' + action + '</strong> the workflow for this record, please enter a justification below.';
                break;
        }
        Ext.Msg.minWidth=300;
        Ext.Msg.show({
            title: 'Workflow Management', 
            msg: msg, 
            fn: function( buttonId, text, opt ){
                if( buttonId=='ok' ) {
                    // make sure a message was entered
                    if( Ext.isEmpty( text ) ) {
                        Ext.Msg.alert( 'Attention', 'Please enter a justification for your action', function(){
                            me.handleWorkflowAction( action, record );
                        });                    
                        return false;
                    }
                    // send Ajax request with workflow action
                    Ext.Ajax.request({
                        url: '/api/workflows/' + record.get( 'CarID' ) + '.json',
                        method: 'PUT',
                        params: {
                            Status: record.get( 'Status' ),
                            Action: action,
                            Staff: CarTracker.LoggedInUser.get( 'StaffID' ),
                            Notes: text
                        },
                        success: function( response, opts ) {
                            // get new status for car
                            var result = Ext.decode( response.responseText );
                            // set record value to update record in grid
                            record.set( 'Status', result.data.Status );
                            record.set( '_Status', result.data._Status );
                        }
                    });
                }
            }, 
            scope: this, 
            width: 350,
            multiline: true,
            buttons: Ext.MessageBox.OKCANCEL
        });
    },
    /**
     * Handy method for checking whether the authenticated user has workflow permissions at a particular status
     * @param {Number} status
     */
    hasWorkflowPermission: function( status ) {
        var me = this,
            hasPermission = false,
            user = CarTracker.LoggedInUser;
        switch( status ) {
            case 4: // initiated
                hasPermission = user.inRole( 1 ) || user.inRole( 2 ) || user.inRole( 3 ) ? true : false;
                break;
            case 5: // in-audit
                hasPermission = user.inRole( 1 ) || user.inRole( 3 ) ? true : false;
                break;
            case 3: // in-review
            case 1: // approved
            case 2: // rejected
                hasPermission = user.inRole( 1 ) ? true : false;
                break;
        }
        return hasPermission;
    }
});