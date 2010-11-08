package org.osflash.statemachine.core {
	public interface IClassBag {
		function get name():String;
		function get payload():Class;
		function get pkg():String;
		function equals( value:Object ):Boolean
		function destroy():void

	}
}