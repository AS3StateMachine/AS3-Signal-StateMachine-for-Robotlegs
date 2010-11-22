package org.osflash.statemachine.errors {
/**
 * Thrown a command declared in the state declaration xml has not been
 * added to the SignalStateDecoder
 *
 * @see org.osflash.statemachine.decoding.SignalStateDecoder
 */
public class UnregisteredSignalCommandError extends Error {
	public function UnregisteredSignalCommandError( item:String ){
		super( "This command needs to be added to the StateDecoder: " + item );
	}
}
}