package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;
import org.osflash.statemachine.core.IPayload;

public class ExitingGuard extends Signal {
		public function ExitingGuard(){
			super( IPayload );
		}
	}
}