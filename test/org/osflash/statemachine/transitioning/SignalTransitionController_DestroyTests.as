package org.osflash.statemachine.transitioning {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.base.FSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;
	import org.osflash.statemachine.states.SignalState;
	import org.osflash.statemachine.supporting.mocks.MockSignalListener;

	public class SignalTransitionController_DestroyTests {

		private var transitionController:SignalTransitionController;
		private var currentState:SignalState;
		private var targetState:SignalState;

		[Before]
		public function before():void{
			currentState = new SignalState( "state/current" );
			targetState = new SignalState( "state/target" );
			transitionController = new SignalTransitionController();
			transitionController.transition( currentState );

		}

		[After]
		public function after():void{
			transitionController = null;
		}

		[Test]
		public function destroy_GetFSMControllerPropertyAfterDestroy_ReturnsNull():void{

			transitionController.destroy();
			Assert.assertNull( "fsmController should be null", transitionController.fsmController );
		}

		[Test]
		public function destroy_ActionTransitionAfterDestroy_ReturnsFalse():void{
			var mockListener:MockSignalListener = new MockSignalListener(null, null);{
				transitionController.actionCallback = mockListener.listenerOne;
				transitionController.destroy();
				Assert.assertFalse( "Action callback should not have beeb called", mockListener.conclusion );
			}
		}
	}
}