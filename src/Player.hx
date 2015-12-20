import luxe.Color;
import luxe.Entity;
import luxe.Vector;


class Player extends Entity
{
    
    public var characters:Array<Character>;

    public var player_name:String;

    public var color:Color;




    var random_names:Array<String>;
    var spawn_points:Array<Vector>;


    override public function new( options:luxe.options.EntityOptions )
    {
        options.name = 'player';
        options.name_unique = true;
        options.scene = Game.scene;
        super(options);

        color = new Color();
        color.fromColorHSV( new phoenix.Color.ColorHSV( Math.random()*360, 1, 1 ) );

        spawn_points = new Array<Vector>();

        characters = new Array<Character>();
        for(i in 0...Game.options.characters){
            characters.push( new Character({player: this}) );
        }

        player_name = Main.get_random_name();

        Luxe.events.listen('game.start', function(_){
            // Spawn characters?
            spawn_characters();
        });
    }

    public function add_spawn_point( point:Vector )
    {
        spawn_points.push( point.clone() );
    }



    function spawn_characters()
    {

        for(i in 0...characters.length){
            
            characters[i].spawn_character( spawn_points[i] );

        }

    }


}
