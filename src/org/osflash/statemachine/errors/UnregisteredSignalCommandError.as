package org.osflash.statemachine.errors {
/**
 * Thrown a command declared in the state declaration xml has not been
 * added to the SignalStateDecoder
 *
 * @see org.osflash.statemachine.decoding.SignalXMLStateDecoder
 */
public class UnregisteredSignalCommandError extends Error {
	public function UnregisteredSignalCommandError( item:String ){
		super( "These commands need to be added to the StateDecoder: " + item );
	}
}
}