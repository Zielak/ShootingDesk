
import luxe.Log.*;

class CommandManager
{
    var last_command:Command;
 
    public function new() {}
 
    public function execute_command(c:Command)
    {
        c.execute();
        last_command = c;
    }

    public function isUndoAvailable():Bool
    {
        return last_command != null;
    }
     
    public function undo()
    {
        assert(last_command != null, 'Should undo some command, got null.');
        last_command.undo();
        last_command = null;
    }
 
}