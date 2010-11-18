package org.osflash.statemachine.transitioning {
	import org.flexunit.Assert;
	import org.osflash.statemachine.base.FSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;

	public class SignalTransitionController_FSMControllerTest extends SignalTransitionController {
	private var _fsmController:IFSMControllerOwner;

	public function SignalTransitionController_FSMControllerTest(){
		_fsmController = new FSMController();
		super( _fsmController )
	}

	[Test]
	public function test():void{
		Assert.assertStrictlyEquals( "the fsmController should be the instance passed up in the constructor super", fsmController, _fsmController );
	}

}
}