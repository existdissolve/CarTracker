/**
 * Controller for all security functionality
 */
Ext.define('CarTracker.controller.Security', {
    extend: 'CarTracker.controller.Base',
    requires: [
        'CarTracker.security.crypto.SHA1'
    ],
    models: [
        'security.User'
    ],
    views: [
        'security.login.Form',
        'security.login.Window'
    ],
    refs: [
        {
            ref: 'LoginForm',
            selector: '[xtype=security.login.form]'
        },
        {
            ref: 'LoginWindow',
            selector: '[xtype=security.login.window]'
        }
    ],
    init: function() {
        this.listen({
            controller: {},
            component: {
                '[xtype=security.login.window] button#login': {
                    click: this.doLogin
                },
                'menu[xtype=layout.menu] menuitem#logout': {
                    click: this.doLogout
                } 
            },
            global: {
                beforeviewportrender: this.processLoggedIn
            },
            store: {},
            proxy: {} 
        });
    },
    /**
     * Main method process security check
     */
    processLoggedIn: function() {
        var me = this;
        // make remote request to check session
        Ext.Ajax.request({
            url: '/security/checklogin',
            success: function( response, options ) {
                // decode response
                var result = Ext.decode( response.responseText );
                // check if success flag is true
                if( result.success ) {
                    // has session...add to application stack
                    CarTracker.LoggedInUser = Ext.create( 'CarTracker.model.security.User', result.data );
                    // fire global event aftervalidateloggedin
                    Ext.globalEvents.fireEvent( 'aftervalidateloggedin' );
                } 
                // couldn't login...show error
                else {
                    Ext.widget( 'security.login.window' ).show();
                }
            },
            failure: function( response, options ) {
                Ext.Msg.alert( 'Attention', 'Sorry, an error occurred during your request. Please try again.' );
            }
        })
    },
    /**
     * Handles form submission for login
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    doLogin: function( button, e, eOpts ) {
        var me = this,
            win = button.up( 'window' ),
            form = win.down( 'form' ),
            values = form.getValues(),
            hashedPassword;
        // simple validation
        if( Ext.isEmpty( values.Username ) || Ext.isEmpty( values.Password ) ) {
            Ext.Msg.alert( 'Attention', 'Please complete the login form!' );
            return false;
        }
        Ext.Ajax.request({
            url: '/security/login',
            params: {
                Username: values.Username,
                Password: CarTracker.security.crypto.SHA1.hash( values.Password )
            },
            success: function( response, options ) {
                // decode response
                var result = Ext.decode( response.responseText );
                // check if success flag is true
                if( result.success ) {
                    // has session...add to application stack
                    CarTracker.LoggedInUser = Ext.create( 'CarTracker.model.security.User', result.data );
                    // fire global event aftervalidateloggedin
                    Ext.globalEvents.fireEvent( 'aftervalidateloggedin' );
                    // show message
                    Ext.Msg.alert( 'Attention', 'You successfully logged in. Welcome to Car Tracker!!' );
                    // close window
                    win.close();
                } 
                // couldn't login...show error
                else {
                    Ext.Msg.alert( 'Attention', result.message );
                }
            },
            failure: function( response, options ) {
                Ext.Msg.alert( 'Attention', 'Sorry, an error occurred during your request. Please try again.' );
            }
        });
    },
    /**
     * Handles logout
     * @param {Ext.button.Button} button
     * @param {Ext.EventObject} e
     * @param {Object} eOpts
     */
    doLogout: function( button, e, eOpts ) {
        var me = this;
        Ext.Msg.confirm( 'Attention', 'Are you sure you want to logout of Car Tracker?', function( button ) {
            if( button=='yes' ) {
                Ext.Ajax.request({
                    url: '/security/logout',
                    method: 'GET',
                    success: function( response, options ) {
                        window.location.reload( true );
                    },
                    failure: function( response, options ) {
                        Ext.Msg.alert( 'Attention', 'Sorry, an error occurred during your request. Please try again.' );
                    }
                });                
            }
        });
    }
});