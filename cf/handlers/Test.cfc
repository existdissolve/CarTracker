/**
* Handler for Staff
*/
component extends="CarTracker.handlers.Base" {
	property name="StaffService" inject;
	property name="PositionService" inject;
	property name="CategoryService" inject;
	
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
		view="GET",
		create="POST",
		update="PUT",
		remove="DELETE"
	};
		
	function list( required Any event, required Struct rc, required Struct prc ){
		// populate staff
		var args = {
			FirstName = "Joel",
			LastName="",
			DOB="",
			HireDate="",
			Position="2",
			Categories=[1,2,3]//,
			//Colors=[1,3,5]
		};
		staff = StaffService.populate( target=StaffService.get( 8 ), memento=args, nullEmptyInclude="Position", composeRelationships=true );
		//writedump( ORMGetSessionFactory().get );
		/*writedump( staff.getFirstName() );
		writedump( staff.getLastName() );
		writedump( staff.getDOB() );
		writedump( staff.getHireDate() );*/
		//var staff = StaffService.new();
		//staff.setFirstName( "Chuck" );
		//var category = CategoryService.get( 1 );
		//staff.addCategories( category.getLongName(), CategoryService.get( 1 ) );
		//writedump( staff );
	
		writedump( staff );
		abort;
		StaffService.save( staff );
		abort;
	}
}
