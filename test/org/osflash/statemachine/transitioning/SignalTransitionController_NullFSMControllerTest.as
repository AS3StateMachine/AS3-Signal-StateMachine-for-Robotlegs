package org.osflash.statemachine.transitioning {
import org.flexunit.Assert;
import org.osflash.statemachine.base.SignalFSMController;

public class SignalTransitionController_NullFSMControllerTest extends SignalTransitionController {

	public function SignalTransitionController_NullFSMControllerTest(){
	}

	[Test]
	public function test():void{
		Assert.assertNotNull( fsmController );
		Assert.assertTrue( fsmController is SignalFSMController );
	}

}
}