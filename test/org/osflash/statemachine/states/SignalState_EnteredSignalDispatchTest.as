package org.osflash.statemachine.states {
	import org.flexunit.Assert;

	public class SignalState_EnteredSignalDispatchTest extends SignalState {

	private var _data:Object = {};
	private var _hasDispatched:Boolean;

	public function SignalState_EnteredSignalDispatchTest(){
		super( "state/signalstate" );
	}


	[Test]
	public function test():void{
		Assert.assertNull( "Initial value of _entered should be null", _entered ) ;
		entered.add( signalListener );
		Assert.assertNotNull( "_entered should now be instantiated", _entered ) ;
		//Assert.assertTrue( "_entered should be correct type", _entered is Entered ) ;
		dispatchEntered( _data );
		Assert.assertTrue( "listener function should have been called", _hasDispatched );
	}



	private function signalListener( data:Object ):void{
		_hasDispatched = true;
		Assert.assertStrictlyEquals( "Data should be correctly dispatched in payload", _data, data );
	}


}
}