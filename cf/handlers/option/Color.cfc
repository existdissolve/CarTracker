/**
* Handler for Car Color Options
*/
component extends="CarTracker.handlers.Base" {
	property name="ColorService" inject;
	
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {
		list="GET",
		view="GET",
		create="POST",
		update="PUT",
		remove="DELETE"
	};
	
	/**
	IMPLICIT FUNCTIONS: Uncomment to use
	function preHandler(event,action,eventArguments){
		var rc = event.getCollection();
	}
	function postHandler(event,action,eventArguments){
		var rc = event.getCollection();
	}
	function aroundHandler(event,targetAction,eventArguments){
		var rc = event.getCollection();
		// executed targeted action
		arguments.targetAction(event);
	}
	function onMissingAction(event,missingAction,eventArguments){
		var rc = event.getCollection();
	}
	function onError(event,faultAction,exception,eventArguments){
		var rc = event.getCollection();
	}
	*/
		
	function list( required Any event, required Struct rc, required Struct prc ){
		// retrieve colors based on search criteria
		var colors = ColorService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = colors.count,
			"data"  = EntityUtils.parseEntity( entity=colors.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get color based on passed id
		var color = ColorService.get( arguments.rc.ColorID );
		prc.jsonData = EntityUtils.parseEntity( entity=color, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate color
		var color = ColorService.populate( memento=arguments.rc );
		// save the color
		ColorService.save( color );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=color, simpleValues=true ),
			"success" = true,
			"message" = "The Color was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate color
		var color = ColorService.populate( memento=arguments.rc );
		// save the color
		ColorService.save( color );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=color, simpleValues=true ),
			"success" = true,
			"message" = "The Color was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		ColorService.deleteByID( arguments.rc.ColorID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Color was deleted successfully!"
		};
	}
}
