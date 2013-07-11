component {
	property name="SessionStorage" inject="coldbox:plugin:SessionStorage";

	void function configure(){
	}
	
	void function preProcess( required Any event, required Struct interceptData){
		// check Session
		var User = SessionStorage.getVar( "User" );
		if( !isStruct( User ) && !listFindNoCase( "login,checklogin,index", event.getCurrentAction() ) ) {
			prc.jsonData = {
				"data"  = "",
				"success" = false,
				"message" = "Sorry, you must be logged in to access this site. You will now be redirected to the login screen",
				"type" = "notloggedin"
			};
			event.renderData( data=prc.jsonData, type="json" ).noExecution();
		}			
	}	
	
}