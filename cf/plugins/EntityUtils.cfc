component name="EntityUtils" displayName="EntityUtils" extends="coldbox.system.plugin" cache="true" {
	property name="ORMService" inject="coldbox:plugin:ORMService";
	
	public any function init() {
		return this;	
	}
	
	/*
	 *	this method recursively creates an object mapping of an entity to overcome the "2-deep" limitation of serializeJSON
	 *	@entity 	The Entity to parse
	 *	@objCache 	Cache of nested objects to track in order to avoid infinite recursion
	 *	@simpleValues Whether or not to return only simple values [false]
	 *	@excludeList List of properties to ignore
	 *	@includeList List of properties to exclusively include
	 *	@prefix		String to prepend to property name in returned structure
	 *	@decorations Array of structs, or list of property names that should be flattended to the top level of the entity
	 *				 NOTE: properties MUST be defined on the parent entity
	 *	returns any
	 */
	public any function parseEntity ( required any entity, required array objCache=[], required boolean simpleValues=false, string excludeList="", string includeList="", string prefix="", any decorations="", required keyMapping={} ) {
		// set of entities to return
		local.entities = [];
		// whether the entity is an array, or a single object
		local.isSingle = false;
		var i = "";
		var j = "";
		var k = "";
		var excludes = arguments.excludeList;
		var includes = arguments.includeList;
		// if the passed entity is NOT an array of objects, create an array with a single item (the passed entity)
		// this will help consistify the way in which the object is traversed
		if( !isArray( arguments.entity ) ) {
			// set isSingle to true so we know what kind of data to return
			local.isSingle = true;
			arguments.entity = [ arguments.entity ];	
		}
		// loop over array of entities
		for( i in arguments.entity ) {
			// if the entry is an array, this is the result of a projection on an entity; just return the results as-is
			if( isArray( i ) || isSimpleValue( i ) || isStruct( i ) ) {
				var tempMeta = getMetaData( i );
				if( !structKeyExists( tempMeta, "EntityName" ) ) {
					return entity;	
				}
			}
			var fullMeta = getMetaData( i );
			// get meta data properties for the current entity
			local.meta = cleanArray( fullMeta.properties );
			// if using mapped super class, add in extra properties
			if( structKeyExists( fullMeta, "extends" ) && isStruct( fullMeta.extends ) && structKeyExists( fullMeta.extends, "properties" ) ) {
				local.meta.addAll( cleanArray( fullMeta.extends.properties ) );
			}
			// local.data will store the data for this level
			local.data = {};
			// loop over the properties
			for( j in local.meta ) {
				var pop = true;
				// include list?
				if( listLen( includes ) and !listFindNoCase( includes, j.name ) ) {
					pop = false;
				}
				// exclude list?
				if( listLen( excludes ) and listFindNoCase( excludes, j.name ) ) {
					pop = false;
				}
				// only include if not excluded or, optionally, if exclusively included
				if( pop ) {
					local.keyname = structKeyExists( arguments.keyMapping, j.name ) ? arguments.prefix & arguments.keyMapping[ j.name ] : arguments.prefix & j.name;
					// retrieve the value for the property
					local.theval = evaluate( "i." & "get#j.name#()" );
					// make sure the variable is defined
					if( isDefined( "local.theval" ) ) {
						// if it's a simple value (e.g., not a relationship), set the value
						if( isSimpleValue( local.theval ) ) {
							local.data[ local.keyname ] = local.theval;
						}
						// if it's NOT a simple value, we need to recurse this method, retrieving the values for the relationships
						else {
							// check the object cache to see if this object has already been traversed
							// if it is, we want to stop so we don't infinitely recurse this object
							if( !arrayFindNoCase( arguments.objcache, local.theval ) ) {
								// add object to object cache, which we'll pass into the recursing method
								arrayappend( arguments.objcache, local.theval );
								// check if simplevalues is set
								if( arguments.simpleValues ) {
									// if result is array
									if( isArray( local.theval ) ) {
										local.arraydata = [];
										if( arrayLen( local.theval ) ) {
											for( var k in local.theval ) {
												arrayAppend( local.arraydata, getPKValue( k ) );	
											}
										}
										local.data[ local.keyname ] = local.arraydata;
									}
									else {
										local.data[ local.keyname ] = getPKValue( local.theval );
									}
								}
								else {
									// recursively call this method, passing in the current entity (which is a relationship of some kind)
									local.data[ local.keyname ] = parseEntity( entity=local.theval, objcache=arguments.objcache, simpleValues=arguments.simpleValues, excludeList=excludes, includeList=includes );
								}
							}
							else {
								// check if simplevalues is set
								if( arguments.simpleValues ) {
									// if result is array
									if( isArray( local.theval ) ) {
										local.arraydata = [];
										if( arrayLen( local.theval ) ) {
											for( var k in local.theval ) {
												arrayAppend( local.arraydata, getPKValue( k ) );	
											}
										}
										local.data[ local.keyname ] = local.arraydata;
									}
									else {
										local.data[ local.keyname ] = getPKValue( local.theval );
									}
								}
								else {
									local.data[ local.keyname ] = local.theval;
								}	
							}
						}
					}
					// otherwise, just set an empty string
					else {
						local.data[ local.keyname ] = "";	
					}
				}
				// decorate object with meta from passed entities
				if( isArray( arguments.decorations ) || arguments.decorations != "" ) {
					if( !isArray( arguments.decorations ) ) {
						arguments.decorations = listToArray( arguments.decorations );	
					}
					for( var decoratordef in arguments.decorations ) {
						// get decorated properties (struct) for definition
						local.decoratedProperties = decorateProperty( entity=i, options=decoratordef );
						// if decorated properties is an array, need to do a bit differently
						if( isArray( local.decoratedProperties ) ) {
							var postDecoratedProperties = {};
							// loop over decorated properties array
							for( var decorated in local.decoratedProperties ) {
								// loop over keys in array element
								for( var propertykey in decorated ) {
									// if the key doesn't exist, create it and set it to an empty array
									if( !structKeyExists( postDecoratedProperties, propertykey ) ) {
										postDecoratedProperties[ propertykey ] = [];	
									}
									// append value of current property key loop to main array at the specified key
									arrayAppend( postDecoratedProperties[ propertykey ], decorated[ propertykey ] );	
								}
							}
							// add struct to existing data structure
							structAppend( local.data, postDecoratedProperties, true );	
						}
						else {
							// add struct to existing data structure
							structAppend( local.data, local.decoratedProperties, true );
						}
					}
				}
			}
			// add the composed structure of values to the array
			arrayAppend( local.entities, local.data );	
		}
		// if this was originally a single entity, just return the entity; otherwise, return the array of entities
		return local.isSingle ? local.entities[ 1 ] : local.entities;
	}
	
	public any function transform( required any data, required string transformerPath ) {
		var Transformer = createObject( "component", arguments.transformerPath ).init();
		return Transformer.transform( data=arguments.data );	
	}
	
	private any function decorateProperty( required any entity, required struct options ) {
		local.data = arguments.entity;
		// get config from arguments
		local.config = {
			property = isStruct( arguments.options ) && structKeyExists( arguments.options, "property" ) ? arguments.options.property : arguments.options,
			prefix = isStruct( arguments.options ) && structKeyExists( arguments.options, "prefix" ) ? arguments.options.prefix : "",
			simpleValues = isStruct( arguments.options ) && structKeyExists( arguments.options, "simpleValues" ) ? arguments.options.simpleValues : false,
			excludeList = isStruct( arguments.options ) && structKeyExists( arguments.options, "excludeList" ) ? arguments.options.excludeList : "",
			includeList = isStruct( arguments.options ) && structKeyExists( arguments.options, "includeList" ) ? arguments.options.includeList : "",
			keyMapping = isStruct( arguments.options ) && structKeyExists( arguments.options, "keyMapping" ) ? arguments.options.keyMapping : {}
		};
		try {
			// retrieve the value for the decorated property
			var resolutionPath = "";
			for( var i=1; i<=listLen( local.config.property, "." ); i++ ) {
				var path = listGetAt( local.config.property, i, "." );
				if( i < listLen( local.config.property, "." ) ) {
					resolutionPath &= "get#path#().";	
				}
				else {
					resolutionPath &= "get#path#()";
				}
				
			}
			local.decorator = evaluate( "local.data." & "#resolutionPath#" );
			local.data = parseEntity( 
				entity=local.decorator, 
				simpleValues=local.config.simpleValues, 
				excludeList=local.config.excludeList, 
				includeList=local.config.includeList, 
				prefix=local.config.prefix, 
				keyMapping=local.config.keyMapping 
			);
		}
		catch ( Any error ) {
			local.data = {};	
		}
		
		return local.data;
	}
	
	public struct function getRelationalEntities( required Any target, required Struct memento ) {
		var meta = getMetaData( arguments.target );
		var properties = meta.properties;
		var mappings = [];
		// loop over all properties in the entity
		for( var i=1; i<=arrayLen( properties ); i++ ) {
			var def = properties[ i ];
			// if property is a complex type and not the id field...
			if( structKeyExists( def, "fieldtype") && structKeyExists( arguments.memento, def.name ) && def.fieldtype != "id" ) {
				// get value for property from memento
				var value = isJSON( arguments.memento[ def.name ] ) ? deserializeJSON( arguments.memento[ def.name ] ) : arguments.memento[ def.name ];
				// if one-to-many relationships, create an array of values
				if( def.fieldtype == "one-to-many" && isSimpleValue( value ) ) {
					value = listToArray( value );
					// add to array of property mappings
					arrayAppend( mappings, {
						property = def.name,
						table = listLast( def.cfc, "." ),
						value = value
					});
				}
			}
		}
		relationships = realizeRelationships( mappings );
	}

	public struct function realizeRelationships( required Array relationshipMappings ) {
		local.relationships = {};
		for( var relation in arguments.relationshipMappings ) {
			if( isArray( relation.value ) ) {
				local.relationships[ relation.property ] = [];
				for( var child in relation.value ) {
					if( isSimpleValue( child ) ) {
						var tmp = ORMService.exists( relation.table, child ) ? ORMService.get( relation.table, child ) : "";	
						arrayAppend( local.relationships[ relation.property ], tmp );
					}
					else {
						arrayAppend( local.relationships[ relation.property ], child );	
					}
				}
			}
			else {
				if( isSimpleValue( relation.value ) && relation.value != "" ) {
					local.relationships[ relation.property ] = ORMService.exists( relation.table, relation.value ) ? ORMService.get( relation.table, relation.value ) : "";
				}
				else {
					local.relationships[ relation.property ] = relation.value;	
				}
			}
		}
		return local.relationships;
	}
	
	public any function getPKValue( required any entity ) {
		local.childmeta = cleanArray( getMetaData( arguments.entity ).properties );
		for( var i in local.childmeta ) {
			if( structKeyExists( i, "fieldtype" ) && i.fieldtype=="id" ) {
				return evaluate( "arguments.entity.get#i.name#()" );	
			}	
		}	
	}
	
	/*
	 *    this method gets the right data type for a column
	 *    @value	the value to be analyzed
	 *    returns   string
	 */
	private string function getDataType( required string value ) {
		// if numeric
		if(isNumeric( arguments.value )) {
			// if integer
			if(arguments.value == round( arguments.value )) {
				// if boolean
				if(isBoolean( arguments.value ) && !isNumeric( arguments.value )) {
					return "bit";
				}
				// else is integer
				else {
					return "integer";
				}
			}
			// else is double
			else {
				return "double";
			}
		}
		// not numeric
		else {
			// if date
			if(isDate( arguments.value )) {
				return "date";
			}
			// else is varchar
			else {
				return "varchar";
			}
		}
	}
	
	/*
	 *    this method converts datatyped-value to a passable data type
	 *    @value	the value to be converted
	 *    returns   string
	 */
	private string function convertDataType( required string value ) {
		switch(arguments.value) {
				// if boolean, cast to bit
			case "boolean":
				local.datatype = "bit";
				break;
				// if float, cast to double
			case "float":
				local.datatype = "double";
				break;
			case "string":
				local.datatype = "varchar";
				break;
				// otherwise, just use the given value
			default:
				local.datatype = arguments.value;
				break;
		}
		return local.datatype;
	}
	
	/*
	 *	this method turns fake arrays into iterable arrays
	 *	@array 	The array to transform
	 *	returns any
	 */
	private array function cleanArray( required Array array ) {
		local.i	= "";
		local.newArray = [];
		for( local.i=1; local.i<=arrayLen( arguments.array ); local.i++ ) {
			arrayAppend( local.newArray, arguments.array[ local.i ] );	
		}
		return local.newArray;
	}
	
	/*
	 *    this method converts an array of entities into a fully-datatyped query object
	 *    @data		the array of entities to be converted
	 *    returns   query
	 */
	public query function entityToQuery( required array data, required Any columnInflaters="", required Any columnTransformers={} ) {
		local.query = queryNew( "" );
		local.columns = [];
		var inflaters = parseInflaters( arguments.columnInflaters );
		var transformers = parseTransformers( arguments.columnTransformers );
		// set up max value
		local.max = arrayLen( arguments.data ) > 10 ? 10 : arrayLen( arguments.data );
		// create placeholder array with the correct dimensions based on columns in the first returned entity
		for(k = 1; k <= arrayLen( getMetaData( arguments.data[1] ).properties ); k++) {
			var meta = getMetaData( arguments.data[1] ).properties;
			// only add columns that are simple values; can't do child entities
			if( !structKeyExists( meta[ k ], "fieldtype" ) || ( structKeyExists( meta[ k ], "fieldtype" ) && meta[ k ].fieldtype=="id" ) ) {
				arrayAppend( local.columns, { name=meta[ k ].name, alias=meta[ k ].name, type="" } );
			}
			if( arrayLen( inflaters.inflatables ) ) {
				if( isArray( arguments.columnInflaters ) ) {
					for( var i=1; i<=arrayLen( inflaters.inflatables ); i++ ) {
						if( inflaters.inflatables[ i ] == meta[ k ].name ) {
							var inflaterName = arguments.columnInflaters[ i ].column;
							var inflaterAlias= structKeyExists( arguments.columnInflaters[ i ], "alias" ) ? arguments.columnInflaters[ i ].alias : inflaterName;
							arrayAppend( local.columns, { name=inflaterName, alias=inflaterAlias, type="", parent=meta[ k ].name } );	
						}	
					}	
				}
				else {
					if( arrayContains( inflaters.inflatables, meta[ k ].name	 ) ) {
						arrayAppend( local.columns, { name=meta[ k ].name, alias=meta[ k ].name, type="", parent=meta[ k ].name } );
					}
				}
			}
		}
		for(i = 1; i <= local.max; i++) {
			// loop over the columns we've identified
			var parentmeta = getMetaData( arguments.data[ i ] ).properties;	
			var entity = arguments.data[i];
			for( var col in local.columns ) {
				// find the meta value for this	
				for( var j=1; j<=arrayLen( parentmeta ); j++ ) {
					var prop = parentmeta[ j ];
					if( prop.name == col.name ) {
						var meta = prop;
						break;
					}	
					else {
						var meta = "";	
					}
				}
				if( !isSimpleValue( meta ) ) {
					// if type is already defined, just use it
					if(structKeyExists( meta, "type" )) {
						col.type = listAppend( col.type, meta.type );
					}
					else if( structKeyExists( meta, "ormtype" ) ) {
						col.type = listAppend( col.type, meta.ormtype );	
					}
					// otherwise, we need to try to figure it out
					else {
						var val = "";
						// if property has "fieldtype" specified
						if(structKeyExists( meta, "fieldtype" )) {
							// only include it if it's of type "id"; otherwise, skip
							if( meta.fieldtype == "id" ) {
								val = evaluate( "entity." & "get#meta.name#()" );
								col.type = listAppend( col.type, getDataType( val ) );
							}
						}
						// otherwise, this is a regular column with no dependencies
						else {
							val = evaluate( "entity." & "get#meta.name#()" );
							if( isDefined( "val" ) && val != "" ) {
								col.type = listAppend( col.type, getDataType( val ) );	
							}
						}
					}	
				}
			}
		}
		// loop over the columns that we've culled
		for(x = 1; x <= arrayLen( local.columns ); x++) {
			local.datatype = {};
			// remove dupes by converting list to struct
			for(y = 1; y <= listLen( local.columns[x].type ); y++) {
				local.datatype[listGetAt( local.columns[x].type, y )] = listGetAt( local.columns[x].type, y );
			}
			local.datatype = structCount( local.datatype ) == 1 ? convertDataType( structKeyList( local.datatype ) ) : "varchar";
			// add a column to our fake query
			queryAddColumn( local.query, local.columns[x].alias, local.datatype, [] );
		}
		// now loop over all "rows" in our entity collection
		for(z = 1; z <= arrayLen( arguments.data ); z++) {
			local.meta = getMetaData( arguments.data[z] ).properties;
			local.entity = arguments.data[z];
			// add a new row to the fake query
			queryAddRow( local.query );
			// loop over the properties of the entity, and set the matching column with its data
			for(a = 1; a <= arrayLen( local.columns ); a++) {
				// only set column values for those columns which exist in the query
				if( structKeyExists( local.query, local.columns[a].alias ) ) {
					// check if there are inflaters that need to be processed
					if( arrayContains( inflaters.inflaterCols, local.columns[a].name ) && structKeyExists( local.columns[ a ], "parent" ) ) {
						// get the child property value
						var realvalue = evaluate( "local.entity." & "get#local.columns[ a ].parent#()" );
						var cellValue = "";
						// if there is no value, the "getXXXXX()" will return undefined...so check for it
						if( isDefined( "realvalue" ) ) {
							var inflaterprop = inflaters.inflaterProps[ arrayFindNoCase( inflaters.inflaterCols, local.columns[a].name ) ];
							var inflaterpath = inflaters.inflaterPaths[ arrayFindNoCase( inflaters.inflaterCols, local.columns[a].name ) ];
								inflaterpath = inflaterpath == 0 ? "" : inflaterpath & "().get";
							// for one-to-many's, roll over array	
							if( isArray( realvalue ) ) {
								for( var item in realvalue ) {
									cellValue = listAppend( cellValue, evaluate( "item.get#inflaterpath##inflaterprop#()" ) );	
								}	
							}
							// for many-to-one's, just get value
							else {			
								// check if inflater path is something					
								if( inflaterpath != "" ) {
									// remove added ".get" from inflater path
									var fixedpath = left( inflaterpath, len( inflaterpath )-4 );
									// make sure that the entity exists at the root path
									var inflaterval = evaluate( "realvalue.get#fixedpath#" );
									// if the entity exists, get the value
									if( isDefined( "inflaterval" ) ) {
										cellValue = listAppend( cellValue, evaluate( "realvalue.get#inflaterpath##inflaterprop#()" ) );	
									}
									// otherwise, just return na
									else {
										cellValue = "N/A";
									}
								}
								// if inflater path is empty (default), just get the property
								else {
									cellValue = listAppend( cellValue, evaluate( "realvalue.get#inflaterprop#()" ) );
								}
							}
							querySetCell( local.query, local.columns[a].alias, cellvalue );
						}
						// if there is no value, just enter "N/A"
						else {
							querySetCell( local.query, local.columns[a].alias, "N/A" );
						}
					}
					// otherwise, just evaluate columns
					else {
						querySetCell( local.query, local.columns[a].alias, evaluate( "local.entity." & "get#local.columns[ a ].name#()" ) );
					}
				}
			}
		}
		local.query = transformColumns( query=local.query, transformers=transformers );
		return local.query;
	}
	
	private struct function parseInflaters( required Any columnInflaters ) {
		var inflaters = {
			inflatables = [],
			inflaterProps =[],
			inflaterCols = [],
			inflaterPaths = []
		};
		if( isArray( arguments.columnInflaters ) ) {
			for( var inf in arguments.columnInflaters ) {
				arrayAppend( inflaters.inflatables, inf.child );
				arrayAppend( inflaters.inflaterProps, inf.property );
				arrayAppend( inflaters.inflaterCols, inf.column );
				arrayAppend( inflaters.inflaterPaths, structKeyExists( inf, "path" ) ? inf.path : 0 );
			} 	
		}
		else {
			for( var inf in arguments.columnInflaters ) {
				arrayAppend( inflaters.inflatables, inf );
				arrayAppend( inflaters.inflaterProps, arguments.columnInflaters[ inf ] );	
				arrayAppend( inflaters.inflaterCols, inf );
				arrayAppend( inflaters.inflaterPaths, 0 );
			}	
		}
		return inflaters;	
	}
	
	private struct function parseTransformers( required Any columnTransformers ) {
		var transformers = { column = [], fn = [], criteria= [] };
		if( isArray( arguments.columnTransformers ) ) {
			for( var trans in arguments.columnTransformers ) {
				arrayAppend( transformers.column, trans.column );
				arrayAppend( transformers.fn, trans.transformer );
				arrayAppend( transformers.criteria, structKeyExists( trans, "criteria" ) ? trans.criteria : "" );
			} 	
		}/*
		else {
			for( var trans in arguments.columnTransformers ) {
				arrayAppend( transformers.column, trans );
				arrayAppend( transformers.fn, arguments.columnTransformers[ trans ] );
				if( structKeyExists( trans, "transformerArguments" ) ) {
					arrayAppend( transformers.criteria, arguments.columnTransformers[ trans ] );
				}
				else {
					arrayAppend( transformers.criteria, "" );	
				}
			}	
		}*/
		return transformers;	
	}
	
	private query function transformColumns( required query query, required Any transformers ) {
		var thequery = arguments.query;
		var cols = thequery.columnList;
		for( var i=1; i<=thequery.recordCount; i++ ) {
			for( var c=1; c<=arrayLen( arguments.transformers.column ); c++ ) {
				var column = listGetAt( cols, listFindNoCase( cols, arguments.transformers.column[ c ] ) );
				if( column != "" ) {
					var val = thequery[ column ][ i ];
					var fn = transformers.fn[ c ];
					switch( fn ) {
						case "ucase": case "lcase":
							val = evaluate( "#fn#( val )" );
							break;
						case "conditional":
							var criteria = arguments.transformers.criteria[ c ];
							var primaryColumn = thequery[ criteria.primary ][ i ];
							var altColumn = "";
							if( listLen( criteria.alt, "|" ) > 1 ) {
								for( var x=1; x<=listLen( criteria.alt, "|" ); x++ ) {
									var col = thequery[ listGetAt( criteria.alt, x, "|" ) ][ i ];
									if( trim( col ) != "" ) {
										if( altColumn != "" && structKeyExists( criteria, "delimiter" ) ) {
											altColumn = altColumn & criteria.delimiter;	
										}
										altColumn = altColumn & trim( col );
									}	
								} 
							}
							else {
								altColumn = thequery[ criteria.alt ][ i ];
							}
							val = primaryColumn=="" ? altColumn : primaryColumn;
							break;
						case "phone":
							if( val != "" ) {
								try {
									// strip out characters so we have a baseline
									var phone = reReplace( trim( val ), "[^[:digit:]]", "", "all" );
										phone = "(#left( phone, 3 )#) #mid( phone, 4, 3 )#-#right( phone, 4 )#";
									val = phone;
								}
								catch( any e ) {
									val = val;	
								}
							}
							break;
					}
					querySetCell( thequery, column, val, i );
				}	
			}
		}
		return thequery;
	}
}