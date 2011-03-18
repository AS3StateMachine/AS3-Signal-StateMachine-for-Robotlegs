package org.osflash.statemachine.base {
	import org.osflash.signals.Signal;
	import org.osflash.statemachine.core.IFSMController;
	import org.osflash.statemachine.core.IFSMControllerOwner;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.IState;
	import org.osflash.statemachine.errors.StateTransitionError;
	import org.osflash.statemachine.signals.Action;
	import org.osflash.statemachine.signals.Cancel;
	import org.osflash.statemachine.signals.Changed;
	import org.osflash.statemachine.core.ITransitionPhase;
import org.osflash.statemachine.transitioning.Payload;
import org.osflash.statemachine.transitioning.TransitionPhase;

/**
	 * SignalStateMachine FSMController composes the Signals that communicate between the StateMachine
	 * and the framework actors.  It should be injected its IFSMController interface.
	 */
	public class FSMController implements IFSMController, IFSMControllerOwner {

		/**
		 * @private
		 */
		protected var _action:Signal;

		/**
		 * @private
		 */
		protected var _cancel:Signal;

		/**
		 * @private
		 */
		protected var _changed:Signal;

		/**
		 * @private
		 */
		private var _currentStateName:String;

		/**
		 * @private
		 */
		private var _referringAction:String;

		/**
		 * @private
		 */
		private const ILLEGAL_ACTION_ERROR:String = "An new transition can not be actioned from an enteringGuard, exitingGuard or a tearDown phase";

		/**
		 * @private
		 */
		private const ILLEGAL_CANCEL_ERROR:String = "A transition can only be cancelled from an enteringGuard or exitingGuard phase";

		/**
		 * @private
		 */
		private var _isTransitioning:Boolean;

		/**
		 * @private
		 */
		private var _cacheActionName:String;

		/**
		 * @private
		 */
		private var _cachePayload:IPayload;

		/**
		 * @private
		 */
		private var _transitionPhase:ITransitionPhase = TransitionPhase.NONE;

		/**
		 * Creates a new instance of FSMController
		 */
		public function FSMController(){
			_action = new Action( );
			_cancel = new Cancel( );
			_changed = new Changed( );
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
		public function get referringAction():String{
			return _referringAction;
		}

		/**
		 * @inheritDoc
		 */
		public function get isTransitioning():Boolean{
			return _isTransitioning;
		}

		/**
		 * @inheritDoc
		 */
		public function get transitionPhase():String{
			return _transitionPhase.name;
		}

		/**
		 * Sends an action to the StateMachine, precipitating a state transition.
		 *
		 * If a transition is actioned during a permitted transition phase, then the action is scheduled to be sent
		 * immediately the transition cycle is over.
		 *
		 * @param actionName the name of the action.
		 * @param payload the data to be sent with the action.
		 *
		 * @throws org.osflash.statemachine.errors.StateTransitionError Thrown if a transition is actioned from a
		 * <strong>tearDown</strong>, <strong>enteringGuard</strong> or <strong>enteringGuard</strong> phase of a
		 * transition cycle.
		 */
		public function action( actionName:String, payload:Object = null ):void{

			var isIllegal:Boolean =
                    (_transitionPhase == TransitionPhase.TEAR_DOWN ||
					_transitionPhase == TransitionPhase.ENTERING_GUARD ||
					_transitionPhase == TransitionPhase.EXITING_GUARD       );

			if( isIllegal )
				throw new StateTransitionError( ILLEGAL_ACTION_ERROR );
			else
				instigateAction( actionName, payload );

		}

		/**
		 * @private
		 */
		private function instigateAction( actionName:String, payloadBody:Object = null ):void{
            var  payload:IPayload = wrapPayload( payloadBody );
			if( isTransitioning ){
				_cacheActionName = actionName;
				_cachePayload = payload;
				addChangedListenerOnce( dispatchActionLater );
			}
			else _action.dispatch( actionName, payload );
		}

		/**
		 * @private
		 */
		private function dispatchActionLater( stateName:String = null ):void{
			_action.dispatch( _cacheActionName, _cachePayload );
			_cacheActionName = null;
			_cachePayload = null;
		}

		/**
		 * Cancels the current transition.
		 *
		 * NB: A transitions can only be cancelled during the <strong>enteringGuard</strong> or <strong>exitingGuard</strong>
		 * phases of a transition.
		 *
		 * @param reason information regarding the reason for the cancellation
		 * @param payload the data to be sent to the <strong>cancelled</strong> phase.
		 * @throws org.osflash.statemachine.errors.StateTransitionError Thrown if a transition is cancelled from a transition phase
		 * other than an enteringGuard or exitingGuard.
		 */
		public function cancel( reason:String, payloadBody:Object = null ):void{

            var payload:IPayload = wrapPayload( payloadBody );

			var isLegal:Boolean =
                    ( _transitionPhase == TransitionPhase.ENTERING_GUARD ||
					_transitionPhase == TransitionPhase.EXITING_GUARD       );

			if( isLegal )
				_cancel.dispatch( reason, payload );
			else
				throw new StateTransitionError( ILLEGAL_CANCEL_ERROR );

		}

    private function wrapPayload(body:Object):IPayload{
       if( body is IPayload )return IPayload( body );
        else return new Payload( body );
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
		public function dispatchChanged( stateName:String ):void{
			_changed.dispatch( stateName );
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


		/**
		 * @inheritDoc
		 */
		public function setReferringAction( value:String ):void{
			_referringAction = value;
		}

		/**
		 * @inheritDoc
		 */
		public function setIsTransition( value:Boolean ):void{
			_isTransitioning = value;
		}

		/**
		 * @inheritDoc
		 */
		public function setTransitionPhase( value:ITransitionPhase ):void{
			_transitionPhase = value;
		}

        /**
		 * @inheritDoc
		 */
		public function get hasChangedListener():Boolean{
			return (_changed == null ) ? false : (_changed.numListeners > 0 );
		}


	}
}