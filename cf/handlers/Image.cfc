/**
* Handler for Cars
*/
component extends="CarTracker.handlers.Base" {
	property name="CarService" inject;
	property name="FileService" inject="coldbox:plugin:FileUtils";
	
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
		upload="POST"
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
	public String function upload( required Any event, required Struct rc, required Struct prc ) {
		try {
			var folder = expandPath( "includes/images/cars/#rc.Car#" );
			if( !directoryExists( folder )  ) {
				directoryCreate( folder );
			}
			var newFile = FileService.uploadFile( fileField="ImagePath", destination=folder, nameConflict="overwrite" );
			prc.jsonData = {
				"success" = true,
				"message" = "File was uploaded successfully!",
				"data" = "/includes/images/cars/#rc.Car#/" & newFile.serverFilename & "." & newFile.serverFileExt
			};
		}
		catch( Any e ) {
			writedump( e );
			abort;
			prc.jsonData = {
				"success" = false,
				"message" = "File could not be uploaded",
				"data" = ""
			};
		}
	}
}
