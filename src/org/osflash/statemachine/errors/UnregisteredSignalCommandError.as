package org.osflash.statemachine.errors   {
public class UnregisteredSignalCommandError extends Error {
    public function UnregisteredSignalCommandError( item:String ) {
        super( "This command needs to be added to the StateDecoder: " + item );
    }
}
}