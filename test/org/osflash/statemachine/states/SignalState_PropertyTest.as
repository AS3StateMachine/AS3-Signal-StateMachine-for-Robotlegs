package org.osflash.statemachine.states {
import org.flexunit.Assert;
import org.osflash.statemachine.signals.Cancelled;
import org.osflash.statemachine.signals.Entered;
import org.osflash.statemachine.signals.EnteringGuard;
import org.osflash.statemachine.signals.ExitingGuard;
import org.osflash.statemachine.signals.TearDown;

public class SignalState_PropertyTest extends SignalState {

	public function SignalState_PropertyTest(){
		super( "state/signalstate" );
	}

	[Test]
	public function testStateProperties():void{
		Assert.assertTrue( "entered property should be correct type", entered is Entered );
		Assert.assertTrue( "enteringGuard property should be correct type", enteringGuard is EnteringGuard );
		Assert.assertTrue( "exitingGuard property should be correct type", exitingGuard is ExitingGuard );
		Assert.assertTrue( "tearDown property should be correct type", tearDown is TearDown );
		Assert.assertTrue( "cancelled property should be correct type", cancelled is Cancelled );
	}
}
}