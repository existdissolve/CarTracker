/**
* Handler for Staff
*/
component extends="CarTracker.handlers.Base" {
	property name="StaffService" inject;
	property name="PositionService" inject;
	property name="UserRoleService" inject;
	
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
		// retrieve Staffs based on search criteria
		var staff = StaffService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = staff.count,
			"data"  = EntityUtils.parseEntity( entity=staff.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get staff based on passed id
		var staff = StaffService.get( arguments.rc.StaffID );
		prc.jsonData = EntityUtils.parseEntity( entity=staff, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate staff
		var staff = StaffService.populate( memento=arguments.rc, exclude="UserRoles" );
		if( structKeyExists( rc, "Position" ) ) {
			staff.setPosition( PositionService.get( rc.Position ) );
		}
		if( structKeyExists( rc, "UserRoles" ) ) {
			for( var role in rc.UserRoles ) {
				staff.addUserRole( UserRoleService.get( role ) );
			}
		}
		// validate model
		prc.validationResults = validateModel( staff );
		// if there are errors, handle it
		if( prc.validationResults.hasErrors() ) {
			prc.jsonData = {
				"data" = errorsToArray( prc.validationResults.getErrors() ),
				"success" = false,
				"message" = "Please correct the following errors",
				"type" = "validation"
			};
			return;
		}
		// save the staff
		StaffService.save( staff );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=staff, simpleValues=true ),
			"success" = true,
			"message" = "The Staff Member was created successfully!",
			"type" = "success"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate staff
		var staff = StaffService.populate( memento=arguments.rc, exclude="UserRoles" );
		if( structKeyExists( rc, "Position" ) ) {
			staff.setPosition( PositionService.get( rc.Position ) );
		}
		if( structKeyExists( rc, "UserRoles" ) ) {
			staff.getUserRoles().clear();
			for( var role in rc.UserRoles ) {
				staff.addUserRole( UserRoleService.get( role ) );
			}
		}
		// validate model
		prc.validationResults = validateModel( staff );
		// if there are errors, handle it
		if( prc.validationResults.hasErrors() ) {
			prc.jsonData = {
				"data" = errorsToArray( prc.validationResults.getErrors() ),
				"success" = false,
				"message" = "Please correct the following errors",
				"type" = "validation"
			};
			return;
		}
		// save the staff
		StaffService.save( staff );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=staff, simpleValues=true ),
			"success" = true,
			"message" = "The Staff Member was updated successfully!",
			"type" = "success"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		StaffService.deleteByID( arguments.rc.StaffID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Staff Member was deleted successfully!",
			"type" = "success"
		};
	}
}
