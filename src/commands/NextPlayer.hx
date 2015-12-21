package commands;

class NextPlayer implements Command
{

    public function new() {}
    
    public function execute()
    {
        Luxe.events.fire('command.next_player', true);
    }

    public function undo()
    {
        Luxe.events.fire('command.next_player', false);
    }

}
