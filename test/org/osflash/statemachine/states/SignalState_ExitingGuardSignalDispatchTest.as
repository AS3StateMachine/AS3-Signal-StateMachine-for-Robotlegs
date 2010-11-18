package org.osflash.statemachine.states {
	import org.flexunit.Assert;

	public class SignalState_ExitingGuardSignalDispatchTest extends SignalState {

	private var _data:Object = {};
	private var _hasDispatched:Boolean;

	public function SignalState_ExitingGuardSignalDispatchTest(){
		super( "state/signalstate" );
	}


	[Test]
	public function test():void{
		Assert.assertNull( "Initial value of _exitingGuard should be null", _exitingGuard ) ;
		exitingGuard.add( signalListener );
		Assert.assertNotNull( "_exitingGuard should now be instantiated", _exitingGuard ) ;
		//Assert.assertTrue( "_exitingGuard should be correct type", _exitingGuard is ExitingGuard ) ;
		dispatchExitingGuard( _data );
		Assert.assertTrue( "listener function should have been called", _hasDispatched );
	}



	private function signalListener( data:Object ):void{
		_hasDispatched = true;
		Assert.assertStrictlyEquals( "Data should be correctly dispatched in payload", _data, data );
	}


}
}