/**
 * Main panel for displaying images for {@link CarTracker.model.Car} records
 */
Ext.define('CarTracker.view.car.edit.tab.Image', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.car.edit.tab.image',
    bodyPadding: 10,
    margin:-5,
    initComponent: function() {
        var me = this;
        Ext.applyIf(me, {
            items: [
                {
                    xtype: 'dataview',
                    itemId: 'images',
                    tpl: [
                        '<tpl for=".">',
                            '<div class="thumb-wrap">',
                                '<div class="thumb"><img src="{Path}"></div>',
                            '</div>',
                        '</tpl>',
                        '<div class="x-clear"></div>'
                    ],
                    overItemCls: 'x-item-over',
                    itemSelector: 'div.thumb-wrap',
                    deferEmptyText: false,
                    emptyText: 'No images to display',
                    store: Ext.create('Ext.data.Store', {
                        fields: [ 'Path' ]
                    })
                }
            ],
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    ui: 'footer',
                    items: [
                        {
                            xtype: 'form',
                            itemId: 'uploadform',
                            border: false,
                            frame: false,
                            bodyPadding:0,
                            margins: '0 0 -5 0',
                            baseCls: 'x-plain',
                            items: [
                                {
                                    xtype: 'filefield',
                                    name: 'ImagePath',
                                    fieldLabel: 'Upload Photo',
                                    allowBlank: false, 
                                    fieldWidth: 300,
                                    buttonConfig: {
                                        iconCls: 'icon_picture',
                                        text: ''
                                    },
                                    labelAlign: 'left'
                                }
                            ]
                        },
                        {
                            xtype: 'button',
                            itemId: 'upload',
                            text: 'Upload'
                        }
                    ]
                }
            ]
        });
        me.callParent( arguments );
    }
})