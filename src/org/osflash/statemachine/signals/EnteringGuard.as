package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;
import org.osflash.statemachine.core.IPayload;

public class EnteringGuard extends Signal {
		public function EnteringGuard(){
			super( IPayload );
		}
	}
}