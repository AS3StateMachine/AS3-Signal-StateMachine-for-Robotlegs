package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;
import org.osflash.statemachine.core.IPayload;

public class Cancel extends Signal {
		public function Cancel(){
			super( String, IPayload );
		}
	}
}