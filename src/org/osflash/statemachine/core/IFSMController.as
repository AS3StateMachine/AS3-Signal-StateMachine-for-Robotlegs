package org.osflash.statemachine.core {

	/**
	 * The outward-facing contract between the StateMachine and the framework actors.
	 */
	public interface IFSMController {
		/**
		 * The name of the current state.
		 */
		function get currentStateName():String;

		/**
		 * The name of the action that referred the StateMachine to its current State.
		 */
		function get referringAction():String;

		/**
		 * Indicates whether the StateMachine is undergoing a transition cycle.
		 */
		function get isTransitioning():Boolean;

		/**
		 * The current phase of the transition cycle
		 * @see TransitionPhases
		 */
		function get transitionPhase():String;

		/**
		 * Sends an action to the StateMachine, precipitating a state transition.
		 * @param actionName the name of the action.
		 * @param payload the data to be sent with the action.
		 */
		function action( actionName:String, payload:Object = null ):void;

		/**
		 * Cancels the current transition.
		 *
		 * NB: A transitions can only be cancelled during the <strong>enteringGuard</strong> or <strong>exitingGuard</strong>
		 * phases of a transition.
		 * @param reason information regarding the reason for the cancellation
		 * @param payload the data to be sent to the <strong>cancelled </strong> phase.
		 */
		function cancel( reason:String, payload:Object = null ):void;

		/**
		 * Adds a listener to the general <strong>changed</strong> phase of the transition.
		 * @param listener the method to handle the phase
		 * @return the listener Function passed as the parameter
		 */
		function addChangedListener( listener:Function ):Function;

		/**
		 * Adds a listener to the general <strong>changed</strong> phase of the transition,
		 * that is called once only, and then automagically removed.
		 * @param listener the method to handle the phase
		 * @return the listener Function passed as the parameter
		 */
		function addChangedListenerOnce( listener:Function ):Function;

		/**
		 * Removes the listener from the general <strong>changed</strong> phase of the transition.
		 * @param listener the method to remove
		 * @return the listener Function passed as the parameter
		 */
		function removeChangedListener( listener:Function ):Function;


	}
}