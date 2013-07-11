component entityName="Car" table="Car" persistent=true extends="CarTracker.model.orm._Base" {
	// primary key
	property name="CarID" column="CarID" fieldtype="id" generator="increment";
	// non-relational columns
	property name="Description" column="Description" ormtype="string";
	property name="Year" column="Year" ormtype="integer";
	property name="ListPrice" column="ListPrice" ormtype="integer";
	property name="SalePrice" column="SalePrice" ormtype="integer";
	property name="AcquisitionDate" column="AcquisitionDate" ormtype="date";
	property name="SaleDate" column="SaleDate" ormtype="date";
	property name="StockNumber" column="StockNumber" ormtype="string";
	property name="VIN" column="VIN" ormtype="string";
	property name="Fuel" column="Fuel" ormtype="string";
	property name="Engine" column="Engine" ormtype="string";
	property name="Transmission" column="Transmission" ormtype="string";
	property name="Mileage" column="Mileage" ormtype="integer";
	property name="IsSold" column="IsSold" ormtype="boolean" default="0";
	property name="Active" column="Active" ormtype="boolean" default="1";
	// one-to-one
	
	// one-to-many
	property name="Images" singularname="Image" fieldtype="one-to-many" cfc="CarTracker.model.orm.Image" fkcolumn="CarID" inverse=true cascade="all-delete-orphan";
	// many-to-one
	property name="Status" column="StatusID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Status" fkcolumn="StatusID" lazy="true";
	property name="Make" column="MakeID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Make" fkcolumn="MakeID" lazy="true";
	property name="Model" column="ModelID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Model" fkcolumn="ModelID" lazy="true";
	property name="Category" column="CategoryID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Category" fkcolumn="CategoryID" lazy="true";
	property name="Color" column="ColorID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Color" fkcolumn="ColorID" lazy="true";
	property name="DriveTrain" column="DriveTrainID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.DriveTrain" fkcolumn="DriveTrainID" lazy="true";
	// many-to-many
	property name="SalesPeople" singularname="SalesPerson" fieldtype="many-to-many" cfc="CarTracker.model.orm.Staff" linktable="CarStaff" fkcolumn="CarID" inversejoincolumn="StaffID" lazy="extra";
	property name="Features" singularname="Feature" fieldtype="many-to-many" cfc="CarTracker.model.orm.option.Feature" linktable="CarFeature" fkcolumn="CarID" inversejoincolumn="FeatureID" lazy="extra";
	// calculated properties
	property name="_Make" formula="SELECT m.LongName FROM Make m WHERE m.MakeID = MakeID";
	property name="_Model" formula="SELECT m.LongName FROM Model m WHERE m.ModelID = ModelID";
	property name="_Category" formula="SELECT c.LongName FROM Category c WHERE c.CategoryID = CategoryID";
	property name="_Status" formula="SELECT s.LongName FROM Status s WHERE s.StatusID = StatusID";
	property name="_Color" formula="SELECT c.LongName FROM Color c WHERE c.ColorID = ColorID";
	// object constraints
	this.constraints = {
		"Year" = { required=true, requiredMessage="Please enter a Year" },
		"ListPrice" = { required=true, requiredMessage="Please enter a List Price" },
		"AcquisitionDate" = { required=true, requiredMessage="Please enter an Acquisition Date", type="date", typeMessage="Please enter a valid Acquisition Date" },
		"SaleDate" = { type="date", typeMessage="Please enter a valid Sale Date" }
	};
	
	// methods
	public Car function init() {
		return this;
	}
} 