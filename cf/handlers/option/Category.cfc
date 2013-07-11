/**
* Handler for Car Category Options
*/
component extends="CarTracker.handlers.Base" {
	property name="CategoryService" inject;
	
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
		// retrieve Categorys based on search criteria
		var categories = CategoryService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = categories.count,
			"data"  = EntityUtils.parseEntity( entity=categories.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get category based on passed id
		var category = CategoryService.get( arguments.rc.CategoryID );
		prc.jsonData = EntityUtils.parseEntity( entity=category, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate category
		var category = CategoryService.populate( memento=arguments.rc );
		// save the category
		CategoryService.save( category );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=category, simpleValues=true ),
			"success" = true,
			"message" = "The Category was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate category
		var category = CategoryService.populate( memento=arguments.rc );
		// save the category
		CategoryService.save( category );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=category, simpleValues=true ),
			"success" = true,
			"message" = "The Category was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		CategoryService.deleteByID( arguments.rc.CategoryID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Category was deleted successfully!"
		};
	}
}
