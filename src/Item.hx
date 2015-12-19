import luxe.Entity;


class Item extends Entity
{
    
    public var damage:Values;

    override function new( options:ItemOptions )
    {
        options.name = 'item';
        options.name_unique = true;
        options.scene = Game.scene;
        super(options);

        damage = options.damage;

    }




    public function new_round()
    {

    }

}

typedef ItemOptions = {
    > luxe.options.EntityOptions,

    var damage:Values;
}
