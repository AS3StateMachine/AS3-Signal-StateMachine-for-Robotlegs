package org.osflash.statemachine.decoding {
	import flexunit.framework.Assert;

	import org.osflash.signals.ISignal;
	import org.osflash.statemachine.base.BaseState;
	import org.osflash.statemachine.core.ISignalState;
	import org.osflash.statemachine.core.IState;
	import org.osflash.statemachine.signals.EnteringGuard;
	import org.osflash.statemachine.signals.TearDown;
	import org.osflash.statemachine.states.SignalState;
	import org.osflash.statemachine.supporting.MockInjector;
	import org.osflash.statemachine.supporting.MockSignalCommandMap;
	import org.osflash.statemachine.supporting.VerifyDecodedState;
	import org.osflash.statemachine.supporting.cmds.CancelledCmd;
	import org.osflash.statemachine.supporting.cmds.EnteredCmd;
	import org.osflash.statemachine.supporting.cmds.EnteringGuardCmd;
	import org.osflash.statemachine.supporting.cmds.ExitingGuardCmd;
	import org.osflash.statemachine.supporting.cmds.TearDownCmd;

	public class VerifyDecodedStateTest {

		private var mockInjector:MockInjector;
		private var mockSignalCommandMap:MockSignalCommandMap;
		private var verifier:VerifyDecodedState;

		[Before]
		public function before():void{
			mockInjector = new MockInjector();
			mockSignalCommandMap = new MockSignalCommandMap();
			verifier = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
		}

		[After]
		public function after():void{

		}

		[Test]
		public function verify_ConstructingAnISignalStateByHadAndVerifying_ReturnsTrue():void{
			var stateDef:XML =
					<state name="state/test" >
						<transition action="action/one" target="state/one"/>
						<transition action="action/two" target="state/two"/>
						<transition action="action/three" target="state/three"/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertTrue( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_IncorrectStateName_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" >
						<transition action="action/one" target="state/one"/>
						<transition action="action/two" target="state/two"/>
						<transition action="action/three" target="state/three"/>
					</state>;

			var state:ISignalState = new SignalState( "state/wrong name" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_MismatchingNumberOfTransitions_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" >
						<transition action="action/one" target="state/one"/>
						<transition action="action/two" target="state/two"/>
						<transition action="action/three" target="state/three"/>
						<transition action="action/four" target="state/five"/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_MismatchingTransitionDefinitions_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" >
						<transition action="action/one" target="state/one"/>
						<transition action="action/two" target="state/two"/>
						<transition action="action/three" target="state/three"/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/two" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_NonInjectingStateIsInjected_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" >
						<transition action="action/one" target="state/one"/>
						<transition action="action/two" target="state/two"/>
						<transition action="action/three" target="state/three"/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			mockInjector.mapValue( ISignalState, state, state.name );

			var verifier:VerifyDecodedState = new VerifyDecodedState( mockInjector, mockSignalCommandMap );
			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_InjectingStateHasNotBeenInjected_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" inject="true" >
						<transition action="action/one" target="state/one"/>
						<transition action="action/two" target="state/two"/>
						<transition action="action/three" target="state/three"/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithExitingGuardPhaseDeclaredButNotMapped_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" exitingGuard="ExitingGuardCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithEnteringGuardPhaseDeclaredButNotMapped_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" enteringGuard="EnteringGuardCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithEnteredPhaseDeclaredButNotMapped_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" entered="EnteredCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithTearDownPhaseDeclaredButNotMapped_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" teardown="TearDownCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithCancelledPhaseDeclaredButNotMapped_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test" cancelled="CancelledCmd">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithEnteringGuardPhaseMappedButNotDeclared_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			mockSignalCommandMap.mapSignal(state.enteringGuard, EnteringGuardCmd );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithExitingGuardPhaseMappedButNotDeclared_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			mockSignalCommandMap.mapSignal(state.exitingGuard, ExitingGuardCmd );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithEnteredPhaseMappedButNotDeclared_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			mockSignalCommandMap.mapSignal(state.entered, EnteredCmd );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithTearDownPhaseMappedButNotDeclared_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			mockSignalCommandMap.mapSignal(state.tearDown, TearDownCmd );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

		[Test]
		public function verify_StateWithCancelledPhaseMappedButNotDeclared_ReturnsFalse():void{
			var stateDef:XML =
					<state name="state/test">
						<transition action="action/one" target={"state/one"}/>
						<transition action={"action/two"} target={"state/two"}/>
						<transition action={"action/three"} target={"state/three"}/>
					</state>;

			var state:ISignalState = new SignalState( "state/test" );
			state.defineTrans( "action/one", "state/one" );
			state.defineTrans( "action/two", "state/two" );
			state.defineTrans( "action/three", "state/three" );

			mockSignalCommandMap.mapSignal(state.cancelled, CancelledCmd );

			verifier.verify( state, stateDef );

			Assert.assertFalse( verifier.message, verifier.conclusion );

		}

	}
}
