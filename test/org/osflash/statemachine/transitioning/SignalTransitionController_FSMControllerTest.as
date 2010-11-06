package org.osflash.statemachine.transitioning {
import org.flexunit.Assert;
import org.osflash.statemachine.base.SignalFSMController;
import org.osflash.statemachine.core.ISignalFSMController;

public class SignalTransitionController_FSMControllerTest extends SignalTransitionController {
	private var _fsmController:ISignalFSMController;

	public function SignalTransitionController_FSMControllerTest(){
		_fsmController = new SignalFSMController();
		super( _fsmController )
	}

	[Test]
	public function test():void{
		Assert.assertStrictlyEquals( "the fsmController should be the instance passed up in the constructor super", fsmController, _fsmController );
	}

}
}