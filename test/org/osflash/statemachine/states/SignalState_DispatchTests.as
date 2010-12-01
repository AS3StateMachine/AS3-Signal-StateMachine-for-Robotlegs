package org.osflash.statemachine.states {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.core.ISignalState;
	import org.osflash.statemachine.signals.Cancelled;
	import org.osflash.statemachine.signals.Entered;
	import org.osflash.statemachine.signals.EnteringGuard;
	import org.osflash.statemachine.signals.ExitingGuard;
	import org.osflash.statemachine.signals.TearDown;
	import org.osflash.statemachine.supporting.mocks.MockSignalListener;

	public class SignalState_DispatchTests {

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
		public function dispatchExitingGuard_AddingListenerAndDispatchingExitingGuard_ReturnsTrue():void{
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( null, payload );

			signalState.exitingGuard.add( mockListener.listenerThree );
			signalState.dispatchExitingGuard( payload );

			Assert.assertTrue( "ExitingGuard listener should be called, and parameters passed correctly", mockListener.conclusion );
		}

		[Test]
		public function dispatchEnteringGuard_AddingListenerAndDispatchingEnteringGuard_ReturnsTrue():void{
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( null, payload );

			signalState.enteringGuard.add( mockListener.listenerThree );
			signalState.dispatchEnteringGuard( payload );

			Assert.assertTrue( "ExitingGuard listener should be called, and parameters passed correctly", mockListener.conclusion );
		}

		[Test]
		public function dispatchEntered_AddingListenerAndDispatchingEntered_ReturnsTrue():void{
			var payload:Object = {};
			var mockListener:MockSignalListener = new MockSignalListener( null, payload );

			signalState.entered.add( mockListener.listenerThree );
			signalState.dispatchEntered( payload );

			Assert.assertTrue( "Entered listener should be called, and parameters passed correctly", mockListener.conclusion );
		}

		[Test]
		public function dispatchTearDown_AddingListenerAndDispatchingTearDown_ReturnsTrue():void{

			var mockListener:MockSignalListener = new MockSignalListener( null, null );

			signalState.tearDown.add( mockListener.listenerFour );
			signalState.dispatchTearDown();

			Assert.assertTrue( "TearDown listener should be called", mockListener.conclusion );
		}

		[Test]
		public function dispatchCancelled_AddingListenerAndDispatchingCancelled_ReturnsTrue():void{

			var payload:Object = {};
			var info:String = "reason/test";
			var mockListener:MockSignalListener = new MockSignalListener( info, payload );

			signalState.cancelled.add( mockListener.listenerOne );
			signalState.dispatchCancelled( info, payload );

			Assert.assertTrue( "Cancelled listener should be called, and parameters passed correctly", mockListener.conclusion );
		}

	}
}