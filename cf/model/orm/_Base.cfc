component displayname="_Base" mappedSuperclass="true" {
	// primary key
	
	// non-relational columns
	property name="CreatedDate" column="CreatedDate" ormtype="timestamp";
	
	// one-to-one
	
	// one-to-many
	
	// many-to-one
	
	// many-to-many
	
	// calculated properties
	
	// methods
	public _Base function init() {
		return this;
	}
	
	public function preInsert() {
		if( isNull( getCreatedDate() ) ) {
			setCreatedDate( now() );
		}
	}
} 