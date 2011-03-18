package org.osflash.statemachine.supporting{
import org.osflash.statemachine.core.IPayload;

public class SampleCommandCWithPayload{
		
		[Inject]
		public var reporter:IPayloadReporter;

        [Inject]
		public var payload:IPayload;
		
		public function execute():void
		{
            reporter.reportPayload(payload);
		}
		
	}
}