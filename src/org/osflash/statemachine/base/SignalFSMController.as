package org.osflash.statemachine.base {
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;
import org.osflash.statemachine.core.ISignalFSMController;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.signals.Action;
import org.osflash.statemachine.signals.Cancel;
import org.osflash.statemachine.signals.Changed;

public class SignalFSMController implements ISignalFSMController {

	protected var _action:Signal;
	protected var _cancel:Signal;
	protected var _changed:Signal;

	public function SignalFSMController(){
		_action = new Action();
		_cancel = new Cancel();
		_changed = new Changed();
	}

	public function action( actionName:String, data:Object = null ):void{
		 _action.dispatch( actionName, data );
	}

	public function cancel( reason:String, data:Object = null ):void{
		_cancel.dispatch( reason, data );
	}

	public function addChangedListener( handler:Function ):Function{
		return _changed.add( handler );
	}

	public function addChangedListenerOnce( handler:Function ):Function{
		return _changed.addOnce( handler );
	}

	public function removeChangedListener( handler:Function ):Function{
		return _changed.remove( handler );
	}

	public function addActionListener( handler:Function ):Function{
		return _action.add( handler );
	}

	public function addCancelListener( handler:Function ):Function{
		return _cancel.add( handler );
	}

	public function dispatchChanged( state:IState ):void{
		_changed.dispatch( state );
	}

	public function destroy():void{
		_action.removeAll();
		_cancel.removeAll();
		_changed.removeAll();
		_action = null;
		_cancel = null;
		_changed = null;
	}
}
}