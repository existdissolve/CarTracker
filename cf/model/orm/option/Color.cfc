component persistent="true" entityname="Color" table="Color" extends="CarTracker.model.orm.option._Base" {
	// primary key
	property name="ColorID" column="ColorID" fieldtype="id" generator="increment";
	// non-relational columns
	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	
	// many-to-many
	
	// calculated properties
	
	// object constraints
	
	// methods
	public Color function init() {
		return this;
	}
} 