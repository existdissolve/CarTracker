component persistent="true" entityname="Category" table="Category" extends="CarTracker.model.orm.option._Base" {
	// primary key
	property name="CategoryID" column="CategoryID" fieldtype="id" generator="increment";
	// non-relational columns
	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	
	// many-to-many
	
	// calculated properties
	
	// object constraints
	
	// methods
	public Category function init() {
		return this;
	}
} 