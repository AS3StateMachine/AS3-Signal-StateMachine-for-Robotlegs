package org.osflash.statemachine.supporting{

public class SampleCommandA{
		
		[Inject]
		public var reporter:ICommandReporter;
		
		public function execute():void
		{
			reporter.reportCommand(SampleCommandA);
		}
		
	}
}