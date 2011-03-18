package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;
import org.osflash.statemachine.core.IPayload;

public class Cancelled extends Signal {
		public function Cancelled(){
			super( String, IPayload );
		}
	}
}