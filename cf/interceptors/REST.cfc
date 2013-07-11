component hint="Helps prepare REST-style requests for life in the big ColdBox" extends="coldbox.system.Interceptor" output="false" {
	/**
     * Happens _after_ FORM and URL are added in to request collection, this will add PUT and DELETE content into RC as well
     * @event {Any} The current request context
     * @interceptData {Struct} Data that can be manipulated
     */
     public void function onRequestCapture( required Any event, required Struct interceptData ) {
     	var verb = arguments.event.getHttpMethod();
     	var content= toString( arguments.event.getHttpContent() );
     	var rc=		 arguments.event.getCollection( true );
     	// switch on HTTP verb
     	switch( verb ) {
     		// for PUT and DELETE
     		case "PUT":
     		case "DELETE":
            case "POST":
     			// if there is content
     			if( len( content ) ) {
     				// attempt to parse any variables in the content
     				var params = parseParams( content );
     				// if we get back a structure of values
     				if( isStruct( params ) ) {
     					// loop over it and set key/value pairs into rc
     					for( var key in params ) {
                            try {
                                event.setValue( key, params[ key ] );
                            }
                            catch( any e ) {}
     					}
     				}
     			}
     			break;
     		// for GET
     		case "GET":
     			// attempt to parse serialized filter criteria coming from AJAX
     			if( structKeyExists( rc, "filter" ) && isJSON( rc.filter ) ) {
                	event.setValue( "criteria", getCriteria( filterArgs=rc.filter ) );
               	}
                if( structKeyExists( rc, "sortorder" ) && isJSON( rc.sortOrder ) ) {
                	event.setValue( "sortOrder", getSorterOrder( sortArgs=rc.sortOrder ) );
                }
        		break;
     	}
     }
     /**
      * Parses the httpContent of PUT and DELETE requests
      * @content {String} The HTTPContent of the request
      * returns Struct
      */
     private Struct function parseParams( required String content ) {
     	var collection = {};
     	// if query string, parse into key/value pairs
     	if( !isJSON( arguments.content ) ) {
     		// split at ampersand
     		var params = listToArray( arguments.content, "&" );
     		// loop over list
     		for( var param in params ) {
     			// split key/value pair at "="
     			var paramParts = listToArray( param, "=" );
     			var key = paramParts[ 1 ];
     			var value = arrayIsDefined( paramParts, 2 ) ? URLDecode( paramParts[ 2 ] ) : "";
     			// set collection key to the value
     			
     			// if the value is JSON, deserialize
     			if( isJSON( value ) ) {
     				// test deserialization
     				var desValue = deserializeJSON( value );
     				// if array or struct, use value
     				if( isArray( desValue ) || isStruct( desValue ) ) {
     					collection[ key ] = desValue;
     				}
     				// otherwise, just use plain text
     				else {
     					collection[ key ] = value;
     				}
     			}
     			// not JSON, use plain value
     			else {
     				collection[ key ] = value;
     			}
     		}
     	}
        else {
            collection = deserializeJSON( arguments.content );
        }
     	return collection;
     }
     
     /**
      * Deserializes JSON filter param into CF array
      * @filterArg {String} The JSON string representing the filter array
      * returns Array
      */
     private Array function getCriteria( required String filterArgs ) {
     	return deserializeJSON( arguments.filterArgs ); 
     }
     
     /**
      * Deserializes JSON sortorder param into usable string
      * @sortArg {String} The JSON string representing the sortable config
      * returns String
      */
     private String function getSorterOrder( required String sortArgs ) {
     	var sorter = deserializeJSON( arguments.sortArgs );
     	var sortOrder = "";
     	for( var sort in sorter ) {
     		if( listContainsNoCase( "ASC,DESC", sort.direction) ) {
     			sortOrder = listAppend( sortOrder, "#sort.property# #sort.direction#" );
     		}
     	} 
		return sortOrder;
	}
}