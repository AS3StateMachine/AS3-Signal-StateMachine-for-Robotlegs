package org.osflash.statemachine.states {
	import flexunit.framework.Assert;

	import org.osflash.statemachine.core.ISignalState;
	import org.osflash.statemachine.signals.Cancelled;
	import org.osflash.statemachine.signals.Entered;
	import org.osflash.statemachine.signals.EnteringGuard;
	import org.osflash.statemachine.signals.ExitingGuard;
	import org.osflash.statemachine.signals.TearDown;

	public class SignalState_PropertyTests {

		private var signalState:ISignalState;

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
		public function exitingGuard_gettingProperty_ReturnsTrue():void{
			Assert.assertTrue("exitingGuard property should be ExitingGuard", signalState.exitingGuard is ExitingGuard);
		}

		[Test]
		public function exitingGuard_CheckingExitingGuardsValueClassesLength_ReturnsOne():void{
			Assert.assertEquals("exitingGuard has one value class", 1, signalState.exitingGuard.valueClasses.length);
		}

		[Test]
		public function exitingGuard_CheckingExitingGuardsFirstValueClass_ReturnsTrue():void{
			Assert.assertTrue("exitingGuard's first value class should be an Object", signalState.exitingGuard.valueClasses[0] === Object);
		}

		[Test]
		public function enteringGuard_gettingProperty_ReturnsTrue():void{
			Assert.assertTrue("enteringGuard property should be EnteringGuard", signalState.enteringGuard is EnteringGuard);
		}

		[Test]
		public function enteringGuard_CheckingEnteringGuardsValueClassesLength_ReturnsOne():void{
			Assert.assertEquals("enteringGuard has one value class", 1, signalState.enteringGuard.valueClasses.length);
		}

		[Test]
		public function enteringGuard_CheckingEnteringGuardsFirstValueClass_ReturnsTrue():void{
			Assert.assertTrue("enteringGuard's first value class should be an Object", signalState.enteringGuard.valueClasses[0] === Object);
		}

		[Test]
		public function entered_gettingProperty_ReturnsTrue():void{
			Assert.assertTrue("entered property should be Entered", signalState.entered is Entered);
		}

		[Test]
		public function entered_CheckingEnteredsValueClassesLength_ReturnsOne():void{
			Assert.assertEquals("entered has one value class", 1, signalState.entered.valueClasses.length);
		}

		[Test]
		public function entered_CheckingEnteredsFirstValueClass_ReturnsTrue():void{
			Assert.assertTrue("entered's first value class should be an Object", signalState.entered.valueClasses[0] === Object);
		}


			[Test]
		public function teardown_gettingProperty_ReturnsTrue():void{
			Assert.assertTrue("tearDown property should be TearDown", signalState.tearDown is TearDown);
		}

		[Test]
		public function teardown_CheckingTearDownsValueClassesLength_ReturnsZero():void{
			Assert.assertEquals("teardown has one value class", 0, signalState.tearDown.valueClasses.length);
		}

		[Test]
		public function cancelled_gettingProperty_ReturnsTrue():void{
			Assert.assertTrue("cancelled property should be Cancelled", signalState.cancelled is Cancelled);
		}

		[Test]
		public function cancelled_CheckingCancelledsValueClassesLength_ReturnsTwo():void{
			Assert.assertEquals("cancelled has one value class", 2, signalState.cancelled.valueClasses.length);
		}

		[Test]
		public function cancelled_CheckingCancelledsFirstValueClass_ReturnsTrue():void{
			Assert.assertTrue(("cancelled's first value class should be a String", signalState.cancelled.valueClasses[0] === String) );
		}

		[Test]
		public function cancelled_CheckingCancelledsSecondValueClass_ReturnsTrue():void{
			Assert.assertTrue("cancelled's second value class should be an Object", signalState.cancelled.valueClasses[1] === Object);
		}


	}
}