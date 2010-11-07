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
		Assert.assertTrue( _hasCancelListenerBeenCalled );
	}

	private function cancelListener( reason:String, payload:Object ):void{
		_hasCancelListenerBeenCalled = true;
		Assert.assertEquals( _reason, reason );
		Assert.assertStrictlyEquals( _testData, payload );
	}
}
}