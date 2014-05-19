component entityName="ActiveCar" table="Car" persistent=true extends="coldbox.system.orm.hibernate.ActiveEntity" {
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
    
    // many-to-many
    
    // calculated properties
    
    // non-persistent properties and di

    // object constraints
    this.constraints = {};
    
    // methods
    public ActiveCar function init() {
        super.init();
        return this;
    }
} 