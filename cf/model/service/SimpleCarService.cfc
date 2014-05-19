component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {
    /**
     * Constructor
     */
    public SimpleCarService function init() {
        super.init( entityName="SimpleCar" );
        return this;
    }

    public function getNewCars() {
        var c = newCriteria();
            c.isGT( "Year", c.convertValueToJavaType( "Year", 2012 ) );
        return c.list( max=3, asQuery = false );
    }
}