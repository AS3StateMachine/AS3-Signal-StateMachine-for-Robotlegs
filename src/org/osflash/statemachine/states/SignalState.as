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
	import org.osflash.statemachine.signals.Cancelled;
	import org.osflash.statemachine.signals.Entered;
	import org.osflash.statemachine.signals.EnteringGuard;
	import org.osflash.statemachine.signals.ExitingGuard;
	import org.osflash.statemachine.signals.TearDown;

	/**
	 * A SignalState defines five transition phases as Signals. 
	 */
	public class SignalState extends BaseState implements ISignalState {

		/**
		 * @private
		 */
		protected var _enteringGuard:Signal;

		/**
		 * @private
		 */
		protected var _exitingGuard:Signal;

		/**
		 * @private
		 */
		protected var _entered:Signal;

		/**
		 * @private
		 */
		protected var _tearDown:Signal;

		/**
		 * @private
		 */
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
			if( _entered == null )_entered = new Entered( );
			return _entered;
		}

		/**
		 * @inheritDoc
		 */
		public function get enteringGuard():ISignal{
			if( _enteringGuard == null ) _enteringGuard = new EnteringGuard();
			return _enteringGuard
		}

		/**
		 * @inheritDoc
		 */
		public function get exitingGuard():ISignal{
			if( _exitingGuard == null ) _exitingGuard = new ExitingGuard();
			return _exitingGuard;
		}

		/**
		 * @inheritDoc
		 */
		public function get cancelled():ISignal{
			if( _cancelled == null ) _cancelled = new Cancelled();
			return _cancelled;
		}

		/**
		 * @inheritDoc
		 */
		public function get tearDown():ISignal{
			if( _tearDown == null ) _tearDown = new TearDown();
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
			
			if(_entered != null) _entered.removeAll();
			if(_enteringGuard != null) _enteringGuard.removeAll();
			if(_exitingGuard != null) _exitingGuard.removeAll();
			if(_tearDown != null) _tearDown.removeAll();
			if(_cancelled != null) _cancelled.removeAll();

			_entered = null;
			_enteringGuard = null;
			_exitingGuard = null;
			_tearDown = null;
			_cancelled = null;

			super.destroy();
		}

		public function get hasEntered():Boolean{
			return ( _entered != null);
		}

		public function get hasEnteringGuard():Boolean{
			return ( _enteringGuard != null);
		}

		public function get hasExitingGuard():Boolean{
			return ( _exitingGuard != null);
		}

		public function get hasCancelled():Boolean{
			return ( _cancelled != null);
		}

		public function get hasTearDown():Boolean{
			return ( _tearDown != null);
		}
	}
}