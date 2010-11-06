package org.osflash.statemachine.transitioning {
import org.flexunit.Assert;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.states.SignalState;

public class SignalTransitionController_CancelEnteringTransitionTest extends SignalTransitionController {

	private var _data:Object = {};
	private var _cancellationData:Object = {};
	private var _cancelationReason:String = "reason/test";
	private var _targetState:SignalState;
	private var _hasOnExitedCurrentBeenCalled:Boolean;
	private var _hasOnEnteredTargetBeenCalled:Boolean;
	private var _hasOnEnterededTargetBeenCalled:Boolean;
	private var _hasOnTearDownCurrentBeenCalled:Boolean;
	private var _hasOnChangedBeenCalled:Boolean;
	private var _currentState:SignalState;
	private var _hasOnCancelledCurrentBeenCalled:Boolean;

	[Test]
	public function test():void{

		_currentState =  new SignalState( "state/current" );
		_targetState = new SignalState( "state/target" );
		setCurrentState(_currentState );

		// add listeners to current state signals
		currentSignalState.exitingGuard.add( onExitingCurrent );
		currentSignalState.tearDown.add( onTearDownCurrent );
		currentSignalState.cancelled.add( onCancelledCurrent );
		currentSignalState.enteringGuard.add( onEnteringCurrent );
		currentSignalState.entered.add( onEnteredCurrent );

		// add listeners to target state signals
		_targetState.enteringGuard.add( onEnteringTarget );
		_targetState.entered.add( onEnteredTarget );
		_targetState.exitingGuard.add( onExitingTarget );
		_targetState.tearDown.add( onTearDownTarget );
		_targetState.cancelled.add( onCancelledTarget );

		fsmController.addChangedListener( onChanged );

		Assert.assertFalse( "Before:: should not be marked as transitioning", isTransitioning );

		transition( _targetState, _data );

		Assert.assertEquals( "target state should now be current state", _currentState.name, currentState.name );
		Assert.assertTrue( "onExitingCurrent should have been called", _hasOnExitedCurrentBeenCalled );
		Assert.assertTrue( "onEnteringTarget should have been called", _hasOnEnteredTargetBeenCalled );
		Assert.assertTrue( "onCancelledCurrent should have been called", _hasOnCancelledCurrentBeenCalled );

		Assert.assertFalse( "After:: should not be marked as transitioning", isTransitioning );

	}

	private function onCancelledCurrent( reason:String, data:Object ):void{
		_hasOnCancelledCurrentBeenCalled = true;
		Assert.assertStrictlyEquals( "onCancelledCurrent:: data payload should be passed correctly", _cancellationData, data );
		Assert.assertStrictlyEquals( "onCancelledCurrent:: reason should be passed correctly", _cancelationReason, reason );
		Assert.assertTrue( "onCancelledCurrent:: should be marked as cancelled", isCanceled );
		Assert.assertTrue( "onCancelledCurrent:: Should be marked as transitioning", isTransitioning );
	}

	private function onExitingCurrent( data:Object ):void{
		_hasOnExitedCurrentBeenCalled = true;
		Assert.assertStrictlyEquals( "onExitingCurrent:: data payload should be passed correctly", data, _data );
		Assert.assertTrue( "onExitingCurrent:: Should be marked as transitioning", isTransitioning );
	}

	private function onEnteringTarget( data:Object ):void{
		_hasOnEnteredTargetBeenCalled = true;
		Assert.assertStrictlyEquals( "onEnteringTarget:: data payload should be passed correctly", data, _data );
		Assert.assertFalse( "onEnteringTarget before:: should not be marked as cancelled", isCanceled );
		fsmController.cancel( _cancelationReason, _cancellationData );
		Assert.assertTrue( "onEnteringTarget after::  should be marked as cancelled", isCanceled );
		Assert.assertTrue( "onEnteringTarget:: should be marked as transitioning", isTransitioning );
	}

	private function onEnteredTarget( data:Object ):void{
			Assert.fail( "onEnteredTarget should not be called" );
	}

	private function onTearDownCurrent():void{
			Assert.fail( "onTearDownCurrent should not be called" );
	}

	private function onChanged( state:IState ):void{
			Assert.fail( "onChanged should not be called" );
	}

	private function onCancelledTarget( reason:String, payload:Object ):void{
		Assert.fail( "onCancelledTarget should not be called" );
	}

	private function onTearDownTarget():void{
		Assert.fail( "onTearDownTarget should not be called" );
	}

	private function onExitingTarget( data:Object ):void{
		Assert.fail( "onExitingTarget should not be called" );
	}

	private function onEnteredCurrent( data:Object ):void{
		Assert.fail( "onChangedCurrent should not be called" );
	}

	private function onEnteringCurrent( data:Object ):void{
		Assert.fail( "onEnteringCurrent should not be called" );
	}

}
}