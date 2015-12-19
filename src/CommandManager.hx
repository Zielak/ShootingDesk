
class CommandManager
{
    private var last_command:Command;
 
    public function new() {}
 
    public function execute_command( c:Command)
    {
        c.execute();
        lastCommand = c;
    }
 
}