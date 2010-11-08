package org.osflash.statemachine.base {
import flexunit.framework.Assert;

public class SignalFSMController_CancelTest extends SignalFSMController {

	private var _reason:String = "reason/test";
	private var _testData:Object = {};
	private var _hasCancelListenerBeenCalled:Boolean;

	public function SignalFSMController_CancelTest(){
		super();
	}

	[Test]
	public function test():void{
		addCancelListener( cancelListener );
		cancel( _reason, _testData );
		Assert.assertTrue( "First call: the actionLister method should have been called", _hasCancelListenerBeenCalled );

		// reset switch, and call action again
		_hasCancelListenerBeenCalled = false;
		cancel( _reason, _testData );
		Assert.assertTrue("Second call: the actionLister method should have been called",  _hasCancelListenerBeenCalled );
	}

	private function cancelListener( reason:String, payload:Object ):void{
		_hasCancelListenerBeenCalled = true;
		Assert.assertEquals( "The reason parameter, should be the reason dispatched", _reason, reason );
		Assert.assertStrictlyEquals( "The payload parameter, should be the payload dispatched", _testData, payload );
	}
}
}