package org.osflash.statemachine.supporting{
import org.osflash.statemachine.core.IPayload;

public class CancellationHandleCommandWithPayload {

    [Inject]
    public var reporter:IPayloadReporter;

    [Inject]
    public var payload:IPayload;

    [Inject]
    public var reason:String;


    public function execute():void
    {
        reporter.reportPayload(payload);
        reporter.reportReason(reason);
    }
}
}