package org.osflash.statemachine.core {

public interface ISignalFSMController {
	function action( action:String, data:Object = null ):void;

	function cancel( reason:String, data:Object = null ):void;

	function addChangedListener( handler:Function ):Function;

	function addChangedListenerOnce( handler:Function ):Function;

	function removeChangedListener( handler:Function ):Function;

	function addActionListener( handler:Function ):Function;

	function addCancelListener( handler:Function ):Function;

	function dispatchChanged( state:IState ):void

	function destroy():void;
}
}