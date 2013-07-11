component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton {
	
	public BaseService function init( entityName ) {
		super.init( entityName=arguments.entityName );
		return this;
	}
	
	/**
     * Main method to collect data from an entity based on arbitrary criteria
     * @max {Numeric} Maximum number of records to retrieve
     * @offset {Numeric} Place in result set from which to start
     * @asQuery {Boolean} Whether to convert result set to a query
     * @unique {Boolean} Whether to only return unique values
     * @criteria {CriteriaBuilder} Criteria to use for query
     * returns Any
     */
	public Any function collect(
		required Numeric max=0,
		required Numeric offset=0,
		required Boolean asQuery=false,
		required Boolean unique=false,
		required String sortOrder="",
		required Any criteria=newCriteria()
	) {
		// clean up sortorder
		arguments.sortOrder = sanitizeSortOrder( arguments.criteria, arguments.sortOrder );
		// setup data collection which be populated
		var dataCollection = {};
			if( isNull( criteria.getNativeCriteria().getProjection() ) ) {
				dataCollection[ "count" ] = arguments.criteria.count();
			}
			dataCollection[ "data" ] = arguments.criteria.list( argumentCollection=arguments );
			if( !isNull( criteria.getNativeCriteria().getProjection() ) && criteria.getNativeCriteria().getProjection().getLength() ) {
				dataCollection[ "count" ] = arrayLen( dataCollection[ "data" ] );
			}	
		// return the datacollection
		return dataCollection;
	}
	
	/**
     * Populates the specified target with data
     * @target {Any} The target to populate with data
     * @memento {Struct} The structure of raw dta with which to populate the entity
     * @scope {String} The scope into which population should occur
     * @trustedSetter {Boolean} Whether checks for the property should be made before trying to set the value
     * @include {String} List of properties to include
     * @exclude {String} List of properties to exclude
     * @ignoreEmpty {Boolean} WHether to ignore empty values
     * returns CarTracker.model.orm.option.Color
     */
	public Any function populate(
		required Any target="",
   		required Struct memento,
   		String scope,
   		Boolean trustedSetter=false,
   		String include="",
   		String exclude="",
   		Boolean ignoreEmpty=false
	){
		if( !isObject( arguments.target) ) {
			arguments.target = getEntityByPK( memento=arguments.memento );
		}
		// clean arguments before population
		arguments.memento = cleanArguments( memento=arguments.memento );
		// now really populate
		var entity = super.populate( argumentCollection=arguments );
		// return
		return entity;
	}

	/**
	 * Get an entity by its primary key from a struct of key/value pairs; if not found, return new entity
	 * @memento {Struct} Key value pair of values potentially containing the PK field
	 * returns Any
	 */
	public Any function getEntityByPK( required Struct memento ) {
		var PKField = getKey();
		return structKeyExists( arguments.memento, PKField ) ? get( arguments.memento[ PKField] ) : get( "" );
	}

	/**
	 * Auto-trimming for properties, as well as auto-nulling of empty strings
	 * @memento {Struct} The structure of values for population
	 * returns Struct
	 */
	private Struct function cleanArguments( required Struct memento ) {
		for (var key in arguments.memento ) {
			if( isSimpleValue( arguments.memento[ key ] ) ) {
				if( arguments.memento[ key ]=="" ) {
					arguments.memento[ key ] = "";
				}
				else {
					arguments.memento[ key ] = trim( arguments.memento[ key ] );
				}
			}
		}
		return arguments.memento;
	}

	/**
	 * Sanitizes diverse types of criteria and converts them into a standard format
	 * @criteria {Any} The criteria object (array, struct, etc.)
	 * returns Struct
	 */
	private Struct function sanitizeCriteria( required Any criteria ) {
		if( isStruct( arguments.criteria ) ) {
			return arguments.criteria;
		}
		if( isArray( arguments.criteria ) ) {
			var newCriteria = {};
			for( var crit in arguments.criteria ) {
				if( structKeyExists( crit, "value" ) ) {
					newcriteria[ crit.property ]  = crit.value;
				}
			}
			return newcriteria;
		}
	}
	
	/**
     * Helper method to make sure that sortOrder is correct and only set for valid column in the entity
     * @criteria {CriteriaBuilder} The criteria query object against which the sort order will be applied
     * @sortOrder {String} The sort order to be applied
     * returns String
     */
	private String function sanitizeSortOrder( required CriteriaBuilder criteria, required String sortOrder ) {
		var propertyNames = arrayToList( this.getPropertyNames() );
		var fixedSortOrder = "";
		for( var sort in listToArray( arguments.sortOrder ) ) {
			var property = listGetAt( sort, 1, " " );
			var dir = listGetAt( sort, 2, " " );
			if( listContainsNoCase( propertyNames, property ) ) {
				fixedSortOrder = listAppend( fixedSortOrder, "#property# #dir#" );
			}
		}
		return fixedSortOrder;
	}
}