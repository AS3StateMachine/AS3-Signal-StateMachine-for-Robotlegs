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
			_controller.destroy();
			super.destroy();
		}

		/**
		 * @inheritDoc
		 */
		override protected function onTransition( target:IState, payload:Object ):void{

			var targetState:SignalState = SignalState( target );

			setReferringAction( );

			// Exit the current State
			if( currentState != null && currentSignalState.hasExitingGuard ){
				_controller.setTransitionPhase( TransitionPhase.EXITING_GUARD);
				logPhase( TransitionPhase.EXITING_GUARD, currentState.name);
				currentSignalState.dispatchExitingGuard( payload );
			}


			// Check to see whether the exiting guard has been canceled
			if( isCanceled  )return;

			// Enter the next State
			if( targetState.hasEnteringGuard ){
				_controller.setTransitionPhase( TransitionPhase.ENTERING_GUARD);
				logPhase( TransitionPhase.ENTERING_GUARD, targetState.name);
				targetState.dispatchEnteringGuard( payload );
			}

			// Check to see whether the entering guard has been canceled
			if( isCanceled ){
				return;
			}

			// teardown current state
			if( currentState != null && currentSignalState.hasTearDown ){
				_controller.setTransitionPhase( TransitionPhase.TEAR_DOWN);
				logPhase( TransitionPhase.TEAR_DOWN, currentState.name);
				currentSignalState.dispatchTearDown();
			}

			setCurrentState( targetState );
			log("CURRENT STATE CHANGED TO: " + currentState.name );

			// Send the notification configured to be sent when this specific state becomes current
			if( currentSignalState.hasEntered ){
				_controller.setTransitionPhase( TransitionPhase.ENTERED);
				logPhase(TransitionPhase.ENTERED, currentState.name);
				currentSignalState.dispatchEntered( payload );
			}

		}

		private function setReferringAction(  ):void{
			if( currentState == null )return;
			_controller.setReferringAction( currentState.referringAction );
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
				_controller.setTransitionPhase( TransitionPhase.GLOBAL_CHANGED);
				logPhase(TransitionPhase.GLOBAL_CHANGED );
				_controller.dispatchChanged( currentState.name );
			}
			_controller.setTransitionPhase( TransitionPhase.NONE);
		}
		/**
		 * @inheritDoc
		 */
		override protected function dispatchCancelled():void{
				if( currentState != null && currentSignalState.hasCancelled ){
					_controller.setTransitionPhase( TransitionPhase.CANCELLED);
					logPhase( TransitionPhase.CANCELLED,  currentState.name);
					currentSignalState.dispatchCancelled( cancellationReason, cachedPayload );
				}
			_controller.setTransitionPhase( TransitionPhase.NONE);
		}

		override protected function setIsTransitioning( value:Boolean ):void{
			super.setIsTransitioning( value );
				_controller.setIsTransition( value );
		}

	}
}