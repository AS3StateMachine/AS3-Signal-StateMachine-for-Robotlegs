package org.osflash.statemachine.base {
import flexunit.framework.Assert;

import org.osflash.signals.Signal;
import org.osflash.statemachine.signals.Action;
import org.osflash.statemachine.signals.Cancel;
import org.osflash.statemachine.signals.Changed;

public class SignalFSMController_DestroyTest extends SignalFSMController {
	public function SignalFSMController_DestroyTest(){
		super();
	}



	[Test]
	public function test():void{

		// map the props locally, so they can be tested after destroy is called
		var a:Signal = _action;
		var c:Signal = _cancel;
		var ch:Signal = _changed;

		// add listeners to each
		addActionListener( testListener );
		addCancelListener( testListener );
		addChangedListener( testListener );

		// test number of listeners to make sure that they are there
		Assert.assertEquals( "_action signal should have 1 listener", 1, a.numListeners);
		Assert.assertEquals( "_cancel signal should have 1 listener", 1, c.numListeners);
		Assert.assertEquals( "_changed signal should have 1 listener", 1, ch.numListeners);

		destroy();

		// properties should be null
		Assert.assertNull( "_action property should be null", _action );
		Assert.assertNull( "_cancel property should be null", _cancel );
		Assert.assertNull( "_changed property should be null", _changed );

		// removeAll method should have been called on each Signal
		Assert.assertEquals( "_action signal should have no listeners", 0, a.numListeners);
		Assert.assertEquals( "_cancel signal should have no listeners", 0, c.numListeners);
		Assert.assertEquals( "_changed signal should have no listeners", 0, ch.numListeners);
	}

	private function testListener(a:String, b:Object):void{}
}
}