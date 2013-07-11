component extends="CarTracker.model.service.BaseService" {
	/**
     * Constructor
     */
    public FeatureService function init() {
    	super.init( entityName="Feature" );
    	// use query caching
    	setUseQueryCaching( false );
    	
    	return this;
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
     * returns CarTracker.model.orm.option.Feature
     */
    public CarTracker.model.orm.option.Feature function populate(
   		required Any target="",
   		required Struct memento,
   		String scope,
   		Boolean trustedSetter=false,
   		String include="",
   		String exclude="",
   		Boolean ignoreEmpty=false
    ) {
    	arguments.exclude = listAppend( arguments.exclude, "FeatureID" );
    	// retrieve populated entity
    	var entity = super.populate( argumentCollection=arguments );
        return entity;
    }
    
	/**
	 * Very flexible method for retrieving entities based on arbitrary criteria
     * @max {Numeric} Maximum number of records to retrieve
     * @offset {Numeric} Place in result set from which to start
     * @asQuery {Boolean} Whether to convert result set to a query
     * @unique {Boolean} Whether to only return unique values
     * @criteria {CriteriaBuilder} Criteria to use for query
     * returns Struct
     */
    public Struct function collect(
    	required Numeric max=0,
		required Numeric offset=0,
		required Boolean asQuery=false,
		required Boolean unique=false,
		required String sortOrder="",
		required Any criteria=newCriteria()
    ) {
    	// build criteria for service based on incoming arguments
    	arguments.criteria = buildCriteria( criteria=arguments.criteria );
    	// retrieve the results
    	var collection = super.collect( argumentCollection=arguments );
    	return collection;
    }
    
    /**
     *
     *
     *
     */
    private CriteriaBuilder function buildCriteria( required Any criteria={} ) {
    	// create new CriteriaBuilder
    	var c = newCriteria();
    	// sanitize the criteria; allow array or struct to be converted to expected format
    	arguments.criteria = super.sanitizeCriteria( arguments.criteria );
    	// loop over filters defined in the request and add them to the filters spec
    	for( var crit in arguments.criteria ) {
    		// do CriteriaBuilder magic here...
            if( crit=="FeatureID" ) {
                c.isIn( "FeatureID", arguments.criteria[ crit ] );
            }
    	}
    	return c;
    }
}