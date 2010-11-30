package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;

	public class Cancelled extends Signal {
		public function Cancelled(){
			super( String, Object );
		}
	}
}