package org.osflash.statemachine.transitioning {
import org.flexunit.Assert;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.states.SignalState;

public class SignalTransitionController_StraightTransitionTest extends SignalTransitionController {

	private var _data:Object = {};
	private var _targetState:SignalState;
	private var _hasOnExitedCurrentBeenCalled:Boolean;
	private var _hasOnEnteredTargetBeenCalled:Boolean;
	private var _hasOnEnterededTargetBeenCalled:Boolean;
	private var _hasOnTearDownCurrentBeenCalled:Boolean;
	private var _hasOnChangedBeenCalled:Boolean;

	[Test]
	public function test():void{

		setCurrentState( new SignalState( "state/current" ) );
		_targetState = new SignalState( "state/target" );

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

		Assert.assertFalse( "Before transition isTransitioning switch should be false", isTransitioning );

		transition( _targetState, _data );

		Assert.assertEquals( "target state should now be current state", _targetState.name, currentState.name );
		Assert.assertTrue( "onExitingCurrent should have been called", _hasOnExitedCurrentBeenCalled );
		Assert.assertTrue( "onEnteringTarget should have been called", _hasOnEnteredTargetBeenCalled );
		Assert.assertTrue( "onEnteredTarget should have been called", _hasOnEnterededTargetBeenCalled );
		Assert.assertTrue( "onTearDownCurrent should have been called", _hasOnTearDownCurrentBeenCalled );
		Assert.assertTrue( "onChanged should have been called", _hasOnChangedBeenCalled );
		Assert.assertFalse( "Should not be marked as transitioning", isTransitioning );

	}

	private function onCancelledCurrent( data:Object, reason:String ):void{
		Assert.fail( "onCancelledCurrent should not be called" );
	}

	private function onExitingCurrent( data:Object ):void{
		_hasOnExitedCurrentBeenCalled = true;
		Assert.assertStrictlyEquals( data, _data );
		Assert.assertTrue( "onExitingCurrent:: Should be marked as transitioning", isTransitioning );
	}

	private function onEnteringTarget( data:Object ):void{
		_hasOnEnteredTargetBeenCalled = true;
		Assert.assertStrictlyEquals( data, _data );
		Assert.assertTrue( "onEnteringTarget:: Should be marked as transitioning", isTransitioning );
	}

	private function onEnteredTarget( data:Object ):void{
		_hasOnEnterededTargetBeenCalled = true;
		Assert.assertStrictlyEquals( data, _data );
		Assert.assertTrue( "onEnteredTarget:: Should be marked as transitioning", isTransitioning );
	}

	private function onTearDownCurrent():void{
		_hasOnTearDownCurrentBeenCalled = true;
		Assert.assertTrue( "onTearDownCurrent:: Should be marked as transitioning", isTransitioning );
	}

	private function onChanged( state:IState ):void{
		_hasOnChangedBeenCalled = true;
		Assert.assertEquals( _targetState.name, state.name );
		Assert.assertFalse( "onChanged:: Should not be marked as transitioning", isTransitioning );
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