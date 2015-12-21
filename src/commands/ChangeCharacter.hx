package commands;

import luxe.Log.*;

class ChangeCharacter implements Command
{

    var character:Character;

    var last_character:Int;
    var new_character:Int;

    public function new( c:Character )
    {
        character = c;
    }
    
    public function execute()
    {

        // find proper idx from players chars table
        new_character = character.player.characters.indexOf(character);
        assert(new_character >= 0, 'Is character in current team?');

        last_character = Game.cur_character;
        Luxe.events.fire('command.change_character', new_character);
        // Game.change_character( new_character );

    }

    public function undo()
    {
        // Game.change_character( last_character );
        Luxe.events.fire('command.change_character', last_character);
    }

}


