package commands;

class ShootAt implements Command
{
    // Shooter
    var who:Character;

    // Character beeing shot
    var target:Character;
    
    public function execute(c:Character, target:Character)
    {
        who = c;
        target = this.target;

        
    }

    public function undo()
    {
        // who
        // target
    }

}
