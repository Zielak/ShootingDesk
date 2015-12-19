import luxe.Entity;


class Character extends Entity
{
    
    public var health:Int = 3;

    public var items:Array<Item>;

    public var distance:Int;



    override function new( options:luxe.options.EntityOptions )
    {
        options.name = 'character';
        options.name_unique = true;
        options.scene = Game.scene;
        super(options);

        items = new Array<Item>();
    }




    public function new_round()
    {
        distance = Game.options.distance;
    }

}
