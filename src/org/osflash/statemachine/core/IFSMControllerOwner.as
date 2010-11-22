package org.osflash.statemachine.core {

	/**
	 * The inward-facing interface between the FSMController and the
	 * SignalTransitionController
	 */
	public interface IFSMControllerOwner {
		/**
		 * Allows the SignalTransitionController to listen to framework action requests.
		 * @param listener the method to handle the action request
		 * @return the listener Function passed as the parameter
		 */
		function addActionListener( listener:Function ):Function;

		/**
		 * Allows the SignalTransitionController to listen to framework cancel requests.
		 * @param listener the method to handle the cancel request
		 * @return the listener Function passed as the parameter
		 */
		function addCancelListener( listener:Function ):Function;

		/**
		 * Dispatches the general <strong>changed</strong> phase to all framework
		 * listeners.
		 * @param state the current state.
		 */
		function dispatchChanged( state:IState ):void

		/**
		 * Sets the current state when the transition has been successful
		 * @param state the state that is to be the current state
		 */
		function setCurrentState( state:IState ):void;

		/**
		 * The destroy method for GC
		 */
		function destroy():void;
	}
}