package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;

	public class Cancel extends Signal {
		public function Cancel(){
			super( String, Object );
		}
	}
}