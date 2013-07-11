/**
* Handler for Car Feature Options
*/
component extends="CarTracker.handlers.Base" {
	property name="FeatureService" inject;
	
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
		// retrieve features based on search criteria
		var features = FeatureService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = features.count,
			"data"  = EntityUtils.parseEntity( entity=features.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get feature based on passed id
		var feature = FeatureService.get( arguments.rc.FeatureID );
		prc.jsonData = EntityUtils.parseEntity( entity=feature, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate feature
		var feature = FeatureService.populate( memento=arguments.rc );
		// save the feature
		FeatureService.save( feature );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=feature, simpleValues=true ),
			"success" = true,
			"message" = "The Feature was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate feature
		var feature = FeatureService.populate( memento=arguments.rc );
		// save the feature
		FeatureService.save( feature );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=feature, simpleValues=true ),
			"success" = true,
			"message" = "The Feature was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		FeatureService.deleteByID( arguments.rc.FeatureID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Feature was deleted successfully!"
		};
	}
}
