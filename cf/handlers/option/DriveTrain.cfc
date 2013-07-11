/**
* Handler for Car DriveTrain Options
*/
component extends="CarTracker.handlers.Base" {
	property name="DriveTrainService" inject;
	
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
		// retrieve drivetrains based on search criteria
		var drivetrains = DriveTrainService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = drivetrains.count,
			"data"  = EntityUtils.parseEntity( entity=drivetrains.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get drivetrain based on passed id
		var drivetrain = DriveTrainService.get( arguments.rc.DriveTrainID );
		prc.jsonData = EntityUtils.parseEntity( entity=drivetrain, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate drivetrain
		var drivetrain = DriveTrainService.populate( memento=arguments.rc );
		// save the drivetrain
		DriveTrainService.save( drivetrain );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=drivetrain, simpleValues=true ),
			"success" = true,
			"message" = "The Drive Train was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate drivetrain
		var drivetrain = DriveTrainService.populate( memento=arguments.rc );
		// save the drivetrain
		DriveTrainService.save( drivetrain );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=drivetrain, simpleValues=true ),
			"success" = true,
			"message" = "The Drive Train was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		DriveTrainService.deleteByID( arguments.rc.DriveTrainID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Drive Train was deleted successfully!"
		};
	}
}
