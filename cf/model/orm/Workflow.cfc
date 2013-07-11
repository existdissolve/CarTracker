component entityName="Workflow" table="Workflow" persistent=true extends="CarTracker.model.orm._Base" {
	// primary key
	property name="WorkflowID" column="WorkflowID" fieldtype="id" generator="increment";
	// non-relational columns
	property name="Notes" column="Notes" ormtype="string";
	property name="Approved" column="Approved" ormtype="boolean";	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	property name="Car" column="CarID" fieldtype="many-to-one" cfc="CarTracker.model.orm.Car" fkcolumn="CarID";
	property name="LastStatus" column="LastStatusID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Status" fkcolumn="LastStatusID";
	property name="NextStatus" column="NextStatusID" fieldtype="many-to-one" cfc="CarTracker.model.orm.option.Status" fkcolumn="NextStatusID";
	property name="Staff" column="StaffID" fieldtype="many-to-one" cfc="CarTracker.model.orm.Staff" fkcolumn="StaffID";
	// many-to-many

	// calculated properties
	
	// object constraints
	this.constraints = {};
	
	// methods
	public Workflow function init() {
		return this;
	}
} 