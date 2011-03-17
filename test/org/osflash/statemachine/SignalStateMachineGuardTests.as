package org.osflash.statemachine {
import org.flexunit.Assert;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.logging.TraceLogger;
import org.osflash.statemachine.supporting.CancelTransitionCommand;
import org.osflash.statemachine.supporting.CancellationHandleCommand;
import org.osflash.statemachine.supporting.GrumpyGuard;
import org.osflash.statemachine.supporting.HappyGuard;
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

///////////////////////////////////////////////////////////////////////////
// Here were are testing that the guards are mapped to the correct signals
// we do not need to test their functionality, as the
// GuardedSignalCommandMapTest already do that.
///////////////////////////////////////////////////////////////////////////
public class SignalStateMachineGuardTests implements ICommandReporter {


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

        fsmInjector.initiate(FSM);
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
    ///////////////////////////////////////////////////////////////////////////
    // We are testing various combinations of no, single and multiple guards
    // all of which succeed
    ///////////////////////////////////////////////////////////////////////////
    public function FIRST_state_entered_commands_should_all_be_executed():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [SampleCommandA,SampleCommandB,SampleCommandC,SampleCommandD];
        fsmController.action(TO_FIRST);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands])
    }

    [Test]
    ///////////////////////////////////////////////////////////////////////////
    // We are testing various combinations of no, single and multiple guards
    // all of which fail
    ///////////////////////////////////////////////////////////////////////////
    public function SECOND_state_entered_commands_should_not_be_executed():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [];
        fsmController.action(TO_SECOND);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands])
    }

    [Test]
    ///////////////////////////////////////////////////////////////////////////
    // We are testing various combinations of no, single and multiple guards
    // two of which succeed, two fail
    ///////////////////////////////////////////////////////////////////////////
    public function THIRD_state_entered_commands_two_are_executed_two_are_not():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [SampleCommandA,SampleCommandC];
        fsmController.action(TO_THIRD);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands])
    }


    [Test]
    ///////////////////////////////////////////////////////////////////////////
    // We are testing that all the phase signals are working for a straight
    // transition. Each phase has two commands, one will succeed, the other, fail
    ///////////////////////////////////////////////////////////////////////////
    public function FOURTH_state_all_phase_signal_commands_should_be_executed_according_to_guards():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [SampleCommandB,SampleCommandC,SampleCommandA,SampleCommandD];
        fsmController.action(TO_FOURTH);
        fsmController.action(TO_EMPTY);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands])
    }

    [Test]
    ///////////////////////////////////////////////////////////////////////////
    // We are testing that the phase signal is working for the cancelled
    // phase signal. the CancellationHandleCommand should be executed
    ///////////////////////////////////////////////////////////////////////////
    public function FIFTH_state_cancelled_signal_command_executed():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [CancelTransitionCommand, CancellationHandleCommand];
        fsmController.action(TO_FIFTH);
        fsmController.action(TO_EMPTY);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands])
    }

    [Test]
    ///////////////////////////////////////////////////////////////////////////
    // We are testing that the phase signal is working for the cancelled
    // phase signal. the CancellationHandleCommand should not be executed
    ///////////////////////////////////////////////////////////////////////////
    public function SIXTH_state_cancelled_signal_command_not_executed():void {
        addClasses();
        injectFSM();
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var expected:Array = [CancelTransitionCommand];
        fsmController.action(TO_SIXTH);
        fsmController.action(TO_EMPTY);
        Assert.assertWithApply(assertArraysEqual, [expected, reportedCommands])
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
        fsmInjector.addClass(GrumpyGuard);
        fsmInjector.addClass(HappyGuard);

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
                        <commandClass classPath="SampleCommandA" >
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandB" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandC" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandD" >
                        </commandClass>
                    </entered>
                </state>

                <state name={SECOND} >
                    <entered>
                        <commandClass classPath="SampleCommandA" >
                            <guardClass classPath="GrumpyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandB" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="GrumpyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandC" >
                            <guardClass classPath="GrumpyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandD" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="GrumpyGuard" />
                        </commandClass>
                    </entered>
                </state>

                <state name={THIRD} >
                    <entered>
                        <commandClass classPath="SampleCommandA" >
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandB" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="GrumpyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandC" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandD" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="GrumpyGuard" />
                        </commandClass>

                    </entered>
                </state>

                <state name={FOURTH} >
                    <enteringGuard>
                        <commandClass classPath="SampleCommandA" >
                            <guardClass classPath="GrumpyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandB" >
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                    </enteringGuard>
                    <entered>
                        <commandClass classPath="SampleCommandC" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandD" >
                            <guardClass classPath="GrumpyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                    </entered>
                    <exitingGuard>
                        <commandClass classPath="SampleCommandA" >
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandB" >
                            <guardClass classPath="GrumpyGuard" />
                        </commandClass>
                    </exitingGuard>
                    <tearDown>
                        <commandClass classPath="SampleCommandC" >
                            <guardClass classPath="GrumpyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandD" >
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                    </tearDown>
                    <transition action={TO_EMPTY} target={EMPTY}/>
                </state>

                <state name={FIFTH}>
                    <exitingGuard>
                        <commandClass classPath="CancelTransitionCommand"/>
                    </exitingGuard>
                    <cancelled>
                        <commandClass classPath="CancellationHandleCommand">
                            <guardClass classPath="HappyGuard"/>
                        </commandClass>
                    </cancelled>
                    <transition action={TO_EMPTY} target={EMPTY}/>
                </state>

                <state name={SIXTH}>
                    <exitingGuard>
                        <commandClass classPath="CancelTransitionCommand"/>
                    </exitingGuard>
                    <cancelled>
                        <commandClass classPath="CancellationHandleCommand">
                            <guardClass classPath="GrumpyGuard"/>
                        </commandClass>
                    </cancelled>
                    <transition action={TO_EMPTY} target={EMPTY}/>
                </state>

                <state name={EMPTY}/>

            </fsm>
            ;


}
}
