package org.osflash.statemachine.core {
	import org.osflash.signals.ISignal;

	/**
	 * The contract between the State and the framework.
	 *
	 * The five phases defined here use Signals
	 */
	public interface ISignalState extends IState {
		/**
		 * The ISignal handling the <strong>entered</strong> phase of this state.
		 */
		function get entered():ISignal;

		function get hasEntered():Boolean;

		/**
		 * The ISignal handling the <strong>enteringGuard</strong> phase of the state.
		 */
		function get enteringGuard():ISignal;

		function get hasEnteringGuard():Boolean;

		/**
		 * The ISignal handling the <strong>exitingGuard</strong> phase of the state.
		 */
		function get exitingGuard():ISignal;

		function get hasExitingGuard():Boolean;

		/**
		 * The ISignal handling the <strong>cancelled</strong> phase of the state.
		 */
		function get cancelled():ISignal;

		function get hasCancelled():Boolean;

		/**
		 * The ISignal handling the <strong>tearDown</strong> phase of the state.
		 */
		function get tearDown():ISignal;

		function get hasTearDown():Boolean;
	}
}