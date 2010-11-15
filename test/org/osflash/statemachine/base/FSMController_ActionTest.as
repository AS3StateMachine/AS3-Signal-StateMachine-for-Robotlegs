package org.osflash.statemachine.base {
import flexunit.framework.Assert;

public class FSMController_ActionTest extends FSMController {

	private var _testAction:String = "action/test";
	private var _testData:Object = {};
	private var _hasActionListenerBeenCalled:Boolean;

	public function FSMController_ActionTest(){
		super();
	}

	[Test]
	public function test():void{
		addActionListener( actionListener );
		action( _testAction, _testData );
		Assert.assertTrue("First call: the actionLister method should have been called",  _hasActionListenerBeenCalled );

		// reset switch, and call action again
		_hasActionListenerBeenCalled = false;
		action( _testAction, _testData );
		Assert.assertTrue("Second call: the actionLister method should have been called",  _hasActionListenerBeenCalled );
	}

	private function actionListener( action:String, payload:Object ):void{
		_hasActionListenerBeenCalled = true;
		Assert.assertEquals( "The action parameter, should be the action dispatched", _testAction, action );
		Assert.assertStrictlyEquals( "The payload parameter, should be the payload dispatched",_testData, payload );
	}
}
}