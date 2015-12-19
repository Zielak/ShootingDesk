
import luxe.Entity;
import luxe.Input;
import luxe.Color;
import luxe.Rectangle;
import luxe.Scene;
import luxe.Sprite;
import luxe.States;
import luxe.Log.*;
import luxe.collision.ShapeDrawerLuxe;
import luxe.tween.Actuate;
import luxe.utils.Maths;
import luxe.utils.Random;
import luxe.Vector;
import luxe.Visual;

class Game extends State {

    public static inline var width:Int = 160;
    public static inline var height:Int = 144;

    public static var random:Random;
    public static var drawer:ShapeDrawerLuxe;
    public static var scene:Scene;

    public static var options:GameOptions;



    // Is the game over?
    public static var gameover:Bool = false;


    // playtime?
    public static var time:Float = 0;

    
    public static var commands:CommandManager;




    public var players:Array<Player>;

    public var current_player_num:Int;

    public var current_player(get,null):Player;

    public function get_current_player():Player{
        return players[current_player_num];
    }




    // User interface
    var hud:Hud;

    // Hold every kind of events here.
    // Quick for kililng events when game is over.
    var game_events:Array<String>;




    public function new(options:GameOptions)
    {
        Game.options = options;

        super({ name:'game' });

        Game.random = new Random(Math.random());
        Game.scene = new Scene('gamescene');
        Game.drawer = new ShapeDrawerLuxe();
        Game.commands = new CommandManager();

    }

    override function onenter<T>(_:T) 
    {
        reset();
        create_hud();
        init_events();

        draw_map("assets/map1.svg");


        Luxe.events.fire('game.init');

        // Luxe.timer.schedule(3, function(){
            Luxe.events.fire('game.start');
        // });

    }

    override function onleave<T>(_:T)
    {

        hud.destroy();

        kill_events();
        // Game.scene.empty();

    }

    function reset()
    {
        Game.time = 0;
        Game.gameover = false;
        Game.random.reset();
        Game.scene.empty();

        players = new Array<Player>();
        for(i in 0...Game.options.players)
        {
            players.push( new Player({}) );
        }

        Luxe.events.fire('game.reset');
    }



    function next_player(?next:Bool = true)
    {

    }

    function next_character(?next:Bool = true)
    {

    }





    function game_over(reason:String)
    {

        Game.gameover = true;
        Luxe.events.fire('game.over.${reason}');

    }

    function create_hud()
    {
        hud = new Hud({
            name: 'hud',
        });
    }


    function create_player()
    {

        // player = new Player({
        //     name: 'player',
        //     name_unique: true,
        //     texture: Luxe.resources.texture('assets/images/player.gif'),
        //     size: new Vector(16,16),
        //     pos: new Vector(160/2, 144/2),
        //     centered: true,
        //     depth: 10,
        //     scene: Game.scene,
        // });
        // player.texture.filter_mag = nearest;
        // player.texture.filter_min = nearest;

    }

    function init_events()
    {
        game_events = new Array<String>();

        // Finally start the sequence when they touch
        game_events.push( Luxe.events.listen('game.init', function(_)
        {
            trace('game.init');

            
        }) );
    }

    function kill_events()
    {
        for(s in game_events)
        {
            Luxe.events.unlisten(s);
        }
    }


    function draw_map(id:String)
    {

        var map = Luxe.resources.text(id);
        var xml:Xml = Xml.parse( map.asset.text );

        var map_size:Vector;

        for(x in xml.elementsNamed('svg')){

            var viewBox = x.get('viewBox').split(' ');

            map_size = new Vector( Std.parseFloat(viewBox[2]), Std.parseFloat(viewBox[3]) );



            break;
        }

        // Draw map ground
        var borders:Visual = new Visual({
            name: 'map_borders',
            geometry: Luxe.draw.rectangle({
                x:0, y:0, w:map_size.x, h:map_size.y,
            }),
            pos: new Vector(0,0),
            color: new Color(0.8, 0.8, 0.8),
            scene: Game.scene,
        });
        
    }



    override function update(dt:Float)
    {

        Game.time += dt;

    }




    override public function onkeydown( event:KeyEvent )
    {

        if(event.keycode == Key.key_z){
            if(commands.isUndoAvailable()){
                commands.undo();
            }else{
                trace('CommandManager: nothing to undo.');
            }
        }

    }




}


typedef GameOptions = {
    var players:Int;
    var characters:Int;
    var distance:Int;
}


typedef MapObject = {
    var type:String;
    var options:Dynamic;
}

