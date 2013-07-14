Ext.define('CarTracker.view.security.login.Window', {
    extend: 'Ext.window.Window',
    alias: 'widget.security.login.window',
    title: 'Login to Car Tracker!',
    modal: true,
    layout: 'fit',
    resizable: false,
    closable: false,
    draggable: false,
    width: 300,
    bodyPadding: 10,
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'security.login.form'
                }
            ],
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'bottom',
                    ui: 'footer',
                    items: [
                        '->',
                        {
                            xtype: 'button',
                            text: 'Login',
                            itemId: 'login',
                            iconCls: 'icon_login'
                        }
                    ]
                }
            ]
        });
        me.callParent( arguments );
    }
});