package org.osflash.statemachine.base {
import flexunit.framework.Assert;

import org.osflash.statemachine.core.IState;

public class FSMController_ChangedTest extends FSMController {

	private var _testState:IState;
	private var _hasChangedListenerBeenCalled:Boolean;

	public function FSMController_ChangedTest(){
		super();
	}

	[Test]
	public function test():void{
		_testState = new BaseState( "state/test" );
		addChangedListener( changedListener );
		dispatchChanged( _testState );
		Assert.assertTrue( "First call: the actionLister method should have been called", _hasChangedListenerBeenCalled );

		// reset and do again
		_hasChangedListenerBeenCalled = false;
		dispatchChanged( _testState );

		Assert.assertTrue( "Second call: the actionLister method should have been called", _hasChangedListenerBeenCalled );

		// reset, remove and do again
		_hasChangedListenerBeenCalled = false;
		removeChangedListener( changedListener );
		dispatchChanged( _testState );

		Assert.assertFalse( "Third call: the actionLister method should not have been called", _hasChangedListenerBeenCalled );

	}

	private function changedListener( state:IState ):void{
		_hasChangedListenerBeenCalled = true;
		Assert.assertEquals( "The state parameter, should be the state dispatched", _testState, state );
	}
}
}