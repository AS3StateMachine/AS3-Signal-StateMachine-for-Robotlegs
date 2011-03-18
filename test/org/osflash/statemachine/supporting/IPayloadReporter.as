package
org.osflash.statemachine.supporting {
import org.osflash.statemachine.core.IPayload;

public interface IPayloadReporter {



    function reportPayload(payload:IPayload):void;

    function reportReason(reason:String):void;
}

}

