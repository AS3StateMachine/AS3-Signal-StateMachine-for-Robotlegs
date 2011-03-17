package org.osflash.statemachine.supporting{

public class SampleCommandC {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		public function execute():void
		{
			reporter.reportCommand(SampleCommandC);
		}
	}
}