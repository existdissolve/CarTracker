/**
* Handler for Car Model Options
*/
component extends="CarTracker.handlers.Base" {
	property name="ModelService" inject;
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
		// retrieve models based on search criteria
		var models = ModelService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = models.count,
			"data"  = EntityUtils.parseEntity( entity=models.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get model based on passed id
		var model = ModelService.get( arguments.rc.ModelID );
		prc.jsonData = EntityUtils.parseEntity( entity=model, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate model
		var model = ModelService.populate( memento=arguments.rc );
		if( structKeyExists( rc, "Make" ) ) {
			model.setMake( MakeService.get( rc.Make ) );
		}
		// save the model
		ModelService.save( model );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=model, simpleValues=true ),
			"success" = true,
			"message" = "The Model was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate model
		var model = ModelService.populate( memento=arguments.rc );
		if( structKeyExists( rc, "Make" ) ) {
			model.setMake( MakeService.get( rc.Make ) );
		}
		// save the model
		ModelService.save( model );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=model, simpleValues=true ),
			"success" = true,
			"message" = "The Model was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		ModelService.deleteByID( arguments.rc.ModelID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Model was deleted successfully!"
		};
	}
}
