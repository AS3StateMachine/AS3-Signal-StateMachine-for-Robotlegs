package org.osflash.statemachine.decoding {

	import org.osflash.signals.ISignal;
	import org.osflash.statemachine.base.BaseState;
	import org.osflash.statemachine.base.BaseXMLStateDecoder;
	import org.osflash.statemachine.core.ISignalState;
	import org.osflash.statemachine.core.IState;
	import org.osflash.statemachine.errors.UnregisteredSignalCommandError;
	import org.osflash.statemachine.states.SignalState;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.ISignalCommandMap;

	/**
	 * A StateDecoder is used by the FSMInjector to encapsulate the decoding of a
	 * state declaration into a concrete IState instance.
	 *
	 * This implementation converts an XML declaration into an ISignalState, it also
	 * is the point where the DI takes place, and thus where all the Robotleg
	 * dependencies are encapsulated.
	 *
	 * @see org.osflash.statemachine.FSMInjector
	 * @see org.osflash.statemachine.core.ISignalState
	 * @see org.osflash.statemachine.states.SignalState
	 */
	public class SignalXMLStateDecoder extends BaseXMLStateDecoder {

		/**
		 * @private
		 */
		protected var classBagMap:Array;

		/**
		 * @private
		 */
		protected var injector:IInjector;

		/**
		 * @private
		 */
		protected var signalCommandMap:ISignalCommandMap;

		/**
		 * Creates an instance of a SignalXMLStateDecoder
		 * @param fsm the state declaration
		 * @param injector the injector for the current IContext
		 * @param signalCommandMap the ISignalCommandMap for the current IContext
		 */
		public function SignalXMLStateDecoder( fsm:XML, injector:IInjector, signalCommandMap:ISignalCommandMap ):void{
			this.injector = injector;
			this.signalCommandMap = signalCommandMap;
			super( fsm );
		}

		/**
		 * @inheritDoc
		 */
		override public final function decodeState( stateDef:Object ):IState{
			// Create State object
			var state:ISignalState = getState( stateDef );
			decodeTransitions( state, stateDef );
			injectState( state, stateDef );
			mapSignals( state, stateDef );
			return state;
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy():void{
			injector = null;
			signalCommandMap = null;
			if( classBagMap != null){
				for each ( var cb:ClassBag in classBagMap )	cb.destroy();
			}
			classBagMap = null;
			super.destroy();
		}

		/**
		 * Adds a command Class reference.
		 *
		 * Any command declared in the state declaration must be added here.
		 * @param commandClass the command class
		 * @return whether the command class has been add successfully
		 */
		public function addCommandClass( commandClass:Class ):Boolean{
			if( classBagMap == null ) classBagMap = [];
			if( hasCommandClass( commandClass ) ) return false;
			classBagMap.push( new ClassBag( commandClass ) );
			return true;
		}

		/**
		 * Test to determine whether a particular class has already been added
		 * to the decoder
		 * @param name this can either be the name, the fully qualified name or an instance of the Class
		 * @return 
		 */
		public function hasCommandClass( name:Object ):Boolean{
			return ( getCommandClass( name ) != null );
		}

		/**
		 * Retrieves a command class registered with the addCommandClass method
		 * @param name this can either be the name, the fully qualified name or an instance of the Class
		 * @return the class reference
		 */
		protected function getCommandClass( name:Object ):Class{
			for each ( var cb:ClassBag in classBagMap ){
				if( cb.equals( name ) ) return cb.payload;
			}
			return null;
		}

		/**
		 * Factory method for creating concrete ISignalState. Override this to allow for the
		 * creation of custom states
		 * @param stateDef the declaration for a single state
		 * @return an instance of the state described in the data
		 */
		protected function getState( stateDef:Object ):ISignalState{
			return new SignalState( stateDef.@name.toString() );
		}

		/**
		 * Decodes the State's transitions from the state declaration
		 * @param state the state into which to inject the transitions
		 * @param stateDef the state's declaration
		 */
		protected function decodeTransitions( state:IState, stateDef:Object ):void{
			var transitions:XMLList = stateDef..transition as XMLList;
			for( var i:int; i < transitions.length(); i++ ){
				var transDef:XML = transitions[i];
				state.defineTrans( String( transDef.@action ), String( transDef.@target ) );
			}
		}

		/**
		 * Injects a IState into the DI Container if it is marked for injection in its declaration
		 * @param state the IState to be injected
		 * @param stateDef the state's declaration
		 */
		protected function injectState( state:IState, stateDef:Object ):void{
			var inject:Boolean = ( stateDef.@inject.toString() == "true" );
			if( inject )
				injector.mapValue( ISignalState, state, state.name );

		}

		/**
		 * Maps the commands referenced int he state declaration to their appropriate
		 * state transition phases
		 * @param signalState the state whose ISignal phases are to be mapped to
		 * @param stateDef the state's declaration
		 */
		protected function mapSignals( signalState:ISignalState, stateDef:Object ):void{

			var exitingGuard:String = stateDef.@exitingGuard.toString();
			var enteringGuard:String = stateDef.@enteringGuard.toString();
			var entered:String = stateDef.@entered.toString();
			var tearDown:String = stateDef.@teardown.toString();
			var cancelled:String = stateDef.@cancelled.toString();

			if( exitingGuard != "" )
				mapSignalCommand( signalState.exitingGuard, exitingGuard );

			if( enteringGuard != "" )
				mapSignalCommand( signalState.enteringGuard, enteringGuard );

			if( entered != "" )
				mapSignalCommand( signalState.entered, entered );

			if( tearDown != "" )
				mapSignalCommand( signalState.tearDown, tearDown );

			if( cancelled != "" )
				mapSignalCommand( signalState.cancelled, cancelled );

		}

		/**
		 * @private
		 */
		private function mapSignalCommand( signal:ISignal, commandClassName:String ):void{
			var c:Class = getCommandClass( commandClassName );
			if( c == null )throw new UnregisteredSignalCommandError( commandClassName );
			signalCommandMap.mapSignal( signal, c );
		}

	}
}

import flash.utils.describeType;

import org.osflash.statemachine.core.IClassBag;

/**
 * Wrapper class for a Class reference.
 */
internal class ClassBag implements IClassBag {

	private var _pkg:String;

	private var _name:String;

	private var _payload:Class;

	/**
	 * Wraps and reflects a class reference instance )
	 */
	public function ClassBag( c:Class ):void{
		_payload = c;
		describeClass( c );
	}

	/**
	 * @inheritDoc
	 */
	public function get name():String{
		return _name;
	}

	/**
	 * @inheritDoc
	 */
	public function get payload():Class{
		return _payload;
	}

	/**
	 * @inheritDoc
	 */
	public function get pkg():String{
		return _pkg;
	}

	/**
	 * @inheritDoc
	 */
	public function toString():String{
		return _pkg + "." + _name;
	}

	/**
	 * @inheritDoc
	 */
	public function equals( value:Object ):Boolean{
		return (( value.toString() == _pkg + "." + _name ) ||
				( value.toString() == _pkg + "::" + _name ) ||
				( value.toString() == _name ) ||
				( value == _payload )						    );
	}

	/**
	 * Destroys the ClassBag
	 */
	public function destroy():void{
		_payload = null;
		_name = null;
		_pkg = null;
	}

	/**
	 * @private
	 */
	private function describeClass( c:Class ):void{
		var description:XML = describeType( c );
		var split:Array = description.@name.toString().split( "::" );
		_pkg = String( split[0] );
		_name = String( split[1] );
	}
}
