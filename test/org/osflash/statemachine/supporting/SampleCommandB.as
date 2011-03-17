package org.osflash.statemachine.supporting{
public class SampleCommandB  {
		
		[Inject]
		public var reporter:ICommandReporter;
		

		public function execute():void
		{
			reporter.reportCommand(SampleCommandB);
		}
		
	}
}