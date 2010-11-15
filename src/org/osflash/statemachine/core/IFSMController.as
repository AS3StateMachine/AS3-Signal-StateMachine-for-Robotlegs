package org.osflash.statemachine.core {

public interface IFSMController {

	function get currentStateName():String;
	
	function action( action:String, data:Object = null ):void;

	function cancel( reason:String, data:Object = null ):void;

	function addChangedListener( handler:Function ):Function;

	function addChangedListenerOnce( handler:Function ):Function;

	function removeChangedListener( handler:Function ):Function;

}
}