package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;

	public class Action extends Signal {
		public function Action(){
			super( String, Object );
		}
	}
}