package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;
import org.osflash.statemachine.core.IPayload;

public class Entered extends Signal {
		public function Entered(){
			super( IPayload );
		}
	}
}