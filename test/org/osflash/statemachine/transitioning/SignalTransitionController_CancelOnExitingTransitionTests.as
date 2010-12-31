package org.osflash.statemachine.transitioning {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.states.SignalState;
	import org.osflash.statemachine.supporting.mocks.MockTransitionListener;

	public class SignalTransitionController_CancelOnExitingTransitionTests {

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
		public function transition_StateNameIsCurrentStateBeforeTransition_ReturnsTrue():void{

			Assert.assertTrue(
					"The transitionController.currentState property should be the currentState",
					transitionController.currentState === currentState );
		}

		[Test]
		public function transition_StateNameIsCurrentStateAfterTransition_ReturnsTrue():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			targetState.enteringGuard.add( mockListener.listenerCancel );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The transitionController.currentState property should be the currentState",
					transitionController.currentState === currentState );
		}

		[Test]
		public function transition_CallingCurrentStateOnExitingGuard_ReturnsTrueTrueTrue():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.exitingGuard.add( mockListener.listenerObject );
			targetState.enteringGuard.add( mockListener.listenerCancel );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The CurrentState's ExitingGuard did not execute properly, should be: true, true, true",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingCurrentStateTearDownGuard_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.tearDown.add( mockListener.listenerNone );
			targetState.enteringGuard.add( mockListener.listenerCancel );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The CurrentState's TearDown listener should not be called: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingCurrentStateCancelled_ReturnsTrueTrueFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener(
					MockTransitionListener.CANCELLED_PAYLOAD,
					transitionController,
					MockTransitionListener.CANCELLATION_REASON );

			currentState.cancelled.add( mockListener.listenerStringObject );
			targetState.enteringGuard.add( mockListener.listenerCancel );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The CurrentState's Cancel Listener should not have been called, should be: true, true, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							!mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingCurrentStateEnteringGuard_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.enteringGuard.add( mockListener.listenerObject );
			targetState.enteringGuard.add( mockListener.listenerCancel );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The CurrentState's EnteringGuard Listener should not have been called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingCurrentStateEntered_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			currentState.entered.add( mockListener.listenerObject );
			targetState.enteringGuard.add( mockListener.listenerCancel );
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
			targetState.enteringGuard.add( mockListener.listenerCancel );
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
			targetState.enteringGuard.add( mockListener.listenerCancel );
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
			targetState.enteringGuard.add( mockListener.listenerCancel );
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
			targetState.enteringGuard.add( mockListener.listenerCancel );
			transitionController.transition( targetState, payload );

			Assert.assertTrue(
					"The target State's EnteringGuard should not be called, should be: true, true, true",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

		[Test]
		public function transition_CallingTargetStateOnEntered_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController );

			targetState.entered.add( mockListener.listenerObject );
			targetState.enteringGuard.add( mockListener.listenerCancel );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The target State's Entered  should not be called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );

		}

		[Test]
		public function transition_CallingTargetStateOnChanged_ReturnsFalseFalseFalse():void{

			var mockListener:MockTransitionListener = new MockTransitionListener( payload, transitionController, targetState.name );

			targetState.enteringGuard.add( mockListener.listenerCancel );
			transitionController.fsmController.addChangedListenerOnce( mockListener.listenerString );
			transitionController.transition( targetState, payload );

			Assert.assertFalse(
					"The Changed listener should not have been called, should be: false, false, false",
					mockListener.hasListenerBeenCalled &&
							mockListener.parameterTest &&
							mockListener.isTransitioning );
		}

	}

}

