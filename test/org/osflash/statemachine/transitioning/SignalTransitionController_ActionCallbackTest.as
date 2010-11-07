package org.osflash.statemachine.transitioning {
import org.flexunit.Assert;

public class SignalTransitionController_ActionCallbackTest extends SignalTransitionController {

	private var _data:Object;
	private var _action:String;

	public function SignalTransitionController_ActionCallbackTest(){

	}

	[Test]
	public function test():void{
		_data = {};
		_action = "action/next";
		actionCallback = callbackTest;
		handleAction( _action, _data );
	}

	private function callbackTest( action:String, data:Object ):void{
		Assert.assertStrictlyEquals( _data, data );
		Assert.assertStrictlyEquals( _action, action );
	}
}
}