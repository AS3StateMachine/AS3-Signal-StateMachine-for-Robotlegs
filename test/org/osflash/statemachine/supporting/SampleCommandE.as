package org.osflash.statemachine.supporting{

public class SampleCommandE {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		public function execute():void
		{
			reporter.reportCommand(SampleCommandE);
		}
	}
}