package org.osflash.statemachine {
import org.flexunit.Assert;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.logging.TraceLogger;
import org.osflash.statemachine.supporting.CancelTransitionCommand;
import org.osflash.statemachine.supporting.CancellationHandleCommand;
import org.osflash.statemachine.supporting.ICommandReporter;
import org.osflash.statemachine.supporting.SampleCommandA;
import org.osflash.statemachine.supporting.SampleCommandB;
import org.osflash.statemachine.supporting.SampleCommandC;
import org.osflash.statemachine.supporting.SampleCommandD;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.adapters.SwiftSuspendersReflector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;
import org.robotlegs.core.IReflector;

public class SignalStateMachineCommandExecutionTests implements ICommandReporter {


    private var injector:IInjector;
    private var reflector:IReflector;
    private var signalCommandMap:IGuardedSignalCommandMap;
    private var fsmInjector:SignalFSMInjector;
    private var reportedCommands:Array;


    [Before]
    public function before():void {
        reportedCommands = [];
        injector = new SwiftSuspendersInjector();
        injector.mapValue(ICommandReporter, this);
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
        reportedCommands = null;
    }


    [Test]
    public function FIRST_state_entered_signal_command_should_be_executed_in_correct_order():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [SampleCommandA];
        fsmController.action(TO_FIRST);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands])
    }



    [Test]
    public function SECOND_state_entered_signal_commands_should_be_executed_in_correct_order():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [SampleCommandA, SampleCommandB, SampleCommandC];
        fsmController.action(TO_SECOND);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands]);
    }

    [Test]
    public function THIRD_state_entered_signal_commands_should_be_executed_in_correct_order_but_only_once():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [SampleCommandA, SampleCommandB];
        fsmController.action(TO_THIRD);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands]);
    }

    [Test]
    public function All_FOURTH_state_signal_commands_should_be_mapped():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [SampleCommandA, SampleCommandB, SampleCommandC, SampleCommandD];
        fsmController.action(TO_FOURTH);
        fsmController.action(TO_EMPTY);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands]);
    }

    [Test]
    public function FIFTH_state_exitingGuard_and_cancellation_signal_commands_should_be_mapped():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [CancelTransitionCommand,CancellationHandleCommand];
        fsmController.action(TO_FIFTH);
        fsmController.action(TO_EMPTY);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands]);
    }

    public function reportCommand(commandClass:Class):void {
        reportedCommands.push(commandClass);
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
        fsmInjector.addClass(SampleCommandA);
        fsmInjector.addClass(SampleCommandB);
        fsmInjector.addClass(SampleCommandC);
        fsmInjector.addClass(CancelTransitionCommand);
        fsmInjector.addClass(CancellationHandleCommand);
        fsmInjector.addClass(SampleCommandD);

    }

    private static const STARTING:String = "starting";
    private static const FIRST:String = "first";
    private static const SECOND:String = "second";
    private static const THIRD:String = "third";
    private static const FOURTH:String = "fourth";
    private static const FIFTH:String = "fifth";
    private static const EMPTY:String = "empty";


    private static const TO_FIRST:String = "toFirst";
    private static const TO_SECOND:String = "toSecond";
    private static const TO_THIRD:String = "toThird";
    private static const TO_FOURTH:String = "toFourth";
    private static const TO_FIFTH:String = "toFifth";
    private static const TO_EMPTY:String = "toEmpty";


    private var FSM:XML =
            <fsm initial={STARTING}>
                <state  name={STARTING}>
                    <transition action={TO_FIRST} target={FIRST}/>
                    <transition action={TO_SECOND} target={SECOND}/>
                    <transition action={TO_THIRD} target={THIRD}/>
                    <transition action={TO_FOURTH} target={FOURTH}/>
                    <transition action={TO_FIFTH} target={FIFTH}/>
                </state>

                <state name={FIRST} >
                    <entered>
                        <commandClass classPath="SampleCommandA"/>
                    </entered>

                </state>

                <state name={SECOND} >
                    <entered>
                        <commandClass classPath="SampleCommandA"/>
                        <commandClass classPath="SampleCommandB"/>
                        <commandClass classPath="SampleCommandC"/>
                    </entered>
                </state>

                <state name={THIRD}>
                    <entered>
                        <commandClass classPath="SampleCommandA"/>
                        <commandClass classPath="SampleCommandB"/>
                        <!--<commandClass classPath="SampleCommandA"/> -->
                    </entered>
                </state>

                <state name={FOURTH}>
                    <enteringGuard>
                        <commandClass classPath="SampleCommandA"/>
                    </enteringGuard>
                    <entered>
                        <commandClass classPath="SampleCommandB"/>
                    </entered>
                    <exitingGuard>
                        <commandClass classPath="SampleCommandC"/>
                    </exitingGuard>
                    <tearDown>
                        <commandClass classPath="SampleCommandD"/>
                    </tearDown>
                    <transition action={TO_EMPTY} target={EMPTY}/>
                </state>

                <state name={FIFTH}>

                    <exitingGuard>
                        <commandClass classPath="CancelTransitionCommand"/>
                    </exitingGuard>
                    <cancelled>
                        <commandClass classPath="CancellationHandleCommand"/>
                    </cancelled>

                    <transition action={TO_EMPTY} target={EMPTY}/>
                </state>

                <state name={EMPTY}>


                </state>


            </fsm>
            ;


}
}
