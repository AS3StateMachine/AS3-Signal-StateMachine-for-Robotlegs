package org.osflash.statemachine.supporting {
import flash.utils.Dictionary;

import org.osflash.signals.ISignal;
import org.robotlegs.core.ISignalCommandMap;

public class MockSignalCommandMap implements ISignalCommandMap {

	public var testMap:Dictionary = new Dictionary();

	public function MockSignalCommandMap(){
	}

	public function mapSignal( signal:ISignal, commandClass:Class, oneShot:Boolean = false ):void{
		testMap[commandClass] = signal;
	}

	public function mapSignalClass( signalClass:Class, commandClass:Class, oneShot:Boolean = false ):ISignal{
		return null;
	}

	public function hasSignalCommand( signal:ISignal, commandClass:Class ):Boolean{
		return false;
	}

	public function unmapSignal( signal:ISignal, commandClass:Class ):void{
	}

	public function unmapSignalClass( signalClass:Class, commandClass:Class ):void{
	}
}
}