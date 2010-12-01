package org.osflash.statemachine.decoding {
	import flexunit.framework.Assert;

	import org.osflash.signals.ISignal;
	import org.osflash.statemachine.base.BaseState;
	import org.osflash.statemachine.core.ISignalState;
	import org.osflash.statemachine.core.IState;
	import org.osflash.statemachine.signals.EnteringGuard;
	import org.osflash.statemachine.states.SignalState;
	import org.osflash.statemachine.supporting.mocks.MockInjector;
	import org.osflash.statemachine.supporting.mocks.MockSignalCommandMap;
	import org.osflash.statemachine.supporting.VerifyDecodedState;
	import org.osflash.statemachine.supporting.cmds.CancelledCmd;
	import org.osflash.statemachine.supporting.cmds.EnteredCmd;
	import org.osflash.statemachine.supporting.cmds.EnteringGuardCmd;
	import org.osflash.statemachine.supporting.cmds.ExitingGuardCmd;
	import org.osflash.statemachine.supporting.cmds.TearDownCmd;

	public class SignalXMLStateDecoder_AddCommandTests {

		private var signalStateDecoder:SignalXMLStateDecoder;


		[Before]
		public function before():void{

			signalStateDecoder = new SignalXMLStateDecoder( null, null, null );

		}

		[After]
		public function after():void{
			signalStateDecoder.destroy();
			signalStateDecoder = null;
		}


		[Test]
		public function addCommandClass_AddingCommandClassOnce_ReturnsTrue(  ):void{
			Assert.assertTrue("Adding commandClass should succeed", signalStateDecoder.addCommandClass( EnteringGuardCmd ) );
		}

		[Test]
		public function addCommandClass_AddingCommandClassTwice_ReturnsFalse(  ):void{
			signalStateDecoder.addCommandClass( EnteringGuardCmd );
			Assert.assertFalse("Adding the same commandClass again should fail", signalStateDecoder.addCommandClass( EnteringGuardCmd ) );
		}

		[Test]
		public function hasCommandClass_AddingCommandClassAndTestingForIt_ReturnsTrue(  ):void{
			signalStateDecoder.addCommandClass( EnteringGuardCmd );
			Assert.assertTrue("EnteringGuardCmd has been registered so should return true", signalStateDecoder.hasCommandClass( EnteringGuardCmd ) );
		}

		[Test]
		public function hasCommandClass_NotAddingCommandClassAndTestingForIt_ReturnsFalse(  ):void{
			Assert.assertFalse("EnteringGuardCmd has not been registered so should return false", signalStateDecoder.hasCommandClass( EnteringGuardCmd ) );
		}

		[Test]
		public function getCommandClass_AddingCommandClassAndRetrievingItUsingClassName_ReturnsCommandClass(  ):void{
			signalStateDecoder.addCommandClass( EnteringGuardCmd );
			Assert.assertStrictlyEquals(  EnteringGuardCmd, signalStateDecoder.getCommandClass( "EnteringGuardCmd" ) );
		}

		[Test]
		public function getCommandClass_AddingCommandClassAndRetrievingItUsingFullyQualifiedPath_ReturnsCommandClass(  ):void{
			signalStateDecoder.addCommandClass( EnteringGuardCmd );
			Assert.assertStrictlyEquals(  EnteringGuardCmd, signalStateDecoder.getCommandClass( "org.osflash.statemachine.supporting.cmds::EnteringGuardCmd" ) );
		}

		[Test]
		public function getCommandClass_AddingCommandClassAndRetrievingItUsingFullPath_ReturnsCommandClass(  ):void{
			signalStateDecoder.addCommandClass( EnteringGuardCmd );
			Assert.assertStrictlyEquals(  EnteringGuardCmd, signalStateDecoder.getCommandClass( "org.osflash.statemachine.supporting.cmds.EnteringGuardCmd" ) );
		}

		[Test]
		public function getCommandClass_NotAddingCommandClassAndRetrievingItUsingClassName_ReturnsNull(  ):void{
			Assert.assertNull(  EnteringGuardCmd, signalStateDecoder.getCommandClass( "EnteringGuardCmd" ) );
		}

		
	}
}
