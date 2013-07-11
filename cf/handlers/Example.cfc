/**
* Handler for Cars
*/
component extends="CarTracker.handlers.Base" {
	property name="ExampleService" inject;
	
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
		
	function index( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.get( 11 );
		writedump( var=prc.results );
		abort;
		event.setView( "index" );
	}

	function test1( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest1();
		writeoutput( '<pre>c.between( "SaleDate", parseDateTime( "2013-06-06" ), parseDateTime( "2013-07-01" ) );</pre>' );
		writedump( var=prc.results, top=3, label="between()" );
		abort;
	}

	function test2( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest2();
		writeoutput( '<pre>c.isEq( "Year", convertValueToJavaType( "Year", 2005 ) );</pre>' );
		writedump( var=prc.results, top=3, label="isEq()" );
		abort;
	}

	function test3( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest3();
writeoutput( '<pre>c.or(
    c.restrictions.isEq( "Year", convertValueToJavaType( "Year", 2005 ) ),
    c.restrictions.isEq( "Year", convertValueToJavaType( "Year", 1984 ) )
);</pre>' );
		writedump( var=prc.results, top=3, label="or()" );
		abort;
	}

	function test4( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest4();
writeoutput( '<pre>c.isTrue( "IsSold" );</pre>' );
		writedump( var=prc.results, top=3, label="isTrue()" );
		abort;
	}

	function test5( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest5();
writeoutput( '<pre>c.between( 
    "SaleDate", 
    parseDateTime( "2013-06-06" ), 
    parseDateTime( "2013-07-01" ) 
);</pre>' );
		writedump( var=prc.results, top=3, label="count()" );
		abort;
	}

	function test6( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest6();
writeoutput( '<pre>c.isTrue( "IsSold" )
 .withProjections( avg="SalePrice" );</pre>' );
		writedump( var=prc.results, top=3, label="avg Projection" );
		abort;
	}

	function test7( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest7();
writeoutput( '<pre>c.isTrue( "IsSold" )
 .withProjections( sum="SalePrice" );</pre>' );
		writedump( var=prc.results, label="sum Projection" );
		abort;
	}

	function test8( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest8();
writeoutput( '<pre>c.isTrue( "IsSold" )
 .withProjections( 
    avg="SalePrice",
    sum="SalePrice" 
);</pre>' );
		writedump( var=prc.results, label="Multiple Projections" );
		abort;
	}

	function test9( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest9();
writeoutput( '<pre>c.isTrue( "IsSold" )
 .withProjections(
    property="Year,Description,SaleDate,AcquisitionDate,SalePrice,ListPrice"
);</pre>' );
		writedump( var=prc.results, label="Property Projection" );
		abort;
	}

	function test10( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest10();
writeoutput( '<pre>c.createAlias( "Make", "make" )
 .isEq( "make.LongName", "Ford" );</pre>' );
		writedump( var=prc.results, top=3, label="createAlias()" );
		abort;
	}

	function test11( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest11();
writeoutput( '<pre>c.createAlias( "SalesPeople", "staff" )
 .createAlias( "staff.Position", "position" )
 .isEq( "position.LongName", "Finance Officer" );</pre>' );
		writedump( var=prc.results, top=3, label="Nested Aliases" );
		abort;
	}

	function test12( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		prc.results = ExampleService.runTest12();
writeoutput( '<pre>c.add(
    c.createSubcriteria( "Car", "carstaff" )
     .withProjections( property="CarID" )
     .createAlias( "carstaff.SalesPeople", "staff" )
     .createAlias( "staff.Position", "position" )
     .isEq( "position.LongName", "Finance Officer" )
     .propertyIn( "CarID" )
);</pre>' );
		writedump( var=prc.results, top=3, label="Subquery - createSubcriteria()" );
		abort;
	}
}
