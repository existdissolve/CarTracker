/**
 * @class CarTracker.ux.form.field.plugin.ClearTrigger
 * @extends Ext.AbstractPlugin
 * Plugin that adds the ability to clean an input field with a trigger class
 * @ptype cleartrigger
 */
 Ext.define('CarTracker.ux.form.field.plugin.ClearTrigger', {
 	extend: 'Ext.AbstractPlugin',
 	alias: 'plugin.cleartrigger',
 	constructor: function() {
 		var me = this;
 			me.callParent( arguments );
 		var field = me.getCmp();
 	},
 	init: function( field ) {
 		var me = this;
 		// combobox
 		if( field.isXType( 'combobox' ) || field.isXType( 'datefield' ) || field.isXType( 'timefield' ) ) {
 			field.trigger2Cls = 'x-form-clear-trigger';
 			field.onTrigger2Click = function() {
 				field.clearValue();
 			}
 		}
 		else {
 			field.triggerCls = 'x-form-clear-trigger';
 			field.onTriggerClick = function() {
 				field.reset();
 			}
 		}
 		me.callParent( arguments );
 	}
 });