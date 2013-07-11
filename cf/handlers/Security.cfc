/**
* Handler for Staff
*/
component extends="CarTracker.handlers.Base" {
	property name="SessionStorage" inject="coldbox:plugin:SessionStorage";
	property name="StaffService" inject;
	
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {
		login="POST",
		checklogin="GET",
		logout="GET"
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

	function login( required Any event, required Struct rc, required Struct prc ){
		// check user
		if( structKeyExists( rc, "Username" ) && structKeyExists( rc, "Password" ) ) {
			// try to match staff member to login credentials
			var staff = StaffService.findWhere( criteria={ Username=rc.Username, Password=rc.Password } );
			// if we found a staff member
			if( !isNull( staff ) ) {
				var roles = [];
				// get user roles
				for( role in staff.getUserRoles() ) {
					arrayAppend( roles, role.getUserRoleID() );
				}
				var UserDetails = {
					"FirstName" = staff.getFirstName(),
					"LastName" = staff.getLastName(),
					"Username" = staff.getUsername(),
					"StaffID" = staff.getStaffID(),
					"Roles" = roles
				};
				// set session
				SessionStorage.setVar( "User", UserDetails );
				prc.jsonData = {
					"data"  = UserDetails,
					"success" = true,
					"message" = "You have logged in successfully!",
					"type" = "success"
				};
				return;
			}
			else {
				prc.jsonData = {
					"data"  = "",
					"success" = false,
					"message" = "Sorry, we couldn't validate your account. Please try logging in again.",
					"type" = "loginerror"
				};
				return;
			}
		}
		else {
			prc.jsonData = {
				"data"  = "",
				"success" = false,
				"message" = "Sorry, we couldn't validate your account. Please try logging in again.",
				"type" = "loginerror"
			};
			return;
		}		
	}

	function logout( required Any event, required Struct rc, required Struct prc ) {
		structClear( session );
		prc.jsonData = {
			"data"  = "",
			"success" = false,
			"message" = "You have been successfully logged out",
			"type" = "logout"
		};
	}

	function checkLogin( required Any event, required Struct rc, required Struct prc ) {
		var User = SessionStorage.getVar( "User" );
		var success = false;
		if( isStruct( User ) ) {
			success = true;
		}
		prc.jsonData = {
			"data"  = User,
			"success" = success,
			"message" = "",
			"type" = "logincheck"
		};
	}
}
