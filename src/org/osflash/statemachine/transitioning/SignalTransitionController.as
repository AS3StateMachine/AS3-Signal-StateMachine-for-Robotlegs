package org.osflash.statemachine.transitioning {
import org.osflash.statemachine.base.*;
import org.osflash.statemachine.core.IFSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;
	import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.states.SignalState;

	/**
	 * Encapsulates the state transition and thus the communications between
	 * FSM and framework actors using Signals.
	 */
public class SignalTransitionController extends BaseTransitionController {

	private var _controller:IFSMControllerOwner;

	/**
	 * Creates an instance of the SignalTransitionController
	 * @param controller the object that acts as comms-bus
	 * between the SignalTransitionController and the framework actors.
	 */
	public function SignalTransitionController( controller:IFSMControllerOwner = null ){
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
		_controller = null;
		super.destroy();
	}

	/**
	 * @inheritDoc
	 */
	override protected function onTransition( target:IState, payload:Object ):void{

		var targetState:SignalState = SignalState( target );

		// Exit the current State
		if( currentState != null )
			currentSignalState.dispatchExitingGuard( payload );

		// Check to see whether the exiting guard has been canceled
		if( isCanceled ){
			if( currentState != null )
				currentSignalState.dispatchCancelled( cancellationReason, cachedPayload || payload );
			return;
		}

		// Enter the next State
		targetState.dispatchEnteringGuard( payload );

		// Check to see whether the entering guard has been canceled
		if( isCanceled ){
			if( currentState != null )
				currentSignalState.dispatchCancelled( cancellationReason, cachedPayload || payload );
			return;
		}

		// teardown current state
		if( currentState != null )
			currentSignalState.dispatchTearDown();

		setCurrentState( targetState );

		// Send the notification configured to be sent when this specific state becomes current
		currentSignalState.dispatchEntered( payload );

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
		// Notify the app generally that the state changed and what the new state is
		_controller.dispatchChanged( currentState );
	}

}
}