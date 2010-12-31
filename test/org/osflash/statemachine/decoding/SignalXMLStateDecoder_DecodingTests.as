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

	public class SignalXMLStateDecoder_DecodingTests {

		private var signalStateDecoder:SignalXMLStateDecoder;
		private var mockInjector:MockInjector;
		private var mockSignalCommandMap:MockSignalCommandMap;

		[Before]
		public function before():void{
			mockInjector = new MockInjector();
			mockSignalCommandMap = new MockSignalCommandMap();
			signalStateDecoder = new SignalXMLStateDecoder( null, mockInjector, mockSignalCommandMap );

		}

		[After]
		public function after():void{

			signalStateDecoder.destroy();
			signalStateDecoder = null;
			mockInjector = null;
			mockSignalCommandMap = null;
		}

		
		[Test]
		public function decodeState_NonInjectedStateWithTransitionsOnly_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" >
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test]
		public function decodeState_InjectedStateWithTransitionsOnly_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" inject="true">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test]
		public function decodeState_StateWithExitingGuardPhaseDeclared_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" exitingGuard="ExitingGuardCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			signalStateDecoder.addCommandClass( ExitingGuardCmd );

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test]
		public function decodeState_StateWithEnteringGuardPhaseDeclared_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" enteringGuard="EnteringGuardCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			signalStateDecoder.addCommandClass( EnteringGuardCmd );

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test]
		public function decodeState_StateWithEnteredPhaseDeclared_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" entered="EnteredCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			signalStateDecoder.addCommandClass( EnteredCmd );

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test]
		public function decodeState_StateWithTearDownPhaseDeclared_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" teardown="TearDownCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			signalStateDecoder.addCommandClass( TearDownCmd );

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test]
		public function decodeState_StateWithCancelledPhaseDeclared_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" cancelled="CancelledCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			signalStateDecoder.addCommandClass( CancelledCmd );

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test]
		public function decodeState_StateWithAllPhasesDeclared_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" enteringGuard="EnteringGuardCmd"
					exitingGuard="ExitingGuardCmd" entered="EnteredCmd"
					teardown="TearDownCmd" cancelled="CancelledCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			signalStateDecoder.addCommandClass( EnteringGuardCmd );
			signalStateDecoder.addCommandClass( ExitingGuardCmd );
			signalStateDecoder.addCommandClass( EnteredCmd );
			signalStateDecoder.addCommandClass( TearDownCmd );
			signalStateDecoder.addCommandClass( CancelledCmd );

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test(expected="org.osflash.statemachine.errors.UnregisteredSignalCommandError")]
		public function decodeState_StateWithAllPhasesDeclaredOneCommandClassNotAddedToDecoder_ThrowsUnregisteredSignalCommandError():void{
			var stateDef:XML =
					<state name="state/test" enteringGuard="EnteringGuardCmd"
					exitingGuard="ExitingGuardCmd" entered="EnteredCmd"
					teardown="TearDownCmd" cancelled="CancelledCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action="action/two" target={"state/two"}/>
						<transition action="action/three" target={"state/three"}/>
					</state>;

			signalStateDecoder.addCommandClass( EnteringGuardCmd );
			signalStateDecoder.addCommandClass( ExitingGuardCmd );
			signalStateDecoder.addCommandClass( EnteredCmd );
			signalStateDecoder.addCommandClass( TearDownCmd );

			var state:ISignalState = signalStateDecoder.decodeState( stateDef ) as ISignalState;
			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );



		}

	}
}
