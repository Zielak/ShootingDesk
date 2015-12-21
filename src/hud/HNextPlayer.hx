package hud;

import luxe.Color;
import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Visual;
import phoenix.Batcher;

class HNextPlayer extends Component
{
    
    static public inline var BLOCK_WIDTH:Int = 120;
    static public inline var BLOCK_HEIGHT:Int = 50;


    var block:Visual;
    var txt:Text;

    override function onadded()
    {

        block = new Visual({
            name: 'HNextPlayer_block',
            name_unique: true,
            pos: new Vector(Luxe.screen.w-BLOCK_WIDTH-10,
                Luxe.screen.h-10-HCharacters.BLOCK_HEIGHT-HCharacters.BG_PADDING*2 - BLOCK_HEIGHT),
            geometry: Luxe.draw.box({
                x: 0, y: 0,
                w: BLOCK_WIDTH,
                h: BLOCK_HEIGHT,
                batcher: Hud.hud_batcher,
            }),
            depth: 2,
            color: new Color(0.4, 0.6, 0.1, 0.8),
        });

        block.add(new components.Clickable({
            name: 'clickable',
            size: new Vector(BLOCK_WIDTH, BLOCK_HEIGHT),
        }));

        block.events.listen('mouseover', function(_){
            block.color.a = 1;
        });
        block.events.listen('mouseout', function(_){
            block.color.a = 0.8;
        });
        block.events.listen('mousedown', function(_){
            Luxe.events.fire('ui.next_player');
        });

        txt = new Text({
            name: 'button_labelNEXTPLAYER',
            pos: new Vector(0,0),
            bounds: new Rectangle(0, 0, BLOCK_WIDTH, BLOCK_HEIGHT),
            point_size : 16,
            text : 'NEXT PLAYER',
            align : center,
            align_vertical : center,
            color : new Color().rgb(0xFFFFFF),
            batcher : Hud.hud_batcher,
            depth: 3,
            parent: block,
        });



    }

}
