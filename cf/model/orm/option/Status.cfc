component persistent="true" entityname="Status" table="Status" extends="CarTracker.model.orm.option._Base" {
	// primary key
	property name="StatusID" column="StatusID" fieldtype="id" generator="increment";
	// non-relational columns
	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	
	// many-to-many
	
	// calculated properties
	
	// object constraints
	
	// methods
	public Status function init() {
		return this;
	}
} 