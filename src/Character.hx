import luxe.Color;
import luxe.Entity;
import luxe.Text;
import luxe.Vector;
import luxe.Visual;


class Character extends Entity
{
    
    // Which player's is this character?
    public var player:Player;

    public var health:Int = 3;

    public var items:Array<Item>;

    public var distance:Int;



    var luxe_events:Array<String>;

    var body:Visual;
    var text:Text;


    override function new( options:CharacterOptions )
    {
        options.name = 'character';
        options.name_unique = true;
        options.scene = Game.scene;

        super(options);

        player = options.player;

        items = new Array<Item>();

        init_events();
    }

    override function ondestroy()
    {
        kill_events();
    }


    public function new_round()
    {
        distance = Game.options.distance;
    }





    public function spawn_character(p:Vector)
    {
        if(body != null) throw 'Character already has a body, what happened?';

        trace('spawn_character(${p});');

        pos.copy_from(p);

        // Draw visual body
        body = new Visual({
            name: this.name,
            geometry: Luxe.draw.ngon({
                x:0, y:0, r:10,
                sides: 6,
                solid: true,
            }),
            pos: new Vector(0,0),
            color: player.color,
            depth: 2,
            scene: options.scene,
            parent: this,
        });

        text = new Text({
            pos : new Vector(0, -20),
            size: new Vector(50, 10),
            point_size : 8,
            depth : 10,
            align : TextAlign.center,
            text : this.name.substring(this.name.indexOf('.')+1, this.name.length),
            color : new Color().rgb(0x555555),
            parent: body,
        });
    }

    function init_events()
    {

        luxe_events = new Array<String>();

        luxe_events.push( Luxe.events.listen('game.next.round', function(_){
            new_round();
        }));
        new_round();

    }

    function kill_events()
    {
        for(s in luxe_events)
        {
            Luxe.events.unlisten(s);
        }
    }

}

typedef CharacterOptions = {
    > luxe.options.EntityOptions,

    var player:Player;
}

