/**
* Handler for Cars
*/
component extends="CarTracker.handlers.Base" {
    property name="CarService" inject;
    property name="MakeService" inject;
    property name="ModelService" inject;
    property name="CategoryService" inject;
    property name="StatusService" inject;
    property name="ColorService" inject;
    property name="FeatureService" inject;
    property name="StaffService" inject;
    property name="DriveTrainService" inject;
    property name="ORMService" inject="coldbox:plugin:ORMService";
    
    // OPTIONAL HANDLER PROPERTIES
    this.prehandler_only    = "";
    this.prehandler_except  = "";
    this.posthandler_only   = "";
    this.posthandler_except = "";
    this.aroundHandler_only = "";
    this.aroundHandler_except = "";     
    // REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
    this.allowedMethods = {
        list="GET",
        view="GET",
        create="POST",
        update="PUT",
        remove="DELETE",
        updateWorkflow="PUT"
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
        
    function list( required Any event, required Struct rc, required Struct prc ){
        // retrieve Cars based on search criteria
        var car = CarService.collect( argumentCollection=arguments.rc );
        prc.jsonData = {
            "count" = car.count,
            "data"  = EntityUtils.parseEntity( entity=car.data, simpleValues=true, excludeList="Make,Model,Category,Color,Features,SalesPeople" )
        };
    }   

    function view( required Any event, required Struct rc, required Struct prc ){
        // get car based on passed id
        var car = CarService.get( arguments.rc.CarID );
        prc.jsonData = EntityUtils.parseEntity( 
            entity=car, 
            simpleValues=true,
            decorations = [
                {
                    property="Images",
                    includeList = "Path",
                    keyMapping = {
                        "Path" = "ImagePaths"
                    }
                },
                {
                    property="Features",
                    includeList = "LongName",
                    keyMapping = {
                        "LongName" = "_Features"
                    }
                },
                {
                    property="SalesPeople",
                    includeList = "LastName",
                    keyMapping = {
                        "LastName" = "_SalesPeople"
                    }
                }
            ]
        );
    }   

    function create( required Any event, required Struct rc, required Struct prc ){
        // populate car
        var car = CarService.populate( memento=arguments.rc, exclude="Status,Make,Model,Category,Color,Features,SalesPeople" );
        if( structKeyExists( rc, "Status" ) ) {
            car.setStatus( StatusService.get( rc.Status ) );
        }
        if( structKeyExists( rc, "Make" ) ) {
            car.setMake( MakeService.get( rc.Make ) );
        }
        if( structKeyExists( rc, "Model" ) ) {
            car.setModel( ModelService.get( rc.Model ) );
        }
        if( structKeyExists( rc, "Category" ) ) {
            car.setCategory( CategoryService.get( rc.Category ) );
        }
        if( structKeyExists( rc, "Color" ) ) {
            car.setColor( ColorService.get( rc.Color ) );
        }
        if( structKeyExists( rc, "DriveTrain" ) ) {
            car.setDriveTrain( DriveTrainService.get( rc.DriveTrain ) );
        }
        if( structKeyExists( rc, "Features" ) ) {
            for( var feature in rc.Features ) {
                car.addFeature( FeatureService.get( feature ) );
            }
        }
        if( structKeyExists( rc, "SalesPeople" ) ) {
            for( var staff in rc.SalesPeople ) {
                car.addSalesPerson( StaffService.get( staff ) );
            }
        }
        // validate model
        prc.validationResults = validateModel( car );
        // if there are errors, handle it
        if( prc.validationResults.hasErrors() ) {
            prc.jsonData = {
                "data" = errorsToArray( prc.validationResults.getErrors() ),
                "success" = false,
                "message" = "Please correct the following errors",
                "type" = "validation"
            };
            return;
        }
        // save the car
        CarService.save( car );
        prc.jsonData = {
            "data"  = EntityUtils.parseEntity( entity=car, simpleValues=true ),
            "success" = true,
            "message" = "The Car was created successfully!",
            "type" = "success"
        };
    }   

    function update( required Any event, required Struct rc, required Struct prc ){
        // populate car
        var car = CarService.populate( memento=arguments.rc, exclude="Status,Make,Model,Category,Color,Features,SalesPeople" );
        if( structKeyExists( rc, "Status" ) ) {
            car.setStatus( StatusService.get( rc.Status ) );
        }
        if( structKeyExists( rc, "Make" ) ) {
            car.setMake( MakeService.get( rc.Make ) );
        }
        if( structKeyExists( rc, "Model" ) ) {
            car.setModel( ModelService.get( rc.Model ) );
        }
        if( structKeyExists( rc, "Category" ) ) {
            car.setCategory( CategoryService.get( rc.Category ) );
        }
        if( structKeyExists( rc, "Color" ) ) {
            car.setColor( ColorService.get( rc.Color ) );
        }
        if( structKeyExists( rc, "DriveTrain" ) ) {
            car.setDriveTrain( DriveTrainService.get( rc.DriveTrain ) );
        }
        if( structKeyExists( rc, "Features" ) ) {
            car.getFeatures().clear();
            for( var feature in rc.Features ) {
                car.addFeature( FeatureService.get( feature ) );
            }
        }
        if( structKeyExists( rc, "SalesPeople" ) ) {
            car.getSalesPeople().clear();
            for( var staff in rc.SalesPeople ) {
                car.addSalesPerson( StaffService.get( staff ) );
            }
        }
        if( structKeyExists( rc, "ImagePaths" ) ) {
            car.getImages().clear();
            for( var path in rc.ImagePaths ) {
                var image = ORMService.new( "Image" );
                    image.setPath( path );
                    image.setCar( car );
                car.addImage( image );
            }
        }
        // validate model
        prc.validationResults = validateModel( car );
        // if there are errors, handle it
        if( prc.validationResults.hasErrors() ) {
            prc.jsonData = {
                "data" = errorsToArray( prc.validationResults.getErrors() ),
                "success" = false,
                "message" = "Please correct the following errors",
                "type" = "validation"
            };
            return;
        }
        // save the car
        CarService.save( car );
        prc.jsonData = {
            "data"  = EntityUtils.parseEntity( entity=car, simpleValues=true ),
            "success" = true,
            "message" = "The Car was updated successfully!",
            "type" = "success"
        };
    }   

    function remove( required Any event, required Struct rc, required Struct prc ){
        // delete by incoming id
        CarService.deleteByID( arguments.rc.CarID );
        prc.jsonData = {
            "data"  = "",
            "success" = true,
            "message" = "The Car was deleted successfully!",
            "type" = "success"
        };
    }

    function updateWorkflow( required Any event, required Struct rc, required Struct prc ) {
        var car = CarService.get( rc.CarID );
        var oldstatus = StatusService.get( arguments.rc.Status );
        var staff = StaffService.get( arguments.rc.Staff );
        var approved = true;
        // get new workflow
        var workflow = ORMService.new( "Workflow" );
        // switch on incoming status
        switch( rc.Status ) {
            case 4: // initiated
                var newstatus = StatusService.get( 5 );
                break;
            case 3: // in-review
                var newstatus = rc.Action=="Approve" ? StatusService.get( 1 ) : StatusService.get( 5 );
                approved = rc.Action=="Approve" ? true : false;
                break;
            case 5: // in audit
                var newstatus = rc.Action=="Approve" ? StatusService.get( 3 ) : StatusService.get( 4 );
                approved = rc.Action=="Approve" ? true : false;
                break;
            case 1: // approved
            case 2: // rejected
                var newstatus = StatusService.get( 4 );
                break;
        }
        // update car status
        car.setStatus( newstatus );
        // populate workflow
        workflow.setLastStatus( oldstatus );
        workflow.setNextStatus( newstatus );
        workflow.setCar( car );
        workflow.setStaff( staff );
        workflow.setApproved( approved );
        workflow.setNotes( arguments.rc.Notes );

        // save the Car
        CarService.save( car );
        // save workflow
        ORMService.save( workflow );
        // refresh car
        CarService.refresh( car );
        prc.jsonData = {
            "data"  = { "Status"=car.getStatus().getStatusID(), "_Status"=car.getStatus().getLongName() },
            "success" = true,
            "message" = "The Car Status was updated successfully!",
            "type" = "success"
        };
    }

    function initiate( required Any event, required Struct rc, required Struct prc ){
        // get iniated status
        var status = StatusService.get( 4 );
        // get staff member
        var staff = StaffService.get( arguments.rc.StaffID );
        // get new workflow
        var workflow = ORMService.new( "Workflow" );
        // get target car
        var car = CarService.get( arguments.rc.CarID );
        // update car status
        car.setStatus( status );
        // populate workflow
        workflow.setStatus( status );
        workflow.setCar( car );
        workflow.setStaff( staff );
        workflow.setNotes( arguments.rc.Notes );

        // save the Car
        CarService.save( car );
        // save workflow
        ORMService.save( workflow );

        prc.jsonData = {
            "data"  = EntityUtils.parseEntity( entity=car, simpleValues=true ),
            "success" = true,
            "message" = "The Car Status was updated successfully!",
            "type" = "success"
        };
    }
}
