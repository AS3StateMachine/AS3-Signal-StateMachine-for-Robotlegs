package org.osflash.statemachine.supporting {
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IPayload;

public class CancelTransitionCommandWithPayload {

    public static const REASON:String = "because";

    [Inject]
    public var reporter:IPayloadReporter;


    [Inject]
    public var payload:IPayload;

    [Inject]
    public var fsmController:IFSMController;

    public function execute():void {
        reporter.reportPayload(payload);
        fsmController.cancel(REASON, payload);

    }
}
}