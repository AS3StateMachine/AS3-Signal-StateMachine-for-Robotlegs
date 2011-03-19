package org.osflash.statemachine.supporting{

public class SampleCommandF {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		public function execute():void
		{
			reporter.reportCommand(SampleCommandF);
		}
	}
}