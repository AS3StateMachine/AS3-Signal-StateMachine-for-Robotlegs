package org.osflash.statemachine.core {

public interface IFSMControllerOwner {

	function addActionListener( handler:Function ):Function;

	function addCancelListener( handler:Function ):Function;

	function dispatchChanged( state:IState ):void

	function destroy():void;

	function setCurrentState( state:IState ):void;
}
}