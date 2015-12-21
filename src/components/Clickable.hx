
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

    public var area:Rectangle;
    var shape:luxe.collision.shapes.Polygon;


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

        if(_options.events_target != null)
            events_target = _options.events_target;

        size = _options.size;
        offset = (_options.offset == null)
            ? new Vector(0,0) : _options.offset;

        in_world = (_options.in_world == null)
            ? false : _options.in_world;

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

        area = new Rectangle(entity.pos.x + offset.x, entity.pos.y + offset.y, size.x, size.y );
        shape = luxe.collision.shapes.Polygon.rectangle(area.x, area.y, area.w, area.h, false);

        Hud.shapes.push( shape );

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
            // area.w = size.x * _z;
            // area.h = size.y * _z;

            // // var _vec:Vector = Luxe.camera.world_point_to_screen( new Vector(entity.pos.x, entity.pos.y) );
            
            // // area.x = (entity.pos.x + offset.x - Luxe.camera.pos.x) * _z;
            // // area.y = (entity.pos.y + offset.y - Luxe.camera.pos.y) * _z;

            // // var _vec:Vector = Luxe.camera.world_point_to_screen( new Vector(
            // //     (entity.pos.x),
            // //     (entity.pos.y)
            // // ) );
            
            // area.x = (entity.pos.x + offset.x) * _z;
            // area.y = (entity.pos.y + offset.y) * _z;

        }
        else
        {

            area.x = entity.pos.x + offset.x;
            area.y = entity.pos.y + offset.y;

            if(entity.parent != null){
                area.x += entity.parent.pos.x;
                area.y += entity.parent.pos.y;
            }

            shape.x = area.x;
            shape.y = area.y;

        }

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
}
