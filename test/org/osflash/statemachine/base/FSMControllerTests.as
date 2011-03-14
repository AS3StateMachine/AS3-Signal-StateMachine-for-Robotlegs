package org.osflash.statemachine.base {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.supporting.mocks.MockSignalListener;
	import org.osflash.statemachine.transitioning.TransitionPhase;

	public class FSMControllerTests {

		private var fsmController:FSMController;

		[Before]
		public function before():void{

			fsmController = new FSMController();
		}

		[After]
		public function after():void{
			fsmController.destroy();
			fsmController = null;
		}

        [Test]
		public function transitionPhase_TestTransitionPhaseDefaultValue_ReturnsDefaultValue():void{

			Assert.assertEquals("Default value of transitionPhase should be TransitionPhases.NONE", TransitionPhase.NONE, fsmController.transitionPhase )

		}

        [Test]
		public function currentStateName_TestCurrentStateNameDefaultValue_ReturnsNull():void{

			Assert.assertNull("Default value of transition should be NULL", fsmController.currentStateName );

		}

		[Test (expected='org.osflash.statemachine.errors.StateTransitionError')]
		public function action_ActioningTransitionWhilePhaseMarkedAsEnteringGuard_ThrowsStateTransitionError():void{

			fsmController.setTransitionPhase( TransitionPhase.ENTERING_GUARD );
			fsmController.action( null, null );

		}

		[Test (expected='org.osflash.statemachine.errors.StateTransitionError')]
		public function action_ActioningTransitionWhilePhaseMarkedAsExitingGuard_ThrowsStateTransitionError():void{

			fsmController.setTransitionPhase( TransitionPhase.EXITING_GUARD );
			fsmController.action( null, null );

		}

		[Test (expected='org.osflash.statemachine.errors.StateTransitionError')]
		public function action_ActioningTransitionWhilePhaseMarkedAsTearDown_ThrowsStateTransitionError():void{

			fsmController.setTransitionPhase( TransitionPhase.TEAR_DOWN );
			fsmController.action( null, null );

		}

		[Test]
		public function action_ActioningTransitionWhilePhaseMarkedAsEntered_NoErrorThrown():void{

			fsmController.setTransitionPhase( TransitionPhase.ENTERED );
			fsmController.action( null, null );

		}

		[Test]
		public function action_ActioningTransitionWhilePhaseMarkedAsCancelled_NoErrorThrown():void{

			fsmController.setTransitionPhase( TransitionPhase.CANCELLED );
			fsmController.action( null, null );

		}

		[Test]
		public function action_ActioningTransitionWhilePhaseMarkedAsChanged_NoErrorThrown():void{

			fsmController.setTransitionPhase( TransitionPhase.GLOBAL_CHANGED );
			fsmController.action( null, null );

		}

		[Test]
		public function action_ActioningTransitionWhilePhaseMarkedAsNone_NoErrorThrown():void{

			fsmController.setTransitionPhase( TransitionPhase.NONE );
			fsmController.action( null, null );

		}

		[Test]
		public function action_ActioningTransitionWhileIsTransitionIsFalse_ReturnsTrue():void{

			var info:String = "actionName";
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( info, payload);

			fsmController.setIsTransition( false );
			fsmController.addActionListener( mockListener.listenerOne );
			fsmController.action( info, payload );

			Assert.assertTrue("Action listener should be called, and parameters passed correctly", mockListener.conclusion );

		}

		[Test]
		public function action_ActioningTransitionWhileIsTransitionIsTrue_ReturnsFalse():void{

			var info:String = "actionName";
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( info, payload);

			fsmController.setIsTransition( true );
			fsmController.addActionListener( mockListener.listenerOne );
			fsmController.action( info, payload );

			Assert.assertFalse("Action listener should not be called until the Changed Signal is dispatched", mockListener.conclusion );

		}

		[Test]
		public function action_ActioningTransitionWhileIsTransitionIsTrueThenDispatchingChangedSignal_ReturnsTrue():void{

			var info:String = "actionName";
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( info, payload);

			fsmController.setIsTransition( true );
			fsmController.addActionListener( mockListener.listenerOne );
			fsmController.action( info, payload );
			fsmController.dispatchChanged( "state/test" );

			Assert.assertTrue("Action listener should be called, and parameters passed correctly", mockListener.conclusion );

		}

		[Test]
		public function cancel_CancellingTransitionWhilePhaseMarkedAsEnteringGuard_NoErrorThrown():void{

			fsmController.setTransitionPhase( TransitionPhase.ENTERING_GUARD );
			fsmController.cancel( null, null );

		}

		[Test]
		public function cancel_CancellingTransitionWhilePhaseMarkedAsExitingGuard_NoErrorThrown():void{

			fsmController.setTransitionPhase( TransitionPhase.EXITING_GUARD );
			fsmController.cancel( null, null );

		}

		[Test (expected='org.osflash.statemachine.errors.StateTransitionError')]
		public function cancel_CancellingTransitionWhilePhaseMarkedAsCancelled_ThrowsStateTransitionError():void{

			fsmController.setTransitionPhase( TransitionPhase.CANCELLED );
			fsmController.cancel( null, null );

		}

		[Test (expected='org.osflash.statemachine.errors.StateTransitionError')]
		public function cancel_CancellingTransitionWhilePhaseMarkedAsEntered_ThrowsStateTransitionError():void{

			fsmController.setTransitionPhase( TransitionPhase.ENTERED );
			fsmController.cancel( null, null );

		}

		[Test (expected='org.osflash.statemachine.errors.StateTransitionError')]
		public function cancel_CancellingTransitionWhilePhaseMarkedAsChanged_ThrowsStateTransitionError():void{

			fsmController.setTransitionPhase( TransitionPhase.GLOBAL_CHANGED );
			fsmController.cancel( null, null );

		}

		[Test (expected='org.osflash.statemachine.errors.StateTransitionError')]
		public function cancel_CancellingTransitionWhilePhaseMarkedAsTearDow_ThrowsStateTransitionError():void{

			fsmController.setTransitionPhase( TransitionPhase.TEAR_DOWN );
			fsmController.cancel( null, null );

		}

		[Test (expected='org.osflash.statemachine.errors.StateTransitionError')]
		public function cancel_CancellingTransitionWhilePhaseMarkedAsNone_ThrowsStateTransitionError():void{

			fsmController.setTransitionPhase( TransitionPhase.NONE );
			fsmController.cancel( null, null );

		}

		[Test]
		public function addChangedListener_AddingChangedListenerThenDispatchingChangedSignal_ReturnsTrue():void{

			var info:String = "state/test";
			var mockListener:MockSignalListener = new MockSignalListener( info, null );

			fsmController.addChangedListener( mockListener.listenerTwo );
			fsmController.dispatchChanged( info );

			Assert.assertTrue("Changed listener should be called, and parameters passed correctly", mockListener.conclusion );

		}

		[Test]
		public function addChangedListener_AddingChangedListenerThenDispatchingChangedSignalTwice_ReturnsTrue():void{

			var info:String = "state/test";
			var mockListener:MockSignalListener = new MockSignalListener( info, null );

			fsmController.addChangedListener( mockListener.listenerTwo );
			fsmController.dispatchChanged( info );
			mockListener.reset();
			fsmController.dispatchChanged( info );

			Assert.assertTrue("Changed listener should be called, and parameters passed correctly", mockListener.conclusion );

		}

		[Test]
		public function removeChangedListener_AddingChangedListenerThenRemovingListener_ReturnsFalse():void{

			var info:String = "state/test";
			var mockListener:MockSignalListener = new MockSignalListener( info, null );

			fsmController.addChangedListener( mockListener.listenerTwo );
			fsmController.removeChangedListener( mockListener.listenerTwo);
			fsmController.dispatchChanged( info );

			Assert.assertFalse("Changed listener should not be called", mockListener.conclusion );

		}

		[Test]
		public function addChangedListenerOnce_AddingChangedListenerOnceThenDispatchingChangedSignal_ReturnsTrue():void{

			var info:String = "state/test";
			var mockListener:MockSignalListener = new MockSignalListener( info, null );

			fsmController.addChangedListenerOnce( mockListener.listenerTwo );
			fsmController.dispatchChanged( info );

			Assert.assertTrue("Changed listener should be called, and parameters passed correctly", mockListener.conclusion );

		}

		[Test]
		public function addChangedListenerOnce_AddingChangedListenerOnceThenDispatchingChangedSignalTwice_ReturnsFalse():void{

			var info:String = "state/test";
			var mockListener:MockSignalListener = new MockSignalListener( info, null );

			fsmController.addChangedListenerOnce( mockListener.listenerTwo );
			fsmController.dispatchChanged( info );
			mockListener.reset();
			fsmController.dispatchChanged( info );

			Assert.assertFalse("Changed listener should not be called", mockListener.conclusion );

		}

	}
}
