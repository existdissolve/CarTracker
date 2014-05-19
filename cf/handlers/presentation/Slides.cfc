/**
* Handler for Cars
*/
component {
    property name="ORMService" inject="entityService";
    property name="VirtualCarService" inject="entityService:SimpleCar";
    property name="CarService" inject="id:SimpleCarService";
    
    function preHandler( event, action, eventArguments ) {
        event.setLayout( "Layout.Presentation" );
    }

    function index( required Any event, required Struct rc, required Struct prc ) {
        //event.setView( view='presentation/index', layout="Layout.Presentation" );
    }

    function baseORMService( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Base ORM Service";
        prc.newCar = ORMService.new( entityName='SimpleCar', properties={Year= 2012, ListPrice= 22000});
        prc.myCar = ORMService.findWhere( entityName='SimpleCar', criteria={ CarID = 12 } );
        prc.cars = ORMService.list( entityName="SimpleCar", max=3, asQuery=false );
    }

    function activeEntity( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Active Entity";
        var car = entityNew( "ActiveCar" );
        prc.newCar = car.new( properties={Year= 2012, ListPrice= 22000});
        prc.myCar = car.findWhere( entityName='SimpleCar', criteria={ CarID = 12 } );
        prc.cars = car.list( entityName="SimpleCar", max=3, asQuery=false );
    }

    function virtualEntityService( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Virtual Entity Service";
        prc.newCar = VirtualCarService.new( properties={Year= 2012, ListPrice= 22000});
        prc.myCar = VirtualCarService.findWhere( criteria={ CarID = 12 } );
        prc.cars = VirtualCarService.list( max=3, asQuery=false );
    }

    function concreteService( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Concrete Service";
        prc.newCar = CarService.new( properties={Year= 2012, ListPrice= 22000});
        prc.myCar = CarService.findWhere( criteria={ CarID = 12 } );
        prc.cars = CarService.list( max=3, asQuery=false );
        prc.newCars = CarService.getNewCars();
    }

    function validation( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Entity Validation";
        prc.newCar = CarService.new( properties={
            /*Year = 2012,
            AcquisitionDate = "Henry",
            VIN = "VIN123-GJH-1923",
            ListPrice = 3500*/
        });
        prc.validationResults = validateModel( target=prc.newCar );
    }

    function populate( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Populate()";
        var newCar = CarService.new();
        var fakeForm = {
            Year = 2012,
            AcquisitionDate = "2013-12-15",
            VIN = "VIN123-GJH-1923",
            ListPrice = 14500,
            Make = 6,
            Model = 14,
            Color = 9
        };
        prc.newCar = CarService.populate( target=newCar, memento=fakeform, composeRelationships=true );
    }

    function query_simple( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Criteria Builder - Simple Query";
        var c = CarService.newCriteria();
            c.between( "SaleDate", createODBCDate( "2013-04-01" ), createODBCDate( "2013-07-01" ) );
        prc.count = c.count();
        //max=3, offset=6
        prc.results = c.list();
    }

    function query_projection( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Criteria Builder - Projection";
        var c = CarService.newCriteria();
        // average sale price for all vehicles
        prc.avg = c.isTrue( "IsSold" ).withProjections( avg="SalePrice" ).list();
        var c = CarService.newCriteria();
        // total sum of sales for all vehicles
        prc.sum = c.isTrue( "IsSold" ).withProjections( sum="SalePrice" ).list();
        var c = CarService.newCriteria();
        // avg and sum
        prc.total = c.isTrue( "IsSold" )
         .withProjections( 
            sum="SalePrice",
            avg="SalePrice" 
         ).list();
        var c = CarService.newCriteria();
        // limit properties returned
        prc.properties = c.isTrue( "IsSold" )
         .withProjections( 
            property="Year,Description,SaleDate,AcquisitionDate,SalePrice,ListPrice"
         ).list();
        // tranform results
        var c = CarService.newCriteria();
        prc.transformed = c.isTrue( "IsSold" )
         .withProjections( 
            property="Year,Description,SaleDate,AcquisitionDate,SalePrice,ListPrice"
         )
         .resultTransformer( c.ALIAS_TO_ENTITY_MAP )
         .list();
    }

    function query_alias( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Criteria Builder - Projection";
        var c = CarService.newCriteria();
        // left join
        prc.make = c.createAlias( "Make", "make", c.LEFT_JOIN )
          .isEq( "make.LongName", "Ford" ).list();

        var c = CarService.newCriteria();
        // nested alias
        prc.salespeople = c.createAlias( "SalesPeople", "staff" )
          .createAlias( "staff.Position", "position" )
          .isEq( "position.LongName", "General Manager" ).list();
    }

    function query_subquery( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Criteria Builder - Subquery";
        var c = CarService.newCriteria();
        // add subquery
        c.add(
          c.createSubcriteria( "Car", "carstaff" )
            // the property in the subquery to use
            .withProjections( property="CarID" )
            .createAlias( "carstaff.SalesPeople", "staff" )
            .createAlias( "staff.Position", "position" )
            .isEq( "position.LongName", "Finance Officer" )
            // the property in root to compare to projected val
            .propertyIn( "CarID" )
        );
        // get results
        prc.results = c.list();
    }

    function query_logging( required Any event, required Struct rc, required Struct prc ) {
        rc.pageTitle = "Criteria Builder - ORM SQL Logging";
    }
}