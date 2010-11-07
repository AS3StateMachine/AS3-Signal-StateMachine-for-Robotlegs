package org.osflash.statemachine.transitioning {
import org.flexunit.Assert;
import org.osflash.statemachine.states.SignalState;

public class SignalTransitionController_DestroyTest extends SignalTransitionController {

	private var _targetState:SignalState;

	[Test]
	public function test():void{
		setCurrentState( new SignalState( "state/current" ) );
		_targetState = new SignalState( "state/target" );
		transition( _targetState );

		Assert.assertEquals( "The current state should be the target state",_targetState.name, currentState.name );

		destroy();

		Assert.assertFalse( "should fail", handleAction( "action/next", null ) );
		Assert.assertNull( "should be null", fsmController );
	}

}
}