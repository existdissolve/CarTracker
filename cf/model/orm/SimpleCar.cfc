component entityName="SimpleCar" table="Car" persistent=true extends="CarTracker.model.orm._Base" {
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
    property name="Rating" column="Rating" ormtype="float" notnull="false" default="0.00";
    property name="VIN" column="VIN" ormtype="string";
    property name="Fuel" column="Fuel" ormtype="string";
    property name="Engine" column="Engine" ormtype="string";
    property name="Transmission" column="Transmission" ormtype="string";
    property name="Mileage" column="Mileage" ormtype="integer";
    property name="IsSold" column="IsSold" ormtype="boolean" default="0";
    property name="Active" column="Active" ormtype="boolean" default="1";
    // one-to-one
    
    // one-to-many
    
    // many-to-one
    property name="Make" column="MakeID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Make" fkcolumn="MakeID" lazy="true";
    property name="Model" column="ModelID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Model" fkcolumn="ModelID" lazy="true";
    property name="Category" column="CategoryID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Category" fkcolumn="CategoryID" lazy="true";
    property name="Color" column="ColorID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Color" fkcolumn="ColorID" lazy="true";
    // many-to-many
    property name="SalesPeople" singularname="SalesPerson" fieldtype="many-to-many" cfc="CarTracker.model.orm.Staff" linktable="CarStaff" fkcolumn="CarID" inversejoincolumn="StaffID" lazy="extra";
    // calculated properties
    
    // non-persistent properties and di

    // object constraints
    this.constraints = {
        "Year" = { required=true, requiredMessage="Please enter a Year" },
        "ListPrice" = { required=true, requiredMessage="Please enter a List Price", min=4000 },
        "AcquisitionDate" = { required=true, requiredMessage="Please enter an Acquisition Date", type="date", typeMessage="Please enter a valid Acquisition Date" },
        "SaleDate" = { type="date", typeMessage="Please enter a valid Sale Date" },
        "VIN" = { required=true, requiredMessage="Please enter a VIN", unique=true, uniqueMessage="Please enter a unique VIN"},
        "IsSold" = { required=true, requiredMessage="Specify whether this vehicle is sold or not", type="boolean", typeMessage="Please specify Yes or No for whether this vehicle is sold"}
    };
    
    // methods
    public SimpleCar function init() {
        return this;
    }
} 