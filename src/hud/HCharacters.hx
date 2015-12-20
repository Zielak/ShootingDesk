package hud;

import luxe.Color;
import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Visual;
import phoenix.Batcher;

class HCharacters extends Component
{
    
    static public inline var BLOCK_WIDTH:Int = 100;
    static public inline var BLOCK_HEIGHT:Int = 100;
    static public inline var BG_PADDING:Int = 10;

    var characters:Array<HCharacterBlock>;
    var bg:Visual;
    var mark:Visual;

    // Which player am I representing now?
    var player:Player;

    var luxe_events:Array<String>;

    override function init()
    {

        init_events();
        player = Game.player;

        bg = new Visual({
            name: 'HCharacters_bg',
            pos: new Vector(
                Luxe.screen.w/2 - BLOCK_WIDTH*player.characters.length/2,
                Luxe.screen.h - BLOCK_HEIGHT - BG_PADDING*2),
            geometry: Luxe.draw.box({
                x: 0, y: 0,
                w: BLOCK_WIDTH*player.characters.length + BG_PADDING*2,
                h: BLOCK_HEIGHT + BG_PADDING*2,
                batcher: Hud.hud_batcher,
            }),
            color: new Color(0.1, 0.2, 0.1, 0.9),
            depth: 1,
        });

        add_characters();
        
        mark = new Visual({
            name: 'HCharacters_mark',
            geometry: Luxe.draw.ngon({
                x: 0, y: 0, r: 15,
                sides: 3, solid: true,
                batcher: Hud.hud_batcher,
            }),
            color: new Color(1, 1, 1),
            depth: 3,
        });
        mark.rotation_z = 60;

        update_bg();
        update_characters();
        update_mark();

    }

    override function onremoved()
    {

        for(i in characters){
            bg.remove(i.name);
        }
        characters = null;
        bg.destroy();
        mark.destroy();

        kill_events();

    }


    function init_events()
    {

        luxe_events = new Array<String>();

        luxe_events.push( Luxe.events.listen('game.next.round', function(_){
            update_characters();
            update_mark();
            update_bg();
        }));
        
        luxe_events.push( Luxe.events.listen('game.next.player', function(_){
            player = Game.player;
            reset_characters();
            // update_characters();
            update_mark();
            update_bg();
        }));
        
        luxe_events.push( Luxe.events.listen('game.next.character', function(_){
            update_characters();
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
        trace('HCharacters.update_bg()');

        // bg.scale.x = Game.players.length;

        bg.geometry.drop();
        bg.geometry = Luxe.draw.box({
            x: 0, y: 0,
            w: BLOCK_WIDTH*player.characters.length + BG_PADDING*2,
            h: BLOCK_HEIGHT + BG_PADDING*2,
            batcher: Hud.hud_batcher,
        });
        bg.depth = 1;

    }

    function update_characters()
    {
        trace('HCharacters.update_characters()');
        // Update positions
        for(i in 0...characters.length){
            characters[i].update_pos(BLOCK_WIDTH*i + BG_PADDING);
            characters[i].update_stats();
        }
    }

    function reset_characters()
    {
        remove_characters();
        add_characters();
    }

    function remove_characters()
    {
        // Dunk old characters
        for(i in characters){
            remove(i.name);
        }
    }

    function add_characters()
    {
        // Fetch new ones
        characters = new Array<HCharacterBlock>();
        for(p in player.characters)
        {
            var hpb = new HCharacterBlock(p);
            characters.push( hpb );
            bg.add( hpb );
        }
    }

    function update_mark()
    {
        trace('HCharacters.update_mark()');

        mark.pos.x = characters[Game.cur_character].pos.x + HCharacters.BLOCK_WIDTH/2 + BG_PADDING;

        mark.pos.y = characters[Game.cur_character].pos.y + BG_PADDING;
    }

}

class HCharacterBlock extends Component
{


    var block:Visual;
    var name_txt:Text;
    var character:Character;


    override function new( c:Character )
    {
        character = c;
        super({name: 'HCharacterBlock.${c.name}'});
    }

    override function onadded()
    {
        block = new Visual({
            name: 'HCharacterBlock_block',
            name_unique: true,
            pos: new Vector(Luxe.screen.w/2 - HCharacters.BLOCK_WIDTH*Game.players.length/2, HCharacters.BG_PADDING),
            geometry: Luxe.draw.box({
                x: 0, y: 0,
                w: HCharacters.BLOCK_WIDTH,
                h: HCharacters.BLOCK_HEIGHT,
                batcher: Hud.hud_batcher,
            }),
            depth: 2,
            color: new Color(0.1, 0.1, 0.1, 0.9),
            parent: entity,
        });

        name_txt = new Text({
            pos: new Vector(0,0),
            bounds: new Rectangle(0, 0, HCharacters.BLOCK_WIDTH, HCharacters.BLOCK_HEIGHT),
            point_size : 16,
            text : 'Character:\n${character.name.substring(character.name.indexOf('.', character.name.length))}',
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
        name_txt.destroy();
        character = null;
    }

    public function update_pos(x:Float)
    {
        block.pos.x = x;
    }

    public function update_stats()
    {
        var char_name = character.name.substring( character.name.indexOf('.')+1, character.name.length );

        name_txt.text = 'Character:\n${char_name}\ndist: ${character.distance}';
    }

}
