
import luxe.collision.shapes.*;
import luxe.collision.ShapeDrawerLuxe;
import luxe.Color;
import luxe.Input;
import luxe.options.DrawOptions;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Physics;
import luxe.Rectangle;
import luxe.Scene;
import luxe.Sprite;
import luxe.States;
import luxe.Text;
import luxe.utils.Random;
import luxe.Vector;

class Main extends luxe.Game
{

    public static var random:Random;

    public static var random_names:Array<String>;

    public static var drawer:ShapeDrawerLuxe;
    public static var shapes:Array<Shape>;


    //      DUDE, it's Luxe.screen.w ...
    // public static var width     (get, null):Float;
    // public static var height    (get, null):Float;

    // Everything happens in States!
    var machine:States;




    override function config(config:luxe.AppConfig)
    {

        return config;

    } //config

    override function ready()
    {

        random_names = ["Shona","Jeffie","Delicia","Lucie","Cristopher","Buffy","Edythe","Carley","Leda","Kathryne","Marita","Riva","Londa","Karma","Melodee","Mozell","Dong","Willetta","Raymonde","Trena","Elayne","Hans","Dirk","Patrice","My","Sona","Chan","Yevette","Stacey","Wilfredo","Von","Twana","Gena","Clarisa","Tashina","Gudrun","Emery","Phung","Neva","Marlana","Kerrie","Harold","Albert","Guillermina","Jonelle","Bailey","Alise","Magnolia","Hollis","Lani","Kia","Rosalva","Susy","Ali","Lakita","Jeneva","Eldon","Ami","Mirta","Nelle","Blake","Breanne","Delphine","Samatha","Kizzy","Granville","Madeleine","Ginny","Johna","Imelda","Caridad","Charolette","Jerri","Laronda","Jeana","Phylicia","Joycelyn","Kaitlin","Brittani","Shonda","Luisa","Collin","Celinda","Dawne","Shaquana","Sammie","Jarvis","Elmira","Romeo","Lester","Williemae","Tyler","Aja","Nieves","Providencia","Sheba","Ettie","Isobel","Florida","Paris","Charlie","Amanda","Willie","Brenda","Karen","Russell","Sara","Randy","Julie","Anne","Bob","Clark","Darek"];

        preload_assets();

        shapes = [];
        drawer = new ShapeDrawerLuxe();

    } //ready


    override function onkeyup( e:KeyEvent )
    {

        if(e.keycode == Key.escape)
        {
            Luxe.shutdown();
        }
        // if(e.keycode == Key.key_n)
        // {
        //     Main.physics.paused = !Main.physics.paused;
        // }
        // if(e.keycode == Key.key_m && Main.physics.paused)
        // {
        //     Main.physics.forceStep();
        // }


    } //onkeyup

    override function onmousemove( e:MouseEvent )
    {
        
    } // onmousemove

    override function update(dt:Float)
    {

    } //update


    /**
     * Shader stuff
     */
    override function onprerender()
    {

        for(shape in shapes) drawer.drawShape(shape);

        if(Hud.drawer != null)
        {
            for(shape in Hud.shapes) Hud.drawer.drawShape(shape);
        }

        // if(hud != null){
        //     if(hud.has('grayscaleshader')){
        //         hud.get('grayscaleshader').onprerender();
        //     }
        // }
    }

    override function onpostrender()
    {
        // if(hud != null){
        //     hud.hud_batcher.draw();
        //     if(hud.has('grayscaleshader')){
        //         hud.get('grayscaleshader').onpostrender();
        //     }
        // }
    }


    public static function get_random_name():String
    {
        return random_names[Math.floor( Math.random()*random_names.length )];
    }




// Internal
    
    function preload_assets()
    {
        var parcel = new Parcel({
            // textures: [
            //     { id:'assets/dg_logo.gif' },
            // ],
            texts: [
                { id:'assets/map1.svg' }
            ]
        });

        new ParcelProgress({
            parcel      : parcel,
            background  : new Color(0,0,0,0.85),
            oncomplete  : assets_loaded,
        });

            //go!
        parcel.load();

    } // preload_assets


    function init_states()
    {
        // Machines
        machine = new States({ name:'statemachine' });

        machine.add( new Game({
            players: 2,
            characters: 5,
            distance: 10,
        }) );
        
        machine.set('game');
        
    }



    function assets_loaded(_)
    {

        Luxe.renderer.clear_color = new Color().rgb(0x000000);

        
        // Luxe.timer.schedule(3, function(){
            init_states();
        // });

        Luxe.events.fire('game.assets.loaded');

    } // assets_loaded


} //Main
