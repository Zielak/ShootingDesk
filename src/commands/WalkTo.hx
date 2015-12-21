package commands;

import luxe.Vector;

import luxe.Log.*;

class WalkTo implements Command
{
    var character:Character;

    var last_pos:Vector;
    var new_pos:Vector;

    public function new( c:Character, pos:Vector )
    {
        character = c;
        new_pos = pos;
    }

    public function execute()
    {

        last_pos = character.pos.clone();

        character.pos.copy_from(new_pos);
        
    }

    public function undo()
    {
        character.pos.copy_from(last_pos);
    }

}
