/**
* Handler for Status Options
*/
component extends="CarTracker.handlers.Base" {
	property name="StatusService" inject;
	
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
		// retrieve statuss based on search criteria
		var statuses = StatusService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = statuses.count,
			"data"  = EntityUtils.parseEntity( entity=statuses.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get status based on passed id
		var status = StatusService.get( arguments.rc.StatusID );
		prc.jsonData = EntityUtils.parseEntity( entity=status, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate status
		var status = StatusService.populate( memento=arguments.rc );
		// save the status
		StatusService.save( status );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=status, simpleValues=true ),
			"success" = true,
			"message" = "The Status was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate status
		var status = StatusService.populate( memento=arguments.rc );
		// save the status
		StatusService.save( status );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=status, simpleValues=true ),
			"success" = true,
			"message" = "The Status was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		StatusService.deleteByID( arguments.rc.StatusID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Status was deleted successfully!"
		};
	}
}
