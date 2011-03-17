package org.osflash.statemachine {
import org.flexunit.Assert;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.logging.TraceLogger;
import org.osflash.statemachine.supporting.CancelTransitionCommandWithPayload;
import org.osflash.statemachine.supporting.CancellationHandleCommandWithPayload;
import org.osflash.statemachine.supporting.IPayloadReporter;
import org.osflash.statemachine.supporting.SampleCommandAWithPayload;
import org.osflash.statemachine.supporting.SampleCommandBWithPayload;
import org.osflash.statemachine.supporting.SampleCommandCWithPayload;
import org.osflash.statemachine.supporting.SampleCommandDWithPayload;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.adapters.SwiftSuspendersReflector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;
import org.robotlegs.core.IReflector;

///////////////////////////////////////////////////////////////////////////
// Here were are testing the injection of values from the phase signals
// in to the commands
///////////////////////////////////////////////////////////////////////////
public class SignalStateMachineCommandPayLoadInjectionTests implements IPayloadReporter {


    private var injector:IInjector;
    private var reflector:IReflector;
    private var signalCommandMap:IGuardedSignalCommandMap;
    private var fsmInjector:SignalFSMInjector;
    private var reportedPayloads:Array;
    private var reason:String;

    [Before]
    public function before():void {
        reportedPayloads = [];
        injector = new SwiftSuspendersInjector();
        injector.mapValue(IPayloadReporter, this);
        reflector = new SwiftSuspendersReflector();
        signalCommandMap = new GuardedSignalCommandMap(injector);
        fsmInjector = new SignalFSMInjector(injector, signalCommandMap);

        fsmInjector.initiate(FSM, new TraceLogger());
    }

    [After]
    public function after():void {
        injector = null;
        reflector = null;
        signalCommandMap = null;
        fsmInjector = null;
        reportedPayloads = null;
        reason = null;
    }


    [Test]
    ///////////////////////////////////////////////////////////////////////////
    // Here were are testing the injection of values from the entered phase
    // signal into a single command
    ///////////////////////////////////////////////////////////////////////////
    public function FIRST_state_entered_command_payload_should_be_injected_into_single_command():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var payload:Object = {};
        var expected:Array = [payload];
        fsmController.action(TO_FIRST, payload);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedPayloads])
    }

    [Test]
    ///////////////////////////////////////////////////////////////////////////
    // Here were are testing the injection of values from the entered phase
    // signal into multiple commands
    ///////////////////////////////////////////////////////////////////////////
    public function SECOND_state_entered_command_payload_should_be_injected_into_multiple_commands():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var payload:Object = {};
        var expected:Array = [payload,payload,payload];
        fsmController.action(TO_SECOND, payload);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedPayloads])
    }

    [Test]
    ///////////////////////////////////////////////////////////////////////////
    // Here were are testing the injection of values from the phase signals
    // of a straight transition. Note that the tearDown phase has no
    // injections, so we are not testing it here (see InjectionError below)
    ///////////////////////////////////////////////////////////////////////////
    public function all_FOURTH_state_command_payloads_should_be_injected_tearDown_has_no_injections():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var payloadOne:Object = {id:"payloadOne"};
        var payloadTwo:Object = {id:"payloadTwo"};
        var expected:Array = [payloadOne,payloadOne,payloadTwo];
        fsmController.action(TO_FOURTH, payloadOne);
        fsmController.action(TO_EMPTY, payloadTwo);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedPayloads])
    }

    [Test]
     ///////////////////////////////////////////////////////////////////////////
    // Here were are testing the injection of values from the phase signals
    // of a cancelled transition.
    ///////////////////////////////////////////////////////////////////////////
    public function FIFTH_state_command_payloads_should_be_injected():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var payload:Object = {};
        var expected:Array = [payload,payload];
        fsmController.action(TO_FIFTH);
        fsmController.action(TO_EMPTY, payload);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedPayloads]);
        Assert.assertEquals(CancelTransitionCommandWithPayload.REASON, reason);
    }

    [Test(expected="org.swiftsuspenders.InjectorError")]
    ///////////////////////////////////////////////////////////////////////////
    // Here were are testing that attempted injection of values from a tearDown
    // phase signal throws an injection error
    ///////////////////////////////////////////////////////////////////////////
    public function tearDown_has_no_payloads():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var payload:Object = {};
        fsmController.action(TO_SIXTH);
        fsmController.action(TO_EMPTY, payload);
    }

    public function reportPayload(payload:Object):void {
        reportedPayloads.push(payload)
    }

    public function reportReason(reason:String):void {
        this.reason = reason;
    }

    public function assertArraysEqual(expected:Array, got:Array):void {
        Assert.assertEquals(expected.length, got.length);
        if (expected.length != got.length)return;
        for (var i:int = 0; i < expected.length; i++) {
            Assert.assertStrictlyEquals(expected[i], got[i]);
        }
    }

    public function injectFSM():void {
        fsmInjector.inject();
        fsmInjector.destroy();
    }

    private function addClasses():void {
        fsmInjector.addClass(SampleCommandAWithPayload);
        fsmInjector.addClass(SampleCommandBWithPayload);
        fsmInjector.addClass(SampleCommandCWithPayload);
        fsmInjector.addClass(SampleCommandDWithPayload);
        fsmInjector.addClass(CancelTransitionCommandWithPayload);
        fsmInjector.addClass(CancellationHandleCommandWithPayload);
    }

    private static const STARTING:String = "starting";
    private static const FIRST:String = "first";
    private static const SECOND:String = "second";
    private static const THIRD:String = "third";
    private static const FOURTH:String = "fourth";
    private static const FIFTH:String = "fifth";
    private static const SIXTH:String = "sixth";
    private static const EMPTY:String = "empty";

    private static const TO_FIRST:String = "toFirst";
    private static const TO_SECOND:String = "toSecond";
    private static const TO_THIRD:String = "toThird";
    private static const TO_FOURTH:String = "toFourth";
    private static const TO_FIFTH:String = "toFifth";
    private static const TO_SIXTH:String = "toSixth";
    private static const TO_EMPTY:String = "toEmpty";


    private var FSM:XML =
            <fsm initial={STARTING}>
                <state  name={STARTING}>
                    <transition action={TO_FIRST} target={FIRST}/>
                    <transition action={TO_SECOND} target={SECOND}/>
                    <transition action={TO_THIRD} target={THIRD}/>
                    <transition action={TO_FOURTH} target={FOURTH}/>
                    <transition action={TO_FIFTH} target={FIFTH}/>
                    <transition action={TO_SIXTH} target={SIXTH}/>
                </state>

                <state name={FIRST} >
                    <entered>
                        <commandClass classPath="SampleCommandAWithPayload"/>
                    </entered>

                </state>

                <state name={SECOND} >
                    <entered>
                        <commandClass classPath="SampleCommandAWithPayload"/>
                        <commandClass classPath="SampleCommandBWithPayload"/>
                        <commandClass classPath="SampleCommandCWithPayload"/>
                    </entered>
                </state>

                <state name={FOURTH}>
                    <enteringGuard>
                        <commandClass classPath="SampleCommandAWithPayload"/>
                    </enteringGuard>
                    <entered>
                        <commandClass classPath="SampleCommandBWithPayload"/>
                    </entered>
                    <exitingGuard>
                        <commandClass classPath="SampleCommandCWithPayload"/>
                    </exitingGuard>
                    <transition action={TO_EMPTY} target={EMPTY}/>
                </state>

                <state name={SIXTH}>
                    <tearDown>
                        <commandClass classPath="SampleCommandDWithPayload"/>
                    </tearDown>
                    <transition action={TO_EMPTY} target={EMPTY}/>
                </state>

                <state name={FIFTH}>

                    <exitingGuard>
                        <commandClass classPath="CancelTransitionCommandWithPayload"/>
                    </exitingGuard>
                    <cancelled>
                        <commandClass classPath="CancellationHandleCommandWithPayload"/>
                    </cancelled>

                    <transition action={TO_EMPTY} target={EMPTY}/>
                </state>

                <state name={EMPTY}>


                </state>


            </fsm>
            ;


}
}
