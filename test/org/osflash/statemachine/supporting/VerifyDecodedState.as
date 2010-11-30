package org.osflash.statemachine.supporting {

	import org.osflash.signals.Signal;
	import org.osflash.statemachine.core.ISignalState;
	import org.osflash.statemachine.signals.Cancelled;
	import org.osflash.statemachine.signals.Entered;
	import org.osflash.statemachine.signals.EnteringGuard;
	import org.osflash.statemachine.signals.ExitingGuard;
	import org.osflash.statemachine.signals.TearDown;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.ISignalCommandMap;

	public class VerifyDecodedState {

		private var _message:String = "no message set";
		private var _conclusion:Boolean;

		private var _scm:ISignalCommandMap;
		private var _injector:IInjector;

		public function VerifyDecodedState( injector:IInjector, scm:ISignalCommandMap ){
			_injector = injector;
			_scm = scm;
		}

		public function get message():String{
			return _message;
		}

		public function get conclusion():Boolean{
			return _conclusion;
		}

		public function verify( state:ISignalState, stateDef:XML ):Boolean{
			if( !testNullState( state ) )return false;
			if( !testIncorrectlyNamedState( stateDef.@name.toString(), state.name ) )return false;
			if( !testNumberOfTransitions( state, stateDef.transition ) )return false;
			if( !testTransitions( state, stateDef.transition ) )return false;
			if( !testNonInjectingStateHasNotBeenInjected( state, stateDef ) )return false;
			if( !testInjectingStateHasBeenInjected( state, stateDef ) )return false;
			if( !testExitingGuardCmdIsMapped( stateDef ) )return false;
			if( !testEnteringGuardCmdIsMapped( stateDef ) )return false;
			if( !testEnteredCmdIsMapped( stateDef ) )return false;
			if( !testTearDownCmdIsMapped( stateDef ) )return false;
			if( !testCancelledCmdIsMapped( stateDef ) )return false;
			_conclusion = true;
			return _conclusion;
		}

		private function testExitingGuardCmdIsMapped( stateDef:XML ):Boolean{
			var cmdName:String = stateDef.@exitingGuard.toString();
			var shouldMap:Boolean = ( cmdName != "" );
			if( !shouldMap )return testSignalPhaseCmdIsNotMapped( ExitingGuard );
			return testSignalPhaseCmdIsMapped( cmdName, ExitingGuard );
		}

		private function testEnteringGuardCmdIsMapped( stateDef:XML ):Boolean{
			var cmdName:String = stateDef.@enteringGuard.toString();
			var shouldMap:Boolean = ( cmdName != "" );
			if( !shouldMap )return testSignalPhaseCmdIsNotMapped( EnteringGuard );
			return testSignalPhaseCmdIsMapped( cmdName, EnteringGuard );
		}

		private function testEnteredCmdIsMapped( stateDef:XML ):Boolean{
			var cmdName:String = stateDef.@entered.toString();
			var shouldMap:Boolean = ( cmdName != "" );
			if( !shouldMap )return testSignalPhaseCmdIsNotMapped( Entered );
			return testSignalPhaseCmdIsMapped( cmdName, Entered );
		}

		private function testTearDownCmdIsMapped( stateDef:XML ):Boolean{
			var cmdName:String = stateDef.@teardown.toString();
			var shouldMap:Boolean = ( cmdName != "" );
			if( !shouldMap )return testSignalPhaseCmdIsNotMapped( TearDown );
			return testSignalPhaseCmdIsMapped( cmdName, TearDown );
		}

		private function testCancelledCmdIsMapped( stateDef:XML ):Boolean{
			var cmdName:String = stateDef.@cancelled.toString();
			var shouldMap:Boolean = ( cmdName != "" );
			if( !shouldMap )return testSignalPhaseCmdIsNotMapped( Cancelled );
			return testSignalPhaseCmdIsMapped( cmdName, Cancelled );
		}

		private function testSignalPhaseCmdIsMapped( cmdName:String, signalType:Class ):Boolean{
			var commands:Array = MockSignalCommandMap( _scm ).commands;
			var signals:Array = MockSignalCommandMap( _scm ).signals;
			var i:int = commands.indexOf( cmdName );
			if( i != -1 && signals[i] is signalType )return true;
			_message = cmdName + " has not been registered with the " + signalType.toString + " Signal";
			return false;
		}

		private function testSignalPhaseCmdIsNotMapped( signalType:Class ):Boolean{
			var signals:Array = MockSignalCommandMap( _scm ).signals;
			var commands:Array = MockSignalCommandMap( _scm ).commands;
			for ( var n:int = 0; n< signals.length; n++){
				var o:Object = signals[n];
				if( o is signalType){
					_message = signalType + " has been mapped with the command " + commands[n] + " when it has not been declared in the stateDef";
					return false;
				}
			}
			return true;

		}

		private function testInjectingStateHasBeenInjected( state:ISignalState, stateDef:XML ):Boolean{
			var shouldInject:Boolean = ( stateDef.@inject.toString() == "true");
			if( !shouldInject )return true;
			var stateMap:Object = MockInjector( _injector ).stateMap;
			if( stateMap[state.name] === state )return true;
			_message = "State has not been injected, even though its @inject='true' ";
			return false;
		}

		private function testNonInjectingStateHasNotBeenInjected( state:ISignalState, stateDef:XML ):Boolean{
			var shouldInject:Boolean = ( stateDef.@inject.toString() == "true");
			if( shouldInject )return true;
			var stateMap:Object = MockInjector( _injector ).stateMap;
			if( stateMap[state.name] == null )return true;
			_message = "State injected even though @inject='false' ";
			return false;
		}

		private function testNumberOfTransitions( state:ISignalState, transitionDef:XMLList ):Boolean{
			var transitionLenExpected:int = transitionDef.length();
			var transitionLenGot:int = state.length;
			if( transitionLenExpected == transitionLenGot ) return true;
			_message = "Expecting " + transitionLenExpected + " transitions defined, but got " + transitionLenGot + " instead.";
			return false;

		}

		private function testTransitions( state:ISignalState, transitionDef:XMLList ):Boolean{
			for each ( var def:XML in transitionDef ){
				var action:String = def.@action.toString();
				var target:String = def.@target.toString();
				var targetGot:String = state.getTarget( action );
				if( targetGot != target ){
					_message = "Expecting state: " + target + " for action: " + action + " but got: " + targetGot + " instead.";

					return false;
				}
			}
			return true;

		}

		private function testNullState( state:ISignalState ):Boolean{
			if( state != null )return true;
			_message = "State should be an ISignalState and should not be null";
			return false;
		}

		private function testIncorrectlyNamedState( expected:String, got:String ):Boolean{
			if( expected == got )return true;
			_message = "Expected state name to be: " + expected + " but got: " + got;
			return false;
		}

	}
}