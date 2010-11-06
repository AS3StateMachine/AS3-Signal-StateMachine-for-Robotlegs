package org.osflash.statemachine.base {
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;
import org.osflash.statemachine.core.ISignalFSMController;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.signals.Action;
import org.osflash.statemachine.signals.Cancel;
import org.osflash.statemachine.signals.Changed;

public class SignalFSMController implements ISignalFSMController {

	private var _action:ISignal;
	private var _cancel:ISignal;
	private var _changed:ISignal;

	public function SignalFSMController(){
		_action = new Action();
		_cancel = new Cancel();
		_changed = new Changed();
	}

	public function action( actionName:String, data:Object = null ):void{
		Signal( _action ).dispatch( actionName, data );
	}

	public function cancel( reason:String, data:Object = null ):void{
		Signal( _cancel ).dispatch( reason, data );
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
		Signal( _changed ).dispatch( state );
	}

	public function destroy():void{
		Signal( _action ).removeAll();
		Signal( _cancel ).removeAll();
		Signal( _changed ).removeAll();
		_action = null;
		_cancel = null;
		_changed = null;
	}
}
}