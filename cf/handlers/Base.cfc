/**
* Base Handler
*/
component {
	property name="EntityUtils" inject="coldbox:myplugin:EntityUtils";
	
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};
	
	function preHandler( required Any event, required Struct rc, required Struct prc ){
		if( structKeyExists( arguments.rc, "query" ) ) {
			if( structKeyExists( arguments.rc, "criteria" ) && isArray( arguments.rc.criteria ) ) {
				arrayAppend( arguments.rc.criteria, {
					"property"="query",
					"value"=arguments.rc.query
				});
			}
			else {
				arguments.rc.criteria[ "query" ] = arguments.rc.query;
			}
		}
	}

	function postHandler( required Any event, required Struct rc, required Struct prc ){
		if( structKeyExists( arguments.prc, "jsonData" ) ) {
			arguments.event.renderData( data=arguments.prc.jsonData, type="json" );
		}
	}

	public Array function errorsToArray( required Array errors ) {
		var legiterrors = [];
		for( var error in arguments.errors ) {
			arrayAppend( legiterrors, {
				"field" = error.getField(),
				"message" = error.getMessage()
			});
		}
		return legiterrors;
	}
}
