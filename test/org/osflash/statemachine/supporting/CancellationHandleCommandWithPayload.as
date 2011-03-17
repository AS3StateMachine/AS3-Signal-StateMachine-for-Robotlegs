package org.osflash.statemachine.supporting{
public class CancellationHandleCommandWithPayload {

    [Inject]
    public var reporter:IPayloadReporter;

    [Inject]
    public var payload:Object;

    [Inject]
    public var reason:String;


    public function execute():void
    {
        reporter.reportPayload(payload);
        reporter.reportReason(reason);
    }
}
}