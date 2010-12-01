package org.osflash.statemachine.transitioning {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.base.FSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;
	import org.osflash.statemachine.supporting.mocks.MockSignalListener;

	public class SignalTransitionController_ActionCallbackTests {

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
		public function actionCallBack_SetValueAndActionATransition_ReturnsTrue():void{
			var action:String = "action/test";
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener(action, payload);
			transitionController.actionCallback = mockListener.listenerOne;
			transitionController.fsmController.action( action, payload);
			Assert.assertTrue( "The Action Callaback should have been called, and its parameters passed correctly", mockListener.conclusion );
		}
	}
}