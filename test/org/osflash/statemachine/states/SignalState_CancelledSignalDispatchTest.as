package org.osflash.statemachine.states {
import org.flexunit.Assert;
import org.osflash.signals.Signal;
import org.osflash.statemachine.signals.Cancelled;
import org.osflash.statemachine.signals.Entered;
import org.osflash.statemachine.signals.EnteringGuard;
import org.osflash.statemachine.signals.ExitingGuard;

public class SignalState_CancelledSignalDispatchTest extends SignalState {

	private var _data:Object = {};
	private var _reason:String = "testReason";
	private var _hasDispatched:Boolean;

	public function SignalState_CancelledSignalDispatchTest(){
		super( "state/signalstate" );
	}


	[Test]
	public function test():void{
		Assert.assertNull( "Initial value of _cancelled should be null", _cancelled ) ;
		cancelled.add( signalListener );
		Assert.assertNotNull( "_cancelled should now be instantiated", _cancelled ) ;
		Assert.assertTrue( "_cancelled should be correct type", _cancelled is Cancelled ) ;
		dispatchCancelled( _reason, _data );
		Assert.assertTrue( "listener function should have been called", _hasDispatched );
	}



	private function signalListener( reason:String, data:Object ):void{
		_hasDispatched = true;
		Assert.assertStrictlyEquals( "Reason should be correctly dispatched in payload", _reason, reason );
		Assert.assertStrictlyEquals( "Data should be correctly dispatched in payload", _data, data );
	}


}
}