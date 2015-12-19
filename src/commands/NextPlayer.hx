package commands;

class NextPlayer implements Command
{
    
    public function execute()
    {
        Game.next_player();
    }

    public function undo()
    {
        Game.next_player(false);
    }

}
