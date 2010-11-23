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

		/**
		 * The ISignal handling the <strong>enteringGuard</strong> phase of the state.
		 */
		function get enteringGuard():ISignal;

		/**
		 * The ISignal handling the <strong>exitingGuard</strong> phase of the state.
		 */
		function get exitingGuard():ISignal;

		/**
		 * The ISignal handling the <strong>cancelled</strong> phase of the state.
		 */
		function get cancelled():ISignal;

		/**
		 * The ISignal handling the <strong>tearDown</strong> phase of the state.
		 */
		function get tearDown():ISignal;
	}
}