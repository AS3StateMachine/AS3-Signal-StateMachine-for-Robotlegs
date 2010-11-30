package org.osflash.statemachine.supporting {
	import flash.utils.Dictionary;

	import flash.utils.describeType;

	import org.osflash.signals.ISignal;
	import org.robotlegs.core.ISignalCommandMap;

	public class MockSignalCommandMap implements ISignalCommandMap {

	public var signals:Array = [];
	public var commands:Array = [];

	public function MockSignalCommandMap(){
	}

	public function mapSignal( signal:ISignal, commandClass:Class, oneShot:Boolean = false ):void{
		signals.push( signal );
		commands.push( describeType( commandClass ).@name.toString().split("::")[1] );
	}

	// All other methods empty
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