/*
 ADAPTED FOR ROBOTLEGS FROM:
 PureMVC AS3 Utility - StateMachine
 Copyright (c) 2008 Neil Manuell, Cliff Hall
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.osflash.statemachine.states {
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.statemachine.base.BaseState;
	import org.osflash.statemachine.core.ISignalState;

	/**
	 * A SignalState can be injected by adding an <code>inject="true"</code> attribute
	 * to its xml state declaration. Any state injected will be against its ISignalState
	 * interface, with a name property equal to the states' name.
	 */
	public class SignalState extends BaseState implements ISignalState {
		protected var _enteringGuard:Signal;
		protected var _exitingGuard:Signal;
		protected var _entered:Signal;
		protected var _tearDown:Signal;
		protected var _cancelled:Signal;

		/**
		 * Creates an instance of a SignalState.
		 *
		 * @param name the id of the state
		 */
		public function SignalState( name:String ):void{
			super( name );
		}

		/**
		 * @inheritDoc
		 */
		public function get entered():ISignal{
			if( _entered == null )_entered = new Signal( Object );
			return _entered;
		}

		/**
		 * @inheritDoc
		 */
		public function get enteringGuard():ISignal{
			if( _enteringGuard == null ) _enteringGuard = new Signal( Object );
			return _enteringGuard
		}

		/**
		 * @inheritDoc
		 */
		public function get exitingGuard():ISignal{
			if( _exitingGuard == null ) _exitingGuard = new Signal( Object );
			return _exitingGuard;
		}

		/**
		 * @inheritDoc
		 */
		public function get cancelled():ISignal{
			if( _cancelled == null ) _cancelled = new Signal( String, Object );
			return _cancelled;
		}

		/**
		 * @inheritDoc
		 */
		public function get tearDown():ISignal{
			if( _tearDown == null ) _tearDown = new Signal();
			return _tearDown;
		}

		/**
		 * Called by the SignalTransitionController to dispatch all <strong>enteringGuard</strong>
		 * phase listeners.
		 * @param payload the data broadcast with the transition phase.
		 */
		public function dispatchEnteringGuard( payload:Object ):void{
			if( _enteringGuard == null || _enteringGuard.numListeners < 0 ) return;
			_enteringGuard.dispatch( payload );
		}

		/**
		 * Called by the SignalTransitionController to dispatch all <strong>exitingGuard</strong>
		 * phase listeners.
		 * @param payload the data broadcast with the transition phase.
		 */
		public function dispatchExitingGuard( payload:Object ):void{
			if( _exitingGuard == null || _exitingGuard.numListeners < 0 ) return;
			_exitingGuard.dispatch( payload );
		}

		/**
		 * Called by the SignalTransitionController to dispatch all <strong>tearDown</strong>
		 * phase listeners.
		 */
		public function dispatchTearDown():void{
			if( _tearDown == null || _tearDown.numListeners < 0 ) return;
			_tearDown.dispatch();
		}

		/**
		 * Called by the SignalTransitionController to dispatch all <strong>cancelled</strong>
		 * phase listeners.
		 * @param reason the reason given for the cancellation
		 * @param payload the data broadcast with the transition phase.
		 */
		public function dispatchCancelled( reason:String, payload:Object ):void{
			if( _cancelled == null || _cancelled.numListeners < 0 ) return;
			_cancelled.dispatch( reason, payload );
		}

		/**
		 * Called by the SignalTransitionController to dispatch all <strong>entered</strong>
		 * phase listeners.
		 * @param payload the data broadcast with the transition phase.
		 */
		public function dispatchEntered( payload:Object ):void{
			if( _entered == null || _entered.numListeners < 0 ) return;
			_entered.dispatch( payload );
		}

		/**
		 * The destroy method for gc
		 */
		override public function destroy():void{
			_entered.removeAll();
			_enteringGuard.removeAll();
			_exitingGuard.removeAll();
			_tearDown.removeAll();
			_cancelled.removeAll();

			_entered = null;
			_enteringGuard = null;
			_exitingGuard = null;
			_tearDown = null;
			_cancelled = null;

			super.destroy();
		}
	}
}