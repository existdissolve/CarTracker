component extends="CarTracker.model.service.BaseService" {
	/**
     * Constructor
     */
    public CarService function init() {
    	super.init( entityName="Car" );
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
     * returns CarTracker.model.orm.Car
     */
    public CarTracker.model.orm.Car function populate(
   		required Any target="",
   		required Struct memento,
   		String scope,
   		Boolean trustedSetter=false,
   		String include="",
   		String exclude="",
   		Boolean ignoreEmpty=false
    ) {
    	arguments.exclude = listAppend( arguments.exclude, "CarID" );
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
    	arguments.criteria = buildCriteria( criteria=arguments.criteria, sortOrder=arguments.sortOrder );
    	// retrieve the results
    	var collection = super.collect( argumentCollection=arguments );
    	return collection;
    }
    
    /**
     *
     *
     *
     */
    private CriteriaBuilder function buildCriteria( required Any criteria={}, required String sortOrder="" ) {
    	// create new CriteriaBuilder
    	var c = newCriteria();
    	// sanitize the criteria; allow array or struct to be converted to expected format
    	arguments.criteria = super.sanitizeCriteria( arguments.criteria );
    	// loop over filters defined in the request and add them to the filters spec
    	for( var crit in arguments.criteria ) {
    		// do CriteriaBuilder magic here...

            // first, check for properties that will require relationships
            // we want to front-load these based on incoming properties so stuff doesn't go boom
            if( listContainsNoCase( "Make,SalesByMake", crit ) && !isDefined( "make" ) ) {
                var make = c.createAlias( "Make", "make" );
            }
            if( listContainsNoCase( "Model,SalesByMake", crit ) && !isDefined( "model" ) ) {
                var model = c.createAlias( "Model", "model" );
            }
            if( listContainsNoCase( "Color", crit ) && !isDefined( "color" ) ) {
                var color = c.createAlias( "Color", "color" );
            }
            if( listContainsNoCase( "Category", crit ) && !isDefined( "category" ) ) {
                var category = c.createAlias( "Category", "category" );
            }
            if( listContainsNoCase( "Status", crit ) && !isDefined( "status" ) ) {
                var status = c.createAlias( "Status", "status" );
            }
            if( listContainsNoCase( "SalesPeople,Position", crit ) && !isDefined( "staff" ) ) {
                var staff = c.createSubcriteria( "Car", "carstaff" )
                             .withProjections( property="CarID" )
                             .createAlias( "SalesPeople", "staff" );
            }
            if( listContainsNoCase( "Position", crit ) && !isDefined( "position" ) ) {
                var position = staff.createAlias( "staff.Position", "position" );
            }
            // okay, great; now let's handle incoming criteria

            /********************* Make Criteria (make) **********************/
            if( crit == "Make" ) {
                c.isIn( "make.MakeID", arguments.criteria[ crit ] );
            }
            /********************* Model Criteria (model) **********************/
            if( crit == "Model" ) {
                c.isIn( "model.ModelID", arguments.criteria[ crit ] );
            }
            /********************* Color Criteria (color) **********************/
            if( crit == "Color" ) {
                c.isIn( "color.ColorID", arguments.criteria[ crit ] );
            }
            /********************* Category Criteria (category) **********************/
            if( crit == "Category" ) {
                c.isIn( "category.CategoryID", arguments.criteria[ crit ] );
            }
            /********************* Status Criteria (status) **********************/
            if( crit == "Status" ) {
                c.isIn( "status.StatusID", arguments.criteria[ crit ] );
            }
            /********************* Features Criteria (features) **********************/
            if( crit == "Features" ) {
                c.add(
                    c.createSubcriteria( "Car", "carfeatures" )
                     .createAlias( "Features", "features" )
                     .withProjections( property="CarID" )
                     .isIn( "features.FeatureID", arguments.criteria[ crit ] )
                     .propertyIn( "CarID" )
                );
            }
            /********************* SalesPeople Criteria (staff) **********************/
            if( crit == "SalesPeople" ) {
                staff.isIn( "StaffID", arguments.criteria[ crit ] );
            }
            /********************* Position Criteria (position) **********************/
            if( crit == "Position" ) {
                staff.isIn( "position.PositionID", arguments.criteria[ crit ] );
            }
            /********************* Rooted Entity Criteria (c) **********************/

            // AcquisitionDate
            if( crit== "AcquisitionStartDate" ) {
                if( structKeyExists( arguments.criteria, "AcquisitionEndDate" ) ) {
                    c.between( 
                        "AcquisitionDate", 
                        parseDateTime( arguments.criteria[ "AcquisitionStartDate" ] ), 
                        parseDateTime( arguments.criteria[ "AcquisitionEndDate" ] ) 
                    );
                }
                else {
                    c.isGe( "AcquisitionDate", parseDateTime( arguments.criteria[ crit ] ) );
                }
            }
            if( crit== "AcquisitionEndDate" && !structKeyExists( arguments.criteria, "AcquisitionStartDate" ) ) {
                c.isLe( "AcquisitionDate", parseDateTime( arguments.criteria[ crit ] ) );
            }
            // SaleDate
            if( crit== "SaleStartDate" ) {
                if( structKeyExists( arguments.criteria, "SaleEndDate" ) ) {
                    c.between( 
                        "SaleDate", 
                        parseDateTime( arguments.criteria[ "SaleStartDate" ] ), 
                        parseDateTime( arguments.criteria[ "SaleEndDate" ] ) 
                    );
                }
                else {
                    c.isGe( "SaleDate", parseDateTime( arguments.criteria[ crit ] ) );
                }
            }
            if( crit== "SaleEndDate" && !structKeyExists( arguments.criteria, "SaleStartDate" ) ) {
                c.isLe( "SaleDate", parseDateTime( arguments.criteria[ crit ] ) );
            }
            // SalePrice
            if( crit == "SalePrice" ) {
                c.between(
                    "SalePrice",
                    arguments.criteria[ crit ][ 1 ],
                    arguments.criteria[ crit ][ 2 ]
                );
            }
            // ListPrice
            if( crit == "ListPrice" ) {
                c.between(
                    "ListPrice",
                    arguments.criteria[ crit ][ 1 ],
                    arguments.criteria[ crit ][ 2 ]
                );
            }
            if( crit == "IsSold" ) {
                c.isEq( "IsSold", JavaCast( "boolean", true ) );
            }
            // SalesByMake
            if( crit == "SalesByMake" ) {
                c.withProjections( groupProperty="make.LongName,model.LongName", sum="SalePrice" );
            }
            // SalesByMonth
            if( crit == "SalesByMonth" ) {
                c.withProjections( groupProperty="SaleDate", count="SalePrice", sum="SalePrice" );
            }
    	}
        // add detached criteria
        if( isDefined( "staff" ) ) {
            c.add( staff.propertyIn( "CarID" ) );
        }
        // add sorter
        if( len( arguments.sortOrder ) ) {
            var property = listGetAt( arguments.sortOrder, 1, " " );
            var direction= listGetAt( arguments.sortOrder, 2, " " );
            var sortProperty = "";
            switch( property ) {
                case "Make":
                    if( !isDefined( "make" ) ) {
                        var make = c.createAlias( "Make", "make" );
                    }
                    sortProperty = "make.LongName";
                    break;
                case "Model":
                    if( !isDefined( "model" ) ) {
                        var model = c.createAlias( "Model", "model" );
                    }
                    sortProperty = "model.LongName";
                    break;
                case "Category":
                    if( !isDefined( "category" ) ) {
                        var category = c.createAlias( "Category", "category" );
                    }
                    sortProperty = "category.LongName";
                    break;
                case "Color":
                    if( !isDefined( "color" ) ) {
                        var color = c.createAlias( "Color", "color" );
                    }
                    sortProperty = "color.LongName";
                    break;
                case "Status":
                    if( !isDefined( "status" ) ) {
                        var status = c.createAlias( "Status", "status" );
                    }
                    sortProperty = "status.LongName";
                    break;
            }
            if( len( sortProperty ) ) {
                c.order( sortProperty, direction );
            }            
        }
    	return c;
    }
}