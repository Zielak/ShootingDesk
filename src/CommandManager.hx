
import luxe.Log.*;

class CommandManager
{
    var history:Array<Command>;
 
    public function new()
    {
        history = new Array<Command>();
    }
 
    public function execute_command(c:Command)
    {
        c.execute();
        history.push(c);
    }

    public function isUndoAvailable():Bool
    {
        return history.length > 0;
    }
     
    public function undo()
    {
        assert(isUndoAvailable(), 'History is empty.');

        history[history.length-1].undo();
        history.pop();
    }
 
}