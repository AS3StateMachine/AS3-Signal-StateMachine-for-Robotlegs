package org.osflash.statemachine.transitioning {
	import org.osflash.statemachine.base.*;
	import org.osflash.statemachine.core.IFSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;
	import org.osflash.statemachine.core.ILoggable;
	import org.osflash.statemachine.core.IState;
	import org.osflash.statemachine.states.SignalState;

	/**
	 * Encapsulates the state transition and thus the communications between
	 * FSM and framework actors using Signals.
	 */
	public class SignalTransitionController extends BaseTransitionController {

		/**
		 * @private
		 */
		private var _controller:IFSMControllerOwner;

		/**
		 * Creates an instance of the SignalTransitionController
		 * @param controller the object that acts as comms-bus
		 * between the SignalTransitionController and the framework actors.
		 */
		public function SignalTransitionController( controller:IFSMControllerOwner = null, logger:ILoggable = null ){
			super(logger);
			_controller = controller || new FSMController();
			_controller.addActionListener( handleAction );
			_controller.addCancelListener( handleCancel );
		}

		/**
		 * the IFSMController used.
		 */
		public function get fsmController():IFSMController{ return IFSMController( _controller ); }

		/**
		 * @inheritDoc
		 */
		protected function get currentSignalState():SignalState{ return SignalState( currentState ); }

		/**
		 * @inheritDoc
		 */
		override public function destroy():void{
			if(_controller!=null)_controller.destroy();
			_controller = null;
			super.destroy();
		}

		/**
		 * @inheritDoc
		 */
		override protected function onTransition( target:IState, payload:Object ):void{

			var targetState:SignalState = SignalState( target );

			// Exit the current State
			if( currentState != null && currentSignalState.hasExitingGuard ){
				_controller.setTransitionPhase( TransitionPhases.EXITING_GUARD);
				log("CURRENT STATE: " + currentState.name + ", PHASE DISPATCHED: " + TransitionPhases.EXITING_GUARD);
				currentSignalState.dispatchExitingGuard( payload );
			}


			// Check to see whether the exiting guard has been canceled
			if( isCanceled  )return;

			// Enter the next State
			if( targetState.hasEnteringGuard ){
				_controller.setTransitionPhase( TransitionPhases.ENTERING_GUARD);
				log("TARGET STATE: " + targetState.name +  ", PHASE DISPATCHED: " + TransitionPhases.ENTERING_GUARD);
				targetState.dispatchEnteringGuard( payload );
			}

			// Check to see whether the entering guard has been canceled
			if( isCanceled ){
				return;
			}

			// teardown current state
			if( currentState != null && currentSignalState.hasTearDown ){
				_controller.setTransitionPhase( TransitionPhases.TEAR_DOWN);
				log("CURRENT STATE: " + currentState.name +  ", PHASE DISPATCHED: " + TransitionPhases.TEAR_DOWN);
				currentSignalState.dispatchTearDown();
			}

			setCurrentState( targetState );
			log("CURRENT STATE CHANGED: " + currentState.name );

			// Send the notification configured to be sent when this specific state becomes current
			if( currentSignalState.hasEntered ){
				_controller.setTransitionPhase( TransitionPhases.ENTERED);
				log("CURRENT STATE: " + currentState.name +  ", PHASE DISPATCHED: " + TransitionPhases.ENTERED);
				currentSignalState.dispatchEntered( payload );
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function setCurrentState( state:IState ):void{
			super.setCurrentState( state );
			_controller.setCurrentState( state );
		}

		/**
		 * @inheritDoc
		 */
		override protected function dispatchGeneralStateChanged():void{
			// Notify the app generally th  at the state changed and what the new state is
			if( _controller.hasChangedListener ){
				_controller.setTransitionPhase( TransitionPhases.GLOBAL_CHANGED);
				log( "PHASE DISPATCHED: " + TransitionPhases.GLOBAL_CHANGED );
				_controller.dispatchChanged( currentState.name );
			}
			_controller.setTransitionPhase( TransitionPhases.NONE);
		}
		/**
		 * @inheritDoc
		 */
		override protected function dispatchCancelled():void{
				if( currentState != null && currentSignalState.hasCancelled ){
					_controller.setTransitionPhase( TransitionPhases.CANCELLED);
					log( "CURRENT STATE: " + currentState.name +  ", PHASE DISPATCHED: " + TransitionPhases.CANCELLED);
					currentSignalState.dispatchCancelled( cancellationReason, cachedPayload );
				}
			_controller.setTransitionPhase( TransitionPhases.NONE);
		}

		override protected function setIsTransitioning( value:Boolean ):void{
			super.setIsTransitioning( value );
			_controller.setIsTransition( value )
		}

	}
}