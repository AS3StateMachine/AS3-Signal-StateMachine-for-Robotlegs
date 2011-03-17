package org.osflash.statemachine.supporting{
public class CancellationHandleCommand {

    [Inject]
    public var reporter:ICommandReporter;

    public function execute():void
    {
        reporter.reportCommand(CancellationHandleCommand);
    }
}
}