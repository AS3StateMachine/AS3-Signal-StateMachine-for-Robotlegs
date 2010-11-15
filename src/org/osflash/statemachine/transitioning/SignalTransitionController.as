package org.osflash.statemachine.transitioning {
import org.osflash.statemachine.base.*;
import org.osflash.statemachine.core.IFSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;
	import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.states.SignalState;

public class SignalTransitionController extends BaseTransitionController {
	private var _controller:IFSMControllerOwner;

	public function SignalTransitionController( controller:IFSMControllerOwner = null ){
		_controller = controller || new FSMController();
		_controller.addActionListener( handleAction );
		_controller.addCancelListener( handleCancel );
	}

	public function get fsmController():IFSMControllerOwner{ return _controller; }

	protected function get currentSignalState():SignalState{ return SignalState( currentState ); }

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

	override protected function setCurrentState( state:IState ):void{
		super.setCurrentState( state );
		_controller.setCurrentState( state );
	}

	override protected function dispatchGeneralStateChanged():void{
		// Notify the app generally that the state changed and what the new state is
		_controller.dispatchChanged( currentState );
	}

	override public function destroy():void{
		_controller.destroy();
		_controller = null;
		super.destroy();
	}

}
}