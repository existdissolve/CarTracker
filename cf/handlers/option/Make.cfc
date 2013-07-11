/**
* Handler for Car Make Options
*/
component extends="CarTracker.handlers.Base" {
	property name="MakeService" inject;
	
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
		// retrieve makes based on search criteria
		var makes = MakeService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = makes.count,
			"data"  = EntityUtils.parseEntity( entity=makes.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get make based on passed id
		var make = MakeService.get( arguments.rc.MakeID );
		prc.jsonData = EntityUtils.parseEntity( entity=make, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate make
		var make = MakeService.populate( memento=arguments.rc );
		// save the make
		MakeService.save( make );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=make, simpleValues=true ),
			"success" = true,
			"message" = "The Make was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate make
		var make = MakeService.populate( memento=arguments.rc );
		// save the make
		MakeService.save( make );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=make, simpleValues=true ),
			"success" = true,
			"message" = "The Make was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		MakeService.deleteByID( arguments.rc.MakeID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Make was deleted successfully!"
		};
	}
}
