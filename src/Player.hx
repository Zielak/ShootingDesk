import luxe.Entity;


class Player extends Entity
{
    
    public var characters:Array<Character>;

    public var player_name:String;




    var random_names:Array<String>;


    override public function new( options:luxe.options.EntityOptions )
    {
        options.name = 'player';
        options.name_unique = true;
        options.scene = Game.scene;
        super(options);

        characters = new Array<Character>();
        for(i in 0...Game.options.characters){
            characters.push( new Character({}) );
        }

        player_name = Main.get_random_name();
    }


}
