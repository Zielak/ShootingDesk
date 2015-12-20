
package components;

import luxe.Color;
import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Rectangle;
import luxe.Vector;
import luxe.Visual;
import luxe.Entity;
import luxe.Input;

class Clickable extends Component
{


    public var down (get, null):Bool;

    public var over:Bool;
    @:isVar public var buttons (default, null):Map<MouseButton, Bool>;

    @:isVar public var area (default, null):Rectangle;

    var enabled:Bool = true;

    var events_target:Entity;

    var down_events :Array<String>;
    var up_events   :Array<String>;
    var over_events :Array<String>;
    var out_events  :Array<String>;

    // var pos:Vector;
    var offset:Vector;
    var size:Vector;
    var in_world:Bool = false;

    var cursor:Vector;


    var debug:Bool = false;

    var _z:Float = 0;

    override public function new(_options:ClickableOptions)
    {
        super(_options);

        over = false;

        events_target = _options.events_target;

        size = _options.size;
        offset = (_options.offset == null)
            ? new Vector(0,0) : _options.offset;

        in_world = (_options.in_world == null)
            ? false : _options.in_world;

        area = new Rectangle(offset.x, offset.y, size.x, size.y );

        cursor = new Vector(0,0);

        down_events = (_options.down_events == null)
            ? new Array<String>() : _options.down_events;

        up_events = (_options.up_events == null)
            ? new Array<String>() : _options.up_events;

        over_events = (_options.over_events == null)
            ? new Array<String>() : _options.over_events;

        out_events = (_options.out_events == null)
            ? new Array<String>() : _options.out_events;
    }

    override function init()
    {
        buttons = new Map<MouseButton, Bool>();
        buttons.set(MouseButton.extra1, false);
        buttons.set(MouseButton.extra2, false);
        buttons.set(MouseButton.left, false);
        buttons.set(MouseButton.middle, false);
        buttons.set(MouseButton.none, false);
        buttons.set(MouseButton.right, false);
    }

    override function onadded()
    {

    }

    override function onmousemove(e:MouseEvent)
    {
        if(!enabled) return;
        
        cursor = e.pos;

        if(area.point_inside( cursor ) && !over){
            over = true;
            entity.events.fire('mouseover', e);
            fire_events(over_events, e);
        }

        if(!area.point_inside( cursor ) && over){
            over = false;
            entity.events.fire('mouseout', e);
            fire_events(out_events, e);
        }
    }

    override function onmousedown(e:MouseEvent)
    {
        if(!enabled) return;

        if(over){
            buttons.set(e.button, true);

            entity.events.fire('mousedown', e);
            fire_events(down_events, e);
        }
    }

    override function onmouseup(e:MouseEvent)
    {
        if(!enabled) return;

        if(over){
            buttons.set(e.button, false);

            entity.events.fire('mouseup', e);
            fire_events(up_events, e);
        }else{
            if(down){
                down = false;
                buttons.set(e.button, false);

                entity.events.fire('mouseupoutside', e);
                fire_events(out_events, e);
            }
        }
    }

    override function update(dt:Float)
    {
        _z = Luxe.camera.zoom;
        if(in_world)
        {
            area.w = size.x * _z;
            area.h = size.y * _z;

            // var _vec:Vector = Luxe.camera.world_point_to_screen( new Vector(entity.pos.x, entity.pos.y) );
            
            // area.x = (entity.pos.x + offset.x - Luxe.camera.pos.x) * _z;
            // area.y = (entity.pos.y + offset.y - Luxe.camera.pos.y) * _z;

            // var _vec:Vector = Luxe.camera.world_point_to_screen( new Vector(
            //     (entity.pos.x),
            //     (entity.pos.y)
            // ) );
            
            area.x = (entity.pos.x + offset.x) * _z;
            area.y = (entity.pos.y + offset.y) * _z;

            if(debug){
                var _vec:Vector = Luxe.camera.world_point_to_screen( new Vector( (area.x),(area.y) ) );
                _vec.multiplyScalar(Luxe.camera.zoom);

                Game.drawer.drawShape( luxe.collision.shapes.Polygon.rectangle(_vec.x, _vec.y, area.w, area.h) );
            }
        }

        

        
        // Luxe.draw.box({
        //     x: area.x,
        //     y: area.y,
        //     w: area.w,
        //     h: area.h,
        //     color: new Color(1,0,0,0.1),
        //     batcher: Main.debug_batcher
        // });
    }



    public function set_xy(x:Float, y:Float)
    {
        // if(in_world){
        //     area.x = (x + offset.x) * Luxe.camera.zoom - size.x/2 * Luxe.camera.zoom;
        //     area.y = (y + offset.y) * Luxe.camera.zoom - size.y/2 * Luxe.camera.zoom;
        // }else{
        area.x = x + offset.x - size.x/2;
        area.y = y + offset.y - size.y/2;
        // }
    }


    function fire_events(arr:Array<String>, event:MouseEvent)
    {
        for(str in arr)
        {
            if(events_target == null){
                Luxe.events.fire(str, event);
            }else{
                events_target.events.fire(str, event);
            }
        }
    }




    public function disable()
    {
        enabled = false;
    }
    public function enable()
    {
        enabled = true;
    }


    function get_down():Bool
    {
        return buttons.get(MouseButton.left);
    }

}


typedef ClickableOptions = {
    > ComponentOptions,

    var size:Vector;
    @:optional var offset:Vector;
    @:optional var in_world:Bool;

    @:optional var events_target:Entity;
    @:optional var down_events:Array<String>;
    @:optional var up_events:Array<String>;
    @:optional var over_events:Array<String>;
    @:optional var out_events:Array<String>;

    @:optional var debug:Bool;
}
