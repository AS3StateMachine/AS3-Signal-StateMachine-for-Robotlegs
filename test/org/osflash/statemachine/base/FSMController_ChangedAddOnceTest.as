package org.osflash.statemachine.base {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.core.IState;

	public class FSMController_ChangedAddOnceTest extends FSMController {

	private var _testState:IState;
	private var _hasChangedListenerBeenCalled:Boolean;

	public function FSMController_ChangedAddOnceTest(){
		super();
	}

	[Test]
	public function test():void{
		_testState = new BaseState( "state/test");
		addChangedListenerOnce( changedListener );
		dispatchChanged( _testState );
		Assert.assertTrue( "First call: the actionLister method should have been called", _hasChangedListenerBeenCalled );

		_hasChangedListenerBeenCalled = false;
		dispatchChanged( _testState );

		Assert.assertFalse( "Second call: the actionLister method should not have been called", _hasChangedListenerBeenCalled );
	}

	private function changedListener( state:IState ):void{
		_hasChangedListenerBeenCalled = true;
		Assert.assertStrictlyEquals( "The state parameter, should be the state dispatched", _testState, state );
	}
}
}