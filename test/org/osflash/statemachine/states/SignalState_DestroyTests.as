package org.osflash.statemachine.states {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.core.ISignalState;
	import org.osflash.statemachine.signals.Cancelled;
	import org.osflash.statemachine.signals.Entered;
	import org.osflash.statemachine.signals.EnteringGuard;
	import org.osflash.statemachine.signals.ExitingGuard;
	import org.osflash.statemachine.signals.TearDown;
	import org.osflash.statemachine.supporting.mocks.MockSignalListener;

	public class SignalState_DestroyTests {

		private var signalState:SignalState;

		[Before]
		public function before():void{
			signalState = new SignalState( "state/test" );

		}

		[After]
		public function after():void{
			signalState.destroy();
			signalState = null;
		}

		[Test]
		public function destroy_AddingListenerDestroyingThenDispatchingExitingGuard_ReturnsFalse():void{
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( null, payload );

			signalState.exitingGuard.add( mockListener.listenerThree );
			signalState.destroy();
			signalState.dispatchExitingGuard( payload );

			Assert.assertFalse( "ExitingGuard listener should not be called after destroy", mockListener.conclusion );
		}

		[Test]
		public function destroy_AddingListenerDestroyThenDispatchingEnteringGuard_ReturnsFalse():void{
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( null, payload );

			signalState.enteringGuard.add( mockListener.listenerThree );
			signalState.destroy();
			signalState.dispatchEnteringGuard( payload );

			Assert.assertFalse( "ExitingGuard listener should not be called after destroy", mockListener.conclusion );
		}

		[Test]
		public function destroy_AddingListenerDestroyThenDispatchingEntered_ReturnsFalse():void{
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( null, payload );

			signalState.entered.add( mockListener.listenerThree );
			signalState.destroy();
			signalState.dispatchEntered( payload );

			Assert.assertFalse( "Entered listener should not be called after destroy", mockListener.conclusion );
		}

		[Test]
		public function destroy_AddingListenerDestroyThenDispatchingTearDown_ReturnsFalse():void{

			var mockListener:MockSignalListener = new MockSignalListener( null, null );

			signalState.tearDown.add( mockListener.listenerFour );
			signalState.destroy();
			signalState.dispatchTearDown();

			Assert.assertFalse( "TearDown listener should not be called after destroy", mockListener.conclusion );
		}

		[Test]
		public function destroy_AddingListenerDestroyThenDispatchingCancelled_ReturnsFalse():void{

			var payload:Object = {};
			var info:String = "reason/test";
			var mockListener:MockSignalListener = new MockSignalListener( info, payload );

			signalState.cancelled.add( mockListener.listenerOne );
			signalState.destroy();
			signalState.dispatchCancelled( info, payload );

			Assert.assertFalse( "Cancelled listener should not be called after destroy", mockListener.conclusion );
		}

		[Test]
		public function destroy_DefineTransitionThenDestroy_ReturnsFalse():void{

			signalState.defineTrans("action/test", "state/test");
			signalState.destroy();

			Assert.assertFalse( "Transition should have been removed", signalState.hasTrans( "action/test") );
		}

	}
}