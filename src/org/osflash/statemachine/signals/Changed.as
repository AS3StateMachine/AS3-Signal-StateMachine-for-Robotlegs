package org.osflash.statemachine.signals
{
import org.osflash.signals.Signal;
import org.osflash.statemachine.core.IState;

public class Changed extends Signal
	{
		public function Changed()
		{
			super( IState );
		}
		
	}
}