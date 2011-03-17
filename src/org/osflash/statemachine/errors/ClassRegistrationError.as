package org.osflash.statemachine.errors {
/**
 * Thrown a command declared in the state declaration xml has not been
 * added to the SignalStateDecoder
 *
 * @see org.osflash.statemachine.decoding.SignalXMLStateDecoder
 */
public class ClassRegistrationError extends Error {

    public static const COMMAND_CLASS_NOT_REGISTERED:String = "These commands need to be added to the StateDecoder: ";
    public static const COMMAND_CLASS_CAN_BE_MAPPED_ONCE_ONLY_TO_SAME_SIGNAL:String = "A command class can be mapped once only to the same signal: ";
	public function ClassRegistrationError( msg:String ){
		super(  msg );
	}
}
}