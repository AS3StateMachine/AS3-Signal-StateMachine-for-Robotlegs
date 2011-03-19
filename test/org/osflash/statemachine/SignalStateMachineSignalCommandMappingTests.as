package org.osflash.statemachine {
import flexunit.framework.Assert;

import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.states.SignalState;
import org.osflash.statemachine.supporting.GrumpyGuard;
import org.osflash.statemachine.supporting.HappyGuard;
import org.osflash.statemachine.supporting.SampleCommandA;
import org.osflash.statemachine.supporting.SampleCommandB;
import org.osflash.statemachine.supporting.SampleCommandC;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.adapters.SwiftSuspendersReflector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;
import org.robotlegs.core.IReflector;

///////////////////////////////////////////////////////////////////////////
// Here were are testing that the commands are mapped to the correct
// signals independently of their execution
///////////////////////////////////////////////////////////////////////////
public class SignalStateMachineSignalCommandMappingTests {

    private var injector:IInjector;
    private var reflector:IReflector;
    private var signalCommandMap:IGuardedSignalCommandMap;
    private var fsmInjector:SignalFSMInjector;


    [Before]
    public function before():void {
        injector = new SwiftSuspendersInjector();
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

    }


    [Test]
    public function SECOND_state_entered_signal_should_be_instantiated():void {
        addClasses();
        injectFSM();
        var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
        Assert.assertTrue(state.hasEntered);
    }

    [Test(expected="org.osflash.statemachine.errors.StateDecodeError")]
     public function SampleCommandA_not_added_to_fsmInjector():void {
     injectFSM();
     }

     [Test]
     public function SECOND_state_enteringGuard_signal_should_not_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
     Assert.assertFalse(state.hasEnteringGuard);
     }

     [Test]
     public function SECOND_state_exitingGuard_signal_should_not_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
     Assert.assertFalse(state.hasExitingGuard);
     }

     [Test]
     public function SECOND_state_cancelled_signal_should_not_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
     Assert.assertFalse(state.hasCancelled);
     }

     [Test]
     public function SECOND_state_tearDown_signal_should_not_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
     Assert.assertFalse(state.hasTearDown);
     }

     [Test]
     public function THIRD_state_entered_signal_should_not_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, THIRD) as SignalState;
     Assert.assertFalse(state.hasEntered);
     }

     [Test]
     public function THIRD_state_enteringGuard_signal_should_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, THIRD) as SignalState;
     Assert.assertTrue(state.hasEnteringGuard);
     }

     [Test]
     public function THIRD_state_exitingGuard_signal_should_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, THIRD) as SignalState;
     Assert.assertTrue(state.hasExitingGuard);
     }

     [Test]
     public function THIRD_state_tearDown_signal_should_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, THIRD) as SignalState;
     Assert.assertTrue(state.hasTearDown);
     }

     [Test]
     public function THIRD_state_cancelled_signal_should_be_instantiated():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, THIRD) as SignalState;
     Assert.assertTrue(state.hasCancelled);
     }

     [Test(expected="org.osflash.statemachine.errors.StateDecodeError")]
     public function Guards_not_added_to_fsmInjector():void {
     fsmInjector.addClass(SampleCommandA);
     fsmInjector.addClass(SampleCommandB);
     fsmInjector.addClass(SampleCommandC);
     injectFSM();

     }

     [Test]
     public function SampleCommandA_and_B_should_be_mapped_to_entered_signal_in_FOURTH_state():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, FOURTH) as SignalState;
     Assert.assertTrue(signalCommandMap.hasSignalCommand(state.entered, SampleCommandA));
     Assert.assertTrue(signalCommandMap.hasSignalCommand(state.entered, SampleCommandB));
     }

     [Test]
     public function SampleCommandB_should_be_mapped_to_enteringGuard_signal_in_THIRD_state():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, THIRD) as SignalState;
     Assert.assertTrue(signalCommandMap.hasSignalCommand(state.enteringGuard, SampleCommandB));
     }

     [Test]
     public function SampleCommandC_should_be_mapped_to_exitingGuard_signal_in_THIRD_state():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, THIRD) as SignalState;
     Assert.assertTrue(signalCommandMap.hasSignalCommand(state.exitingGuard, SampleCommandC));
     }

     [Test]
     public function SampleCommandA_and_B_should_be_mapped_to_tearDown_signal_in_THIRD_state():void {
     addClasses();
     injectFSM();
     var state:SignalState = injector.getInstance(ISignalState, THIRD) as SignalState;
     Assert.assertTrue(signalCommandMap.hasSignalCommand(state.tearDown, SampleCommandA));
     Assert.assertTrue(signalCommandMap.hasSignalCommand(state.tearDown, SampleCommandB));
     }

    public function injectFSM():void {
        fsmInjector.inject();
        fsmInjector.destroy();
    }

    private function addClasses():void {
        fsmInjector.addClass(SampleCommandA);
        fsmInjector.addClass(SampleCommandB);
        fsmInjector.addClass(SampleCommandC);
        fsmInjector.addClass(GrumpyGuard);
        fsmInjector.addClass(HappyGuard);
    }

    private static const STARTING:String = "starting";
    private static const SECOND:String = "second";
    private static const THIRD:String = "third";
    private static const FOURTH:String = "fourth";


    private static const NEXT:String = "next";


    private var FSM:XML =
            <fsm initial={STARTING}>
                <state  name={STARTING}>
                    <transition action={NEXT} target={SECOND}/>
                </state>

                <state name={SECOND} inject="true">
                    <entered>
                        <commandClass classPath="SampleCommandA"/>
                    </entered>
                >
                    <transition action={NEXT} target={THIRD}/>
                </state>

                <state name={THIRD} inject="true">
                    <enteringGuard>
                        <commandClass classPath="SampleCommandB"/>
                    </enteringGuard>
                    <exitingGuard>
                        <commandClass classPath="SampleCommandC"/>
                    </exitingGuard>
                    <cancelled>
                        <commandClass classPath="SampleCommandA"/>
                    </cancelled>
                    <tearDown>
                        <commandClass classPath="SampleCommandA"/>
                        <commandClass classPath="SampleCommandB"/>
                    </tearDown>
                    <transition action={NEXT} target={THIRD}/>
                </state>

                     <state name={FOURTH} inject="true">
                    <entered>
                        <commandClass classPath="SampleCommandA" />
                        <commandClass classPath="SampleCommandB" >
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="GrumpyGuard" />
                        </commandClass>
                        <commandClass classPath="SampleCommandC" >
                            <guardClass classPath="HappyGuard" />
                        </commandClass>
                    </entered>
                    <transition action={NEXT} target={THIRD}/>
                </state>


            </fsm>
            ;
}
}
