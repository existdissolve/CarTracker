/**
 * @class CarTracker
 * @singleton
 */
/*
    This file is generated and updated by Sencha Cmd. You can edit this file as
    needed for your application, but these edits will have to be merged by
    Sencha Cmd when it performs code generation tasks such as generating new
    models, controllers or views and when running "sencha app upgrade".

    Ideally changes to this file would be limited and most work would be done
    in other places (such as Controllers). If Sencha Cmd cannot merge your
    changes and its generated code, it will produce a "merge conflict" that you
    will need to resolve manually.
*/

// DO NOT DELETE - this directive is required for Sencha Cmd packages to work.
//@require @packageOverrides
Ext.util.Format.yesNo = function( v ) {
    return v ? 'Yes' : 'No';
};

Ext.application({
    name: 'CarTracker',
    views: [
        'Viewport'
    ],
    controllers: [
        'App',
        'Options',
        'Staff',
        'Cars',
        'Security'
    ],
    requires: [
        'Ext.util.History',
        'Ext.util.Point',
        'CarTracker.domain.Proxy',
        'overrides.grid.RowEditor'
    ],
    /**
     * launch is called immediately upon availability of our app
     */
    launch: function( args ) {
        // "this" = Ext.app.Application
        var me = this;
        Ext.globalEvents.fireEvent( 'beforeviewportrender' );        
    }
});
