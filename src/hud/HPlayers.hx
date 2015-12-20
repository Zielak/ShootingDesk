package hud;

import luxe.Color;
import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Visual;
import phoenix.Batcher;

class HPlayers extends Component
{
    
    static public inline var BLOCK_WIDTH:Int = 100;
    static public inline var BLOCK_HEIGHT:Int = 100;
    static public inline var BG_PADDING:Int = 10;

    var players:Array<HPlayerBlock>;
    var bg:Visual;
    var mark:Visual;


    var luxe_events:Array<String>;

    override function init()
    {

        init_events();

        bg = new Visual({
            name: 'HPlayers_bg',
            pos: new Vector(Luxe.screen.w/2 - BLOCK_WIDTH*Game.players.length/2, 0),
            geometry: Luxe.draw.box({
                x: 0, y: 0,
                w: BLOCK_WIDTH*Game.players.length + BG_PADDING*2,
                h: BLOCK_HEIGHT + BG_PADDING*2,
                batcher: Hud.hud_batcher,
            }),
            color: new Color(0.3, 0.3, 0.4, 0.8),
            depth: 1,
        });


        players = new Array<HPlayerBlock>();
        for(p in Game.players)
        {
            var hpb = new HPlayerBlock(p);
            players.push( hpb );
            bg.add( hpb );
        }
        
        mark = new Visual({
            name: 'HPlayers_mark',
            geometry: Luxe.draw.ngon({
                x: 0, y: 0, r: 15,
                sides: 3, solid: true,
                batcher: Hud.hud_batcher,
            }),
            color: new Color(1, 1, 1),
            depth: 3,
        });

        update_bg();
        update_players();
        update_mark();

    }

    override function onremoved()
    {
        for(i in players){
            bg.remove(i.name);
        }
        players = null;
        bg.destroy();
        mark.destroy();

        kill_events();
    }


    function init_events()
    {
        luxe_events = new Array<String>();

        luxe_events.push( Luxe.events.listen('game.next.round', function(_){
            update_players();
            update_mark();
            update_bg();
        }));
        
        luxe_events.push( Luxe.events.listen('game.next.player', function(_){
            update_players();
            update_mark();
            update_bg();
        }));
        
        luxe_events.push( Luxe.events.listen('game.next.character', function(_){
            update_players();
        }));

    }

    function kill_events()
    {
        for(s in luxe_events)
        {
            Luxe.events.unlisten(s);
        }
    }

    function update_bg()
    {
        trace('HPlayers.update_bg()');

        // bg.scale.x = Game.players.length;

        bg.geometry.drop();
        bg.geometry = Luxe.draw.box({
            x: 0, y: 0,
            w: BLOCK_WIDTH*Game.players.length + BG_PADDING*2,
            h: BLOCK_HEIGHT + BG_PADDING*2,
            batcher: Hud.hud_batcher,
        });
        bg.depth = 1;

    }

    function update_players()
    {
        trace('HPlayers.update_players()');
        // Update positions
        for(i in 0...players.length){
            players[i].update_pos(BLOCK_WIDTH*i + BG_PADDING);
        }
    }

    function update_mark()
    {
        trace('HPlayers.update_mark()');
        mark.pos.x = players[Game.cur_player].pos.x + HPlayers.BLOCK_WIDTH/2 + BG_PADDING;
        mark.pos.y = players[Game.cur_player].pos.y + HPlayers.BLOCK_HEIGHT+BG_PADDING;
    }

}

class HPlayerBlock extends Component
{


    var block:Visual;
    var color_block:Visual;
    var name_txt:Text;
    var player:Player;


    override function new( p:Player )
    {
        player = p;
        super({name: 'HPlayerBlock.${p.name}'});
    }

    override function onadded()
    {

        block = new Visual({
            name: 'HPlayerBlock_block',
            name_unique: true,
            pos: new Vector(Luxe.screen.w/2 - HPlayers.BLOCK_WIDTH*Game.players.length/2, HPlayers.BG_PADDING),
            geometry: Luxe.draw.box({
                x: 0, y: 0,
                w: HPlayers.BLOCK_WIDTH,
                h: HPlayers.BLOCK_HEIGHT,
                batcher: Hud.hud_batcher,
            }),
            depth: 2,
            color: new Color(0.1, 0.1, 0.1, 0.9),
            parent: entity,
        });

        color_block = new Visual({
            name: 'HPlayerBlock_color_block',
            name_unique: true,
            pos: new Vector(0, HPlayers.BLOCK_HEIGHT - 10 ),
            geometry: Luxe.draw.box({
                x: 0, y: 0,
                w: HPlayers.BLOCK_WIDTH,
                h: 10,
                batcher: Hud.hud_batcher,
            }),
            depth: 2.1,
            color: player.color,
            parent: block,
        });

        name_txt = new Text({
            pos: new Vector(0,0),
            bounds: new Rectangle(0, 0, HPlayers.BLOCK_WIDTH, HPlayers.BLOCK_HEIGHT),
            point_size : 16,
            text : 'Player:\n${player.player_name}',
            align : center,
            align_vertical : center,
            color : new Color().rgb(0xFFFFFF),
            batcher : Hud.hud_batcher,
            depth: 3,
            parent: block,
        });

    }

    override function onremoved()
    {
        block.destroy();
        color_block.destroy();
        name_txt.destroy();
        player = null;
    }

    public function update_pos(x:Float)
    {
        block.pos.x = x;
    }

}
