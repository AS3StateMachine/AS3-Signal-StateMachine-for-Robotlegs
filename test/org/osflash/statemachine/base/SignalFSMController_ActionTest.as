package org.osflash.statemachine.base {
import flexunit.framework.Assert;

public class SignalFSMController_ActionTest extends SignalFSMController {

	private var _testAction:String = "action/test";
	private var _testData:Object = {};
	private var _hasActionListenerBeenCalled:Boolean;

	public function SignalFSMController_ActionTest(){
		super();
	}

	[Test]
	public function test():void{
		addActionListener( actionListener );
		action( _testAction, _testData );
		Assert.assertTrue( _hasActionListenerBeenCalled );
	}

	private function actionListener( action:String, payload:Object ):void{
		_hasActionListenerBeenCalled = true;
		Assert.assertEquals( _testAction, action );
		Assert.assertStrictlyEquals( _testData, payload );
	}
}
}