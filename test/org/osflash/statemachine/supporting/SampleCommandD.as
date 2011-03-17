package org.osflash.statemachine.supporting{

public class SampleCommandD {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		public function execute():void
		{
			reporter.reportCommand(SampleCommandD);
		}
	}
}