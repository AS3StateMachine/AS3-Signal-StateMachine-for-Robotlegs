package org.osflash.statemachine.signals {
	import org.osflash.signals.Signal;
import org.osflash.statemachine.core.IPayload;

public class Action extends Signal {
		public function Action(){
			super( String, IPayload );
		}
	}
}