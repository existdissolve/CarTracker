component entityName="Image" table="Image" persistent=true extends="CarTracker.model.orm._Base" {
	// primary key
	property name="ImageID" column="ImageID" fieldtype="id" generator="increment";
	// non-relational columns
	property name="Path" column="Path" ormtype="string";
	property name="Active" column="Active" ormtype="boolean" default="1";
	// one-to-one
	
	// one-to-many

	// many-to-one
	property name="Car" column="CarID" fieldtype="many-to-one" cfc="CarTracker.model.orm.Car" fkcolumn="CarID";
	// many-to-many

	// calculated properties

	// object constraints
	this.constraints = {};
	
	// methods
	public Image function init() {
		return this;
	}
} 