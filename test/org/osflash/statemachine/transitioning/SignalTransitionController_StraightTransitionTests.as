package org.osflash.statemachine.transitioning {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.states.SignalState;
	import org.osflash.statemachine.supporting.mocks.MockTransitionListener;

	public class SignalTransitionController_StraightTransitionTests {

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
		public function transition_CallingCurrentStateOnExitingGuard_ReturnsTrueTrueTrue():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.exitingGuard.add( mockListener.listenerObject );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The CurrentState's ExitingGuard did not execute properly, should be: true, true, true",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingCurrentStateTearDownGuard_ReturnsTrueTrueTrue():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.tearDown.add( mockListener.listenerNone );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The CurrentState's TearDown did not execute properly, should be: true, true, true",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingCurrentStateCancelled_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.cancelled.add( mockListener.listenerStringObject );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The CurrentState's Cancel Lister should not have been called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingCurrentStateEnteringGuard_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.enteringGuard.add( mockListener.listenerObject );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The CurrentState's EnteringGuard Lister should not have been called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingCurrentStateEntered_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.entered.add( mockListener.listenerObject );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The CurrentState's Entered Lister should not have been called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingTargetStateOnExitingGuard_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			targetState.exitingGuard.add( mockListener.listenerObject );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The target State's ExitingGuard should not have been called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingTargetStateOnTearDown_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			targetState.tearDown.add( mockListener.listenerNone );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The target State's TearDown should not have been called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingTargetStateOnCancelled_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			targetState.cancelled.add( mockListener.listenerStringObject );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The target State's Cancelled should not have been called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingTargetStateOnEnteringGuard_ReturnsTrueTrueTrue():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			targetState.enteringGuard.add( mockListener.listenerObject );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The target State's EnteringGuard did not execute correctly, should be: true, true, true",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingTargetStateOnEntered_ReturnsTrueTrueTrue():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			targetState.entered.add( mockListener.listenerObject );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The target State's Entered did not execute correctly, should be: true, true, true",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );

		}

		[Test]
		public function transition_CallingTargetStateOnChanged_ReturnsTrueTrueFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController, targetState.name );

			transitionController.fsmController.addChangedListenerOnce( mockListener.listenerString );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The Changed listener did not execute correctly, should be: true, true, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							!mockListener.isTransitioning );
		}

	}

}

