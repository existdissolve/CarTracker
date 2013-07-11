/**
* Handler for Cars
*/
component extends="CarTracker.handlers.Base" {
	property name="CarService" inject;
	property name="ORMService" inject="coldbox:plugin:ORMService";
	
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {
		make="GET"
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
		
	function make( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		var car = CarService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = car.count,
			"data"  = EntityUtils.parseEntity( entity=car.data, simpleValues=true, excludeList="Status,Make,Model,Category,Color,Features,SalesPeople" )
		};
	}

	function month( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		rc.sortOrder = "SaleDate ASC";
		var car = CarService.collect( argumentCollection=arguments.rc );
		// get results
		var results = EntityUtils.parseEntity( entity=car.data, simpleValues=true, excludeList="Status,Make,Model,Category,Color,Features,SalesPeople" );
		// set transformed variable
		var transformed = createObject( "java", "java.util.LinkedHashMap" ).init();
		// loop over results
		for( var sale in results ) {
			var month = monthAsString( month( sale[ 1 ] ) );
			if( !structKeyExists( transformed, month ) ) {
				transformed.put( month, {
					"Month" = month,
					"TotalSold" = sale[ 2 ],
					"TotalSales" = sale[ 3 ]
				});
			}
			else {
				transformed[ month ].TotalSold += sale[ 2 ];
				transformed[ month ].TotalSales += sale[ 3 ];
			}
		}
		var finalArray = [];
		for( var result in transformed ) {
			arrayAppend( finalArray, transformed[ result ] );
		}
		prc.jsonData = {
			"count" = arrayLen( finalArray ),
			"data"  = finalArray
		};
	}
}
