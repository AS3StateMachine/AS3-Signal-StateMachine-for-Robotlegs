package org.osflash.statemachine.base {
	import org.osflash.signals.Signal;
	import org.osflash.statemachine.core.IFSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;
	import org.osflash.statemachine.core.IState;

		/**
		 * FSMController composes the Signals that communicate between the StateMachine
		 * and the framework actors.  It should be injected its IFSMController interface.
		 */
	public class FSMController implements IFSMController, IFSMControllerOwner {

		protected var _action:Signal;
		protected var _cancel:Signal;
		protected var _changed:Signal;
		private var _currentStateName:String;


		public function FSMController(){
			_action = new Signal( String, Object );
			_cancel = new Signal( String, Object );
			_changed = new Signal( IState );
		}

		/**
		 * @inheritDoc
		 */
		public function get currentStateName():String{
			return _currentStateName;
		}

		/**
		 * @inheritDoc
		 */
		public function action( actionName:String, payload:Object = null ):void{
			_action.dispatch( actionName, payload );
		}

		/**
		 * @inheritDoc
		 */
		public function cancel( reason:String, payload:Object = null ):void{
			_cancel.dispatch( reason, payload );
		}

		/**
		 * @inheritDoc
		 */
		public function addChangedListener( listener:Function ):Function{
			return _changed.add( listener );
		}

		/**
		 * @inheritDoc
		 */
		public function addChangedListenerOnce( listener:Function ):Function{
			return _changed.addOnce( listener );
		}

		/**
		 * @inheritDoc
		 */
		public function removeChangedListener( listener:Function ):Function{
			return _changed.remove( listener );
		}

		/**
		 * @inheritDoc
		 */
		public function addActionListener( listener:Function ):Function{
			return _action.add( listener );
		}

		/**
		 * @inheritDoc
		 */
		public function addCancelListener( listener:Function ):Function{
			return _cancel.add( listener );
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchChanged( state:IState ):void{
			_changed.dispatch( state );
		}

		/**
		 * @inheritDoc
		 */
		public function destroy():void{
			_action.removeAll();
			_cancel.removeAll();
			_changed.removeAll();
			_action = null;
			_cancel = null;
			_changed = null;
		}

		/**
		 * @inheritDoc
		 */
		public function setCurrentState( state:IState ):void{
			_currentStateName = state.name;
		}
	}
}