<cfscript>
	// Allow unique URL or combination (false)
	setUniqueURLS(false);
	// Auto reload configuration, true in dev makes sense
	//setAutoReload(false);
	// Sets automatic route extension detection and places the extension in the rc.format
	setExtensionDetection(true);
	//setValidExtensions('json');
	
	// Base URL
	if( len(getSetting('AppMapping') ) lte 1){
		setBaseURL("http://#cgi.HTTP_HOST#/index.cfm");
	}
	else{
		setBaseURL("http://#cgi.HTTP_HOST#/#getSetting('AppMapping')#/index.cfm");
	}
	
	addRoute( pattern="/api/option/colors/:colorid", handler="option.Color", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/colors", handler="option.Color", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/option/drivetrains/:drivetrainid", handler="option.DriveTrain", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/drivetrains", handler="option.DriveTrain", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/option/categories/:categoryid", handler="option.Category", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/categories", handler="option.Category", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/option/features/:featureid", handler="option.Feature", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/features", handler="option.Feature", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/option/positions/:positionid", handler="option.Position", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/positions", handler="option.Position", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/option/statuses/:statusid", handler="option.Status", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/statuses", handler="option.Status", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/option/makes/:makeid", handler="option.Make", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/makes", handler="option.Make", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/option/userroles/:userroleid", handler="option.UserRole", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/userroles", handler="option.UserRole", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/option/models/:modelid", handler="option.Model", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/option/models", handler="option.Model", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/staff/:staffid", handler="Staff", action={ PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/staff", handler="Staff", action={ POST="create", GET="list" } );
	
	addRoute( pattern="/api/cars/:carid", handler="Car", action={ GET="view", PUT="update", DELETE="remove" } );
	addRoute( pattern="/api/cars", handler="Car", action={ POST="create", GET="list" } );

	addRoute( pattern="/api/workflows/:carid", handler="Car", action={ GET="listWorkflow", PUT="updateWorkflow" } );

	addRoute( pattern="/api/images/:carid", handler="Image", action={ GET="list" } );
	addRoute( pattern="/api/images", handler="Image", action={ POST="upload" } );

	addRoute( pattern="/api/security/checklogin", handler="Security", action={ GET="checklogin" } );
	addRoute( pattern="/api/security/login", handler="Security", action={ POST="login" } );
	addRoute( pattern="/api/security/logout", handler="Security", action={ GET="logout" } );

	addRoute( pattern="/api/reports/make", handler="Report", action={ GET="make" } );
	addRoute( pattern="/api/reports/month", handler="Report", action={ GET="month" } );
	// Your Application Routes
	addRoute(pattern=":handler/:action?");
</cfscript>