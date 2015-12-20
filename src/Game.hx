
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




    public static var players:Array<Player>;


    public static var cur_round:Int;
    public static var cur_player:Int;
    public static var cur_character:Int;

    public static var player(get,null):Player;

    public static function get_player():Player{
        return players[cur_player];
    }



    // User interface
    var hud:Hud;

    // Hold every kind of events here.
    // Quick for kililng events when game is over.
    var game_events:Array<String>;




    public function new(_options:GameOptions)
    {
        options = _options;

        super({ name:'game' });

        random = new Random(Math.random());
        scene = new Scene('gamescene');
        drawer = new ShapeDrawerLuxe();
        commands = new CommandManager();

    }

    override function onenter<T>(_:T) 
    {
        reset();
        create_hud();
        init_events();

        draw_map("assets/map1.svg");


        Luxe.events.fire('game.init');

        Luxe.timer.schedule(1, function(){
            Luxe.events.fire('game.start');
        });

    }

    override function onleave<T>(_:T)
    {

        hud.destroy();

        kill_events();
        Game.scene.empty();

    }

    function reset()
    {
        time = 0;
        gameover = false;
        random.reset();
        scene.empty();

        players = new Array<Player>();
        for(i in 0...options.players)
        {
            players.push( new Player({}) );
        }

        cur_round = 0;
        cur_player = 0;
        cur_character = 0;
    }


    function next_character(?next:Bool = true)
    {

        cur_character++;

        if(cur_character >= player.characters.length){

            next_player();

        }else{

            trace('Game: NEXT CHARACTER');
            Luxe.events.fire('game.next.character');

        }

    }

    function next_player(?next:Bool = true)
    {

        cur_character = 0;
        cur_player++;

        if(cur_player >= players.length){

            next_round();

        }else{

            trace('Game: NEXT PLAYER');
            Luxe.events.fire('game.next.player');

        }

    }

    function next_round(?next:Bool = true)
    {
        cur_player = 0;
        cur_round++;

        Luxe.events.fire('game.next.round');
    }







    function game_over(reason:String)
    {

        gameover = true;
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


    }

    function init_events()
    {
        game_events = new Array<String>();

        // Finally start the sequence when they touch
        game_events.push( Luxe.events.listen('game.init', function(_)
        {
            trace('game.init');


            
        }) );

        game_events.push( Luxe.events.listen('game.start', function(_)
        {
            trace('game.start');

            next_player();
            
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

        for(svg in xml.elementsNamed('svg')){

            var viewBox = svg.get('viewBox').split(' ');

            map_size = new Vector( Std.parseFloat(viewBox[2]), Std.parseFloat(viewBox[3]) );

            // Draw all the walls and stuff
            var map_elements = svg.elements();
            for(i in map_elements){

                if(i.nodeType != Xml.XmlType.Element) continue;

                switch(i.nodeName){
                    case 'rect': draw_rect(i);
                    case 'circle': draw_circle(i);
                    case 'path': draw_path(i);
                }

            }

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
            scene: scene,
        });
        
    }

    function draw_rect(x:Xml)
    {

        var rect:Visual = new Visual({
            name: x.get('id'),
            geometry: Luxe.draw.box({
                x: Std.parseFloat( x.get('x') ),
                y: Std.parseFloat( x.get('y') ),
                w: Std.parseFloat( x.get('width') ),
                h: Std.parseFloat( x.get('height') ),
            }),
            pos: new Vector(0,0),
            color: new Color(0.2, 0.2, 0.2),
            depth: Std.parseFloat( x.get('y') )/1000,
            scene: scene,
        });


        if(x.get('transform') != null && x.get('transform') != ''){

            // Just get "rotate" property, don't care about anything else.
            var t = x.get('transform');

            var method = t.substring(0, t.indexOf('('));
            var value = t.substring( t.indexOf('(')+1, t.indexOf(')') );
            var values = value.split(' ');

            if(method == 'rotate'){

                rect.rotation_z = Std.parseFloat( value );

            }else if(method == 'matrix'){

                rect.rotation_z = Math.atan2( Std.parseFloat(values[2]), Std.parseFloat(values[0]) ) * 180 / Math.PI;

            }
        }

    }

    function draw_circle(x:Xml)
    {

        var _player:Int = -1;
        var _character:Int = -1;

        if(x.get('player') != null && x.get('player') != ''){

            assert(x.get('character') != '', 'Character start circle should also have "character" attribute.');

            _player = Std.parseInt( x.get('player') );
            _character = Std.parseInt( x.get('character') );

        }


        // Spawn points
        var player_start:Visual = new Visual({
            name: 'player_start.${_player}.${_character}',
            geometry: Luxe.draw.ring({
                x: 0,
                y: 0,
                r: 10,
            }),
            pos: new Vector(Std.parseFloat( x.get('cx') ),Std.parseFloat( x.get('cy') )),
            color: new Color(0.7, 0.5, 0.2, 0.5),
            depth: -1,
            scene: scene,
        });

        // add that info to player
        if( players[_player] != null ){

            players[_player].add_spawn_point( player_start.pos );

        }

    }

    function draw_path( x:Xml )
    {

        var d = x.get('d');

        // Just draw a straight line with it.
        // TODO: Draw full blown path with many methods: l, L, h, H etc.
        // https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Basic_Shapes

        var m = d.substring(1, d.indexOf('l'));
        var l = d.substring(d.indexOf('l')+1, d.length);

        var ma:Array<String>;
        var la:Array<String>;

        if(m.indexOf(' ') > 0){
            ma = m.split(' ');
        }else{
            ma = [m.substring(0, m.lastIndexOf('-')),
                  m.substring(m.lastIndexOf('-'), m.length)];
        }
        if(l.indexOf(' ') > 0){
            la = l.split(' ');
        }else{
            la = [l.substring(0, l.lastIndexOf('-')),
                  l.substring(l.lastIndexOf('-'), l.length)];
        }

        trace('m: "${m}", l: "${l}"');

        var p1 = new Vector( Std.parseFloat(ma[0]), Std.parseFloat(ma[1]) );
        var p2 = new Vector( Std.parseFloat(la[0]), Std.parseFloat(la[1]) );

        var path = new Visual({
            pos: p1,
            geometry: Luxe.draw.line({
                p0: new Vector(0,0),
                p1: p2,
                color: new Color(0.2, 0.2, 0.2),
            }),
            depth: 1,
            scene: scene,
        });

    }



    override function update(dt:Float)
    {

        time += dt;

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

