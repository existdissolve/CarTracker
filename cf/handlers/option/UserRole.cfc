/**
* Handler for UserRole Options
*/
component extends="CarTracker.handlers.Base" {
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
		// retrieve userroles based on search criteria
		var userroles = UserRoleService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = userroles.count,
			"data"  = EntityUtils.parseEntity( entity=userroles.data, simpleValues=true )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get userrole based on passed id
		var userrole = UserRoleService.get( arguments.rc.UserRoleID );
		prc.jsonData = EntityUtils.parseEntity( entity=userrole, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate userrole
		var userrole = UserRoleService.populate( memento=arguments.rc );
		// save the userrole
		UserRoleService.save( userrole );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=userrole, simpleValues=true ),
			"success" = true,
			"message" = "The User Role was created successfully!"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate userrole
		var userrole = UserRoleService.populate( memento=arguments.rc );
		// save the userrole
		UserRoleService.save( userrole );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=userrole, simpleValues=true ),
			"success" = true,
			"message" = "The User Role was updated successfully!"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		UserRoleService.deleteByID( arguments.rc.UserRoleID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The User Role was deleted successfully!"
		};
	}
}
