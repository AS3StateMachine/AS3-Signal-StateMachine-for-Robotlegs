package org.osflash.statemachine.states {
import org.flexunit.Assert;
import org.osflash.signals.Signal;
import org.osflash.statemachine.signals.Entered;
import org.osflash.statemachine.signals.EnteringGuard;

public class SignalState_EnteringGuardSignalDispatchTest extends SignalState {

	private var _data:Object = {};
	private var _hasDispatched:Boolean;

	public function SignalState_EnteringGuardSignalDispatchTest(){
		super( "state/signalstate" );
	}


	[Test]
	public function test():void{
		Assert.assertNull( "Initial value of _enteringGuard should be null", _enteringGuard ) ;
		enteringGuard.add( signalListener );
		Assert.assertNotNull( "_enteringGuard should now be instantiated", _enteringGuard ) ;
		Assert.assertTrue( "_enteringGuard should be correct type", _enteringGuard is EnteringGuard ) ;
		dispatchEnteringGuard( _data );
		Assert.assertTrue( "listener function should have been called", _hasDispatched );
	}



	private function signalListener( data:Object ):void{
		_hasDispatched = true;
		Assert.assertStrictlyEquals( "Data should be correctly dispatched in payload", _data, data );
	}


}
}