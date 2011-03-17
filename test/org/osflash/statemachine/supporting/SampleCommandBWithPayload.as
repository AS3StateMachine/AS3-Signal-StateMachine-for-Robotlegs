package org.osflash.statemachine.supporting{

public class SampleCommandBWithPayload{
		
		[Inject]
		public var reporter:IPayloadReporter;

        [Inject]
		public var payload:Object;
		
		public function execute():void
		{
            reporter.reportPayload( payload );
		}
		
	}
}