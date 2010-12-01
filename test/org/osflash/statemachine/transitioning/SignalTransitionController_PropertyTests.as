package org.osflash.statemachine.transitioning {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.base.FSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;

	public class SignalTransitionController_PropertyTests {

		private var transitionController:SignalTransitionController;

		[Before]
		public function before():void{
			transitionController = new SignalTransitionController();
		}

		[After]
		public function after():void{
			transitionController.destroy();
			transitionController = null;
		}

		[Test]
		public function fsmController_PassFSMControllerAsConstructorParameter_ReturnsTrue():void{
			var fsmController:IFSMControllerOwner = new FSMController();
			transitionController = new SignalTransitionController( fsmController );
			Assert.assertTrue( " fsmController should be the instance passed in the constructor", transitionController.fsmController === fsmController );
		}
	}
}