package org.osflash.statemachine.supporting.mocks {
	import org.osflash.statemachine.core.ITransitionController;
	import org.osflash.statemachine.transitioning.SignalTransitionController;

	public class MockTransitionListener {

		public static const CANCELLATION_REASON:String = "reason/test";

		public static const CANCELLED_PAYLOAD:Object = {};



		public var hasListenerBeenCalled:Boolean;
		public var parameterTest:Boolean;
		public var isTransitioning:Boolean;

		private var payload:Object;
		private var info:String;
		private var controller:ITransitionController;

		public function MockTransitionListener( payload:Object, controller:ITransitionController, info:String = null ){
			this.payload = payload;
			this.info = info;
			this.controller = controller;
		}

		public function listenerStringObject( info:String, payload:Object ):void{
			hasListenerBeenCalled = true;
			parameterTest = ( this.info == info && this.payload === payload );
			isTransitioning = controller.isTransitioning;
		}

		public function listenerString( info:String ):void{
			hasListenerBeenCalled = true;
			parameterTest = ( this.info == info );
			isTransitioning = controller.isTransitioning;
		}

		public function listenerObject( payload:Object ):void{
			hasListenerBeenCalled = true;
			parameterTest = ( this.payload == payload );
			isTransitioning = controller.isTransitioning;

		}

		public function listenerCancel( payload:Object ):void{
			SignalTransitionController( controller ).fsmController.cancel( CANCELLATION_REASON, CANCELLED_PAYLOAD );
		}

		public function listenerNone():void{
			hasListenerBeenCalled = true;
			parameterTest = true;
			isTransitioning = controller.isTransitioning;
		}

		public function reset():void{
			parameterTest = false;
			hasListenerBeenCalled = false;
			isTransitioning = false;
		}
	}
}