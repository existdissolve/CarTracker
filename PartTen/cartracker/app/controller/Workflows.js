/**
 * Controller for all workflow-related management functionality
 */
Ext.define('CarTracker.controller.Workflows', {
    extend: 'CarTracker.controller.Base',
    stores: [
        'Workflows'
    ],
    /*views: [
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
    ],*/
    init: function() {
        this.listen({
            controller: {
                '#Workflows': {
                    approve: this.approveWorkflow,
                    reject: this.rejectWorkflow,
                    restart: this.restartWorkflow
                }
            },
            component: {},
            global: {},
            store: {},
            proxy: {} 
        });
    },
    approveWorkflow: function( view, record, item, index, e, eOpts ) {
        var me = this;
        me.handleWorkflowAction( 'Approve', record );
    },
    rejectWorkflow: function( view, record, item, index, e, eOpts ) {
        var me = this;
        me.handleWorkflowAction( 'Reject', record );
    },
    restartWorkflow: function( view, record, item, index, e, eOpts ) {
        var me = this;
        me.handleWorkflowAction( 'Restart', record );
    },
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
        Ext.Msg.prompt( 'Workflow Management', msg, function( buttonId, text, opt ){
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
        }, this, true );
    },
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