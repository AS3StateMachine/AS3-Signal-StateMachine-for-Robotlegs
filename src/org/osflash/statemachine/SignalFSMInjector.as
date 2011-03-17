package org.osflash.statemachine {
	import org.osflash.statemachine.core.IFSMController;
	import org.osflash.statemachine.core.IFSMInjector;
	import org.osflash.statemachine.core.ILoggable;
	import org.osflash.statemachine.core.IStateMachine;
	import org.osflash.statemachine.decoding.SignalXMLStateDecoder;
	import org.osflash.statemachine.transitioning.SignalTransitionController;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;
	import org.robotlegs.core.ISignalCommandMap;

	/**
	 * A helper class that wraps the injection of the Signal StateMachine
	 * to simplify creation.
	 */
	public class SignalFSMInjector {

		/**
		 * @private
		 */
		private var _decoder:SignalXMLStateDecoder;

		/**
		 * @private
		 */
		private var _injector:IInjector;

		/**
		 * @private
		 */
		private var _signalCommandMap:IGuardedSignalCommandMap;

		/**
		 * @private
		 */
		private var _fsmInjector:IFSMInjector;

		/**
		 * @private
		 */
		private var _stateMachine:IStateMachine;

		/**
		 * @private
		 */
		private var _transitionController:SignalTransitionController;

		/**
		 * Creates an instance of the injector
		 * @param injector the IInjector into which the StateMachine elements will be injected
		 * @param signalCommandMap the ISignalCommandMap in which the commands will be mapped
		 * to each states' Signals
		 */
		public function SignalFSMInjector( injector:IInjector, signalCommandMap:IGuardedSignalCommandMap ){
			_injector = injector;
			_signalCommandMap = signalCommandMap;
		}

		/**
		 * Initiates the Injector
		 * @param stateDefinition the StateMachine declaration
		 */
		public function initiate( stateDefinition:XML, logger:ILoggable=null ):void{
			// create a SignalStateDecoder and pass it the State Declaration
			_decoder = new SignalXMLStateDecoder( stateDefinition, _injector, _signalCommandMap );
			// add it the FSMInjector
			_fsmInjector = new FSMInjector( _decoder );
			// create a transitionController
			_transitionController = new SignalTransitionController( null, logger );
			// and pass it to the StateMachine
			_stateMachine = new StateMachine( _transitionController, logger );
		}

		/**
		 * Adds a commandClass to the decoder.
		 *
		 * Any Command declared in the StateDeclaration must be added before the StateMachine is injected
		 * @param commandClass a command Class reference
		 * @return Whether the command Class was added successfully
		 */
		public function addClass( commandClass:Class ):Boolean{
			return _decoder.addClass( commandClass );
		}

		/**
		 * Test to determine whether a particular class has already been added
		 * to the decoder
		 * @param name this can either be the name, the fully qualified name or an instance of the Class
		 * @return
		 */
		public function hasClass( name:Object ):Boolean{
			return _decoder.hasClass( name );
		}

		/**
		 * Injects the StateMachine
		 */
		public function inject():void{

			// inject the statemachine (mainly to make sure that it doesn't get GCd )
			_injector.mapValue( IStateMachine, _stateMachine );
			// inject the fsmController to allow actors to control fsm
			_injector.mapValue( IFSMController, _transitionController.fsmController );
			
			// inject the statemachine, it will proceed to the initial state.
			// NB no injection rules have been set for view or model yet, the initial state
			// should be a resting one and the next state should be triggered by the
			// onApplicationComplete event in the ApplicationMediator
			_fsmInjector.inject( _stateMachine );




		}

		/**
		 * The destroy method for GC.
		 *
		 * NB Once injected the instance is no longer needed, so it can be destroyed
		 */
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