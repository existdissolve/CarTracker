component persistent="true" entityname="Make" table="Make" extends="CarTracker.model.orm.option._Base" {
	// primary key
	property name="MakeID" column="MakeID" fieldtype="id" generator="increment";
	// non-relational columns
	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	
	// many-to-many
	
	// calculated properties
	
	// object constraints
	
	// methods
	public Make function init() {
		return this;
	}
} 