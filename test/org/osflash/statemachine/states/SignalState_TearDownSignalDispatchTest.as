package org.osflash.statemachine.states {
	import org.flexunit.Assert;

	public class SignalState_TearDownSignalDispatchTest extends SignalState {

	private var _hasDispatched:Boolean;

	public function SignalState_TearDownSignalDispatchTest(){
		super( "state/signalstate" );
	}


	[Test]
	public function test():void{
		Assert.assertNull( "Initial value of _tearDown should be null", _tearDown ) ;
		tearDown.add( signalListener );
		Assert.assertNotNull( "_tearDown should now be instantiated", _tearDown ) ;
		//Assert.assertTrue( "_tearDown should be correct type", _tearDown is TearDown ) ;
		dispatchTearDown( );
		Assert.assertTrue( "listener function should have been called", _hasDispatched );
	}



	private function signalListener(  ):void{
		_hasDispatched = true;
	}


}
}