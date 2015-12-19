package commands;

class WalkTo implements Command
{
    var who:Character;

    public function execute(c:Character)
    {
        who = c;

        
    }

    public function undo()
    {
        // c.something
    }

}
