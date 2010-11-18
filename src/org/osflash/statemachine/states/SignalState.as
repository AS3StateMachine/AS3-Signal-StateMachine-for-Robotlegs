/*
 ADAPTED FOR ROBOTLEGS FROM:
 PureMVC AS3 Utility - StateMachine
 Copyright (c) 2008 Neil Manuell, Cliff Hall
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.osflash.statemachine.states {
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.statemachine.base.BaseState;
	import org.osflash.statemachine.core.ISignalState;

	/**
 * Defines a SignalState.
 */
public class SignalState extends BaseState implements   ISignalState {
	protected var _enteringGuard:Signal;
	protected var _exitingGuard:Signal;
	protected var _entered:Signal;
	protected var _tearDown:Signal;
	protected var _cancelled:Signal;

	/**
	 * Constructor.
	 *
	 * @param name the id of the state
	 */
	public function SignalState( name:String ):void{
		super( name );
	}

	public function get entered():ISignal{
		if( _entered == null )_entered = new Signal( Object );
		return _entered;
	}

	public function get enteringGuard():ISignal{
		if( _enteringGuard == null ) _enteringGuard = new Signal( Object );
		return _enteringGuard
	}

	public function get exitingGuard():ISignal{
		if( _exitingGuard == null ) _exitingGuard = new Signal( Object );
		return _exitingGuard;
	}

	public function get cancelled():ISignal{
		if( _cancelled == null ) _cancelled = new Signal(String, Object);
		return _cancelled;
	}

	public function get tearDown():ISignal{
		if( _tearDown == null ) _tearDown = new Signal();
		return _tearDown;
	}

	public function dispatchEnteringGuard( data:Object ):void{
		if( _enteringGuard == null || _enteringGuard.numListeners < 0 ) return;
		_enteringGuard.dispatch( data );
	}

	public function dispatchExitingGuard( data:Object ):void{
		if( _exitingGuard == null || _exitingGuard.numListeners < 0 ) return;
		_exitingGuard.dispatch( data );
	}

	public function dispatchTearDown():void{
		if( _tearDown == null || _tearDown.numListeners < 0 ) return;
		_tearDown.dispatch();
	}

	public function dispatchCancelled( reason:String, data:Object ):void{
		if( _cancelled == null || _cancelled.numListeners < 0 ) return;
		_cancelled.dispatch( reason, data );
	}

	public function dispatchEntered( data:Object ):void{
		if( _entered == null || _entered.numListeners < 0 ) return;
		_entered.dispatch( data );
	}

	override public function destroy():void{
		_entered.removeAll();
		_enteringGuard.removeAll();
		_exitingGuard.removeAll();
		_tearDown.removeAll();
		_cancelled.removeAll();

		_entered = null;
		_enteringGuard = null;
		_exitingGuard = null;
		_tearDown = null;
		_cancelled = null;

		super.destroy();
	}
}
}