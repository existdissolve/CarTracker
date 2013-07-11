component entityName="Staff" table="Staff" persistent=true extends="CarTracker.model.orm._Base" {
	// primary key
	property name="StaffID" column="StaffID" fieldtype="id" generator="increment";
	// non-relational columns
	property name="FirstName" column="FirstName" ormtype="string";
	property name="LastName" column="LastName" ormtype="string";
	property name="Username" column="Username" ormtype="string";
	property name="Password" column="Password" ormtype="string";
	property name="DOB" column="DOB" ormtype="date";
	property name="Address1" column="Address1" ormtype="string";
	property name="Address2" column="Address2" ormtype="string";
	property name="City" column="City" ormtype="string";
	property name="State" column="State" ormtype="string";
	property name="PostalCode" column="PostalCode" ormtype="string";
	property name="Phone" column="Phone" ormtype="string";
	property name="HireDate" column="HireDate" ormtype="date";
	property name="Active" column="Active" ormtype="boolean" default="1";
	property name="_Position" formula="SELECT p.LongName FROM Position p WHERE p.PositionID = PositionID";
	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	property name="Position" column="PositionID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Position" fkcolumn="PositionID";
	// many-to-many
	property name="UserRoles" singularname="UserRole" fieldtype="many-to-many" cfc="CarTracker.model.orm.option.UserRole" linktable="StaffUserRole" fkcolumn="StaffID" inversejoincolumn="UserRoleID" lazy="extra";
	// calculated properties
	
	// object constraints
	this.constraints = {
		"FirstName" = { required=true, requiredMessage="Please enter a First Name" },
		"LastName" = { required=true, requiredMessage="Please enter a Last Name" },
		"DOB" = { required=true, requiredMessage="Please enter a valid Date of Birth", type="date", typeMessage="Please enter a valid Date of Birth" },
		"Address1" = { required=true, requiredMessage="Please enter a Address1" },
		"City" = { required=true, requiredMessage="Please enter a City" },
		"State" = { required=true, requiredMessage="Please enter a State" },
		"PostalCode" = { required=true, requiredMessage="Please enter a Postal Code", type="zipcode", typeMessage="Please enter a valid Postal Code" },
		"Phone" = { required=true, requiredMessage="Please enter a valid Phone Number", type="telephone", typeMessage="Please enter a valid Phone Number" },
		"HireDate" = { required=true, requiredMessage="Please enter a valid Hire Date", type="date", typeMessage="Please enter a valid Hire Date" }
	};
	
	// methods
	public Staff function init() {
		return this;
	}
} 