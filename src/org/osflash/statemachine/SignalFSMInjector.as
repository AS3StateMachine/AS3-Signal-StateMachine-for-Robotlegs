package org.osflash.statemachine {
	import org.osflash.statemachine.core.IFSMController;
	import org.osflash.statemachine.core.IFSMInjector;
	import org.osflash.statemachine.core.IStateMachine;
	import org.osflash.statemachine.decoding.SignalStateDecoder;
	import org.osflash.statemachine.transitioning.SignalTransitionController;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.ISignalCommandMap;

	public class SignalFSMInjector {

		private var _decoder:SignalStateDecoder;
		private var _injector:IInjector;
		private var _signalCommandMap:ISignalCommandMap;
		private var _fsmInjector:IFSMInjector;
		private var _stateMachine:IStateMachine;
		private var _transitionController:SignalTransitionController;

		public function SignalFSMInjector( injector:IInjector, signalCommandMap:ISignalCommandMap ){
			_injector = injector;
			_signalCommandMap = signalCommandMap;
		}

		public function initiate( stateDefinition:XML ):void{
			// create a SignalStateDecoder and pass it the State Declaration
			_decoder = new SignalStateDecoder( stateDefinition, _injector, _signalCommandMap );
			// add it the FSMInjector
			_fsmInjector = new FSMInjector( _decoder );
			// create a transitionController
			_transitionController = new SignalTransitionController();
			// and pass it to the StateMachine
			_stateMachine = new StateMachine( _transitionController );
		}

		public function addCommandClass( commandClass:Class ):Boolean{
			return _decoder.addCommandClass( commandClass );
		}

		public function inject():void{
			// inject the statemachine, it will proceed to the initial state.
			// NB no injection rules have been set for view or model yet, the initial state
			// should be a resting one and the next state should be triggered by the
			// onApplicationComplete event in the ApplicationMediator
			_fsmInjector.inject( _stateMachine );

			// inject the statemachine (mainly to make sure that it doesn't get GCd )
			_injector.mapValue( IStateMachine, _stateMachine );
			// inject the fsmController to allow actors to control fsm
			_injector.mapValue( IFSMController, _transitionController.fsmController );


		}

		public function destroy():void{
			_fsmInjector.destroy();
			_fsmInjector = null;
			_decoder = null;
			_injector = null;
			_signalCommandMap = null;

			_stateMachine = null;
			_transitionController = null;
		}
	}
}