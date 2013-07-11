component persistent="true" entityname="UserRole" table="UserRole" extends="CarTracker.model.orm.option._Base" {
	// primary key
	property name="UserRoleID" column="UserRoleID" fieldtype="id" generator="increment";
	// non-relational columns
	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	
	// many-to-many
	
	// calculated properties
	
	// object constraints
	
	// methods
	public UserRole function init() {
		return this;
	}
} 