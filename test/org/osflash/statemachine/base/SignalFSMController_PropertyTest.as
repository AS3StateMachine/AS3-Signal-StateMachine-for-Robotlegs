package org.osflash.statemachine.base {
import flexunit.framework.Assert;

import org.osflash.statemachine.signals.Action;
import org.osflash.statemachine.signals.Cancel;
import org.osflash.statemachine.signals.Changed;

public class SignalFSMController_PropertyTest extends SignalFSMController {
	public function SignalFSMController_PropertyTest(){
		super();
	}



	[Test]
	public function test():void{
		Assert.assertNotNull( _action );
		Assert.assertNotNull( _cancel );
		Assert.assertNotNull( _changed );

		Assert.assertTrue( _action is Action);
		Assert.assertTrue( _cancel is Cancel);
		Assert.assertTrue( _changed is Changed);
	}
}
}