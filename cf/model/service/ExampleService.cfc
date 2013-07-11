component extends="coldbox.system.orm.hibernate.VirtualEntityService" {
	/**
     * Constructor
     */
    public ExampleService function init() {
    	super.init( entityName="Car" );
    	// use query caching
    	setUseQueryCaching( false );
    	return this;
    }

    public Any function runTest1() {
        var c = newCriteria();
            c.between( "SaleDate", parseDateTime( "2013-06-06" ), parseDateTime( "2013-07-01" ) );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest2() {
        var c = newCriteria();
            c.isEq( "Year", convertValueToJavaType( "Year", 2005 ) );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest3() {
        var c = newCriteria();
            c.or(
                c.restrictions.isEq( "Year", convertValueToJavaType( "Year", 2005 ) ),
                c.restrictions.isEq( "Year", convertValueToJavaType( "Year", 1984 ) )
            );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest4() {
        var c = newCriteria();
            c.isTrue( "IsSold" );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest5() {
        var c = newCriteria();
            c.between( 
                "SaleDate", 
                parseDateTime( "2013-06-06" ), 
                parseDateTime( "2013-07-01" ) 
            );
        
        var results = {
            count= c.count(),
            data = c.list()
        };
        return results;
    }

    public Any function runTest6() {
        var c = newCriteria();
            c.isTrue( "IsSold" )
             .withProjections( avg="SalePrice" );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest7() {
        var c = newCriteria();
            c.isTrue( "IsSold" )
             .withProjections( sum="SalePrice" );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest8() {
        var c = newCriteria();
            c.isTrue( "IsSold" )
             .withProjections( 
                avg="SalePrice",
                sum="SalePrice" 
            );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest9() {
        var c = newCriteria();
            c.isTrue( "IsSold" )
             .withProjections(
                property="Year,Description,SaleDate,AcquisitionDate,SalePrice,ListPrice"
            );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest10() {
        var c = newCriteria();
            c.createAlias( "Make", "make" )
             .isEq( "make.LongName", "Ford" );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest11() {
        var c = newCriteria();
            c.createAlias( "SalesPeople", "staff" )
             .createAlias( "staff.Position", "position" )
             .isEq( "position.LongName", "Finance Officer" );
        
        var results = {
            data = c.list()
        };
        return results;
    }

    public Any function runTest12() {
        var c = newCriteria();
            c.add(
                c.createSubcriteria( "Car", "carstaff" )
                .withProjections( property="CarID" )
                .createAlias( "carstaff.SalesPeople", "staff" )
                .createAlias( "staff.Position", "position" )
                .isEq( "position.LongName", "Finance Officer" )
                .propertyIn( "CarID" )
            );
        
        var results = {
            data = c.list()
        };
        return results;
    }
}