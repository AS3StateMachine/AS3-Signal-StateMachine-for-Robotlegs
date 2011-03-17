package org.osflash.statemachine.supporting{
import org.osflash.statemachine.core.IFSMController;

public class CancelTransitionCommand {

    public static const REASON:String = "because";
    public static const PAYLOAD:Object = {};

    [Inject]
    public var reporter:ICommandReporter;
    [Inject]
    public var fsmController:IFSMController;

    public function execute():void
    {
        reporter.reportCommand(CancelTransitionCommand);
        fsmController.cancel(REASON, PAYLOAD);

    }
}
}