/**
* Handler for Statf Position Options
*/
component extends="CarTracker.handlers.Base" {
	property name="PositionService" inject;
	
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
		// retrieve positions based on search criteria
		var positions = PositionService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = positions.count,
			"data"  = EntityUtils.parseEntity( entity=positions.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get position based on passed id
		var position = PositionService.get( arguments.rc.PositionID );
		prc.jsonData = EntityUtils.parseEntity( entity=position, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate position
		var position = PositionService.populate( memento=arguments.rc );
		// save the position
		PositionService.save( position );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=position, simpleValues=true ),
			"success" = true,
			"message" = "The Position was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate position
		var position = PositionService.populate( memento=arguments.rc );
		// save the position
		PositionService.save( position );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=position, simpleValues=true ),
			"success" = true,
			"message" = "The Position was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		PositionService.deleteByID( arguments.rc.PositionID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Position was deleted successfully!"
		};
	}
}
