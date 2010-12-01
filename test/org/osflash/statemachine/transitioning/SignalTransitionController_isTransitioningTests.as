package org.osflash.statemachine.transitioning {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.states.SignalState;
	import org.osflash.statemachine.supporting.mocks.MockTransitionListener;

	public class SignalTransitionController_isTransitioningTests {

		private var transitionController:SignalTransitionController;
		private var currentState:SignalState;
		private var targetState:SignalState;
		private var payload:Object;

		[Before]
		public function before():void{
			currentState = new SignalState( "state/current" );
			targetState = new SignalState( "state/target" );
			transitionController = new SignalTransitionController();
			transitionController.transition( currentState );
			payload = {};
		}

		[After]
		public function after():void{
			transitionController.destroy();
			transitionController = null;
			payload = null;
		}

		[Test]
		public function isTransitioning_NonTransitioningValue_ReturnsFalse():void{

			Assert.assertFalse(	"isTransitioning property should be false", transitionController.isTransitioning );
		}

		[Test]
		public function isTransitioning_AfterTransitionValue_ReturnsFalse():void{

			transitionController.transition( targetState, payload );

			Assert.assertFalse(	"isTransitioning property should be false", transitionController.isTransitioning );
		}



	}

}

