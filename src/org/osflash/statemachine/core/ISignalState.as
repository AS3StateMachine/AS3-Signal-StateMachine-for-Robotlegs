package org.osflash.statemachine.core {
	import org.osflash.signals.ISignal;

	/**
	 * The contract between the State and the framework.
	 * Any state injected will be injected to this interface, with a name property
	 * equal to the states' name.
	 */
	public interface ISignalState extends IState {
		/**
		 * The ISignal handling the <strong>entered</strong> phase of the state transition
		 */
		function get entered():ISignal;

		/**
		 * The ISignal handling the <strong>enteringGuard</strong> phase of the state transition
		 */
		function get enteringGuard():ISignal;

		/**
		 * The ISignal handling the <strong>exitingGuard</strong> phase of the state transition
		 */
		function get exitingGuard():ISignal;

		/**
		 * The ISignal handling the <strong>cancelled</strong> phase of the state transition
		 */
		function get cancelled():ISignal;

		/**
		 * The ISignal handling the <strong>tearDown</strong> phase of the state transition
		 */
		function get tearDown():ISignal;
	}
}