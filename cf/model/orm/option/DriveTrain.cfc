component persistent="true" entityname="DriveTrain" table="DriveTrain" extends="CarTracker.model.orm.option._Base" {
	// primary key
	property name="DriveTrainID" column="DriveTrainID" fieldtype="id" generator="increment";
	// non-relational columns
	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	
	// many-to-many
	
	// calculated properties
	
	// object constraints
	
	// methods
	public DriveTrain function init() {
		return this;
	}
} 