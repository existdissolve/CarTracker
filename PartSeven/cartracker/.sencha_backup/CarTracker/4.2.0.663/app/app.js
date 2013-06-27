/**
 * @class CarTracker
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

Ext.application({
    name: 'CarTracker',
    views: [
        'Viewport'
    ],
    controllers: [
        'App'
    ],
    requires: [
        'Ext.util.History'
    ],
    autoCreateViewport: true,
    /**
     * launch is called immediately upon availability of our app
     */
    launch: function( args ) {
        // "this" = Ext.app.Application
        var me = this;
        // init Ext.util.History on app launch; if there is a hash in the url,
        // our controller will load the appropriate content
        Ext.util.History.init(function(){
            var hash = document.location.hash;
            me.getAppController().fireEvent( 'tokenchange', hash.replace( '#', '' ) );
        })
        // add change handler for Ext.util.History; when a change in the token
        // occurs, this will fire our controller's event to load the appropriate content
        Ext.util.History.on( 'change', function( token ){
            me.getAppController().fireEvent( 'tokenchange', token );
        });
    }
});
