package org.osflash.statemachine {
import org.flexunit.Assert

import org.osflash.signals.ISignal;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.states.SignalState;
import org.osflash.statemachine.transitioning.TransitionPhase;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.adapters.SwiftSuspendersReflector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;
import org.robotlegs.core.IReflector;

///////////////////////////////////////////////////////////////////////////
// Here were are testing the behaviour of the StateMachine without any
// mapping of commands
///////////////////////////////////////////////////////////////////////////
public class SignalStateMachineBasicTests {

    private var injector:IInjector;
    private var reflector:IReflector;
    private var signalCommandMap:IGuardedSignalCommandMap;
    private var fsmInjector:SignalFSMInjector;

    public function setup(fsm:XML):void {
        injector = new SwiftSuspendersInjector();
        reflector = new SwiftSuspendersReflector();
        signalCommandMap = new GuardedSignalCommandMap(injector);
        fsmInjector = new SignalFSMInjector(injector, signalCommandMap);
        fsmInjector.initiate(fsm);
        fsmInjector.inject();
        fsmInjector.destroy();

    }

    [After]
    public function after():void {
        injector = null;
        reflector = null;
        signalCommandMap = null;
        fsmInjector = null;
    }


    [Test]
    public function fsmController_is_mapped():void {
        setup(FSM);
        Assert.assertTrue(injector.hasMapping(IFSMController));
    }

    [Test]
    public function fsm_is_initialised():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        Assert.assertEquals(STARTING, fsmController.currentStateName);
    }

    [Test]
    public function STARTING_state_should_not_be_injected():void {
        setup(FSM);
        Assert.assertFalse(injector.hasMapping(ISignalState, STARTING));
    }

    [Test]
    public function SECOND_and_THIRD_state_should_be_injected():void {
        setup(FSM);
        Assert.assertTrue("SECOND state should be injected", injector.hasMapping(ISignalState, SECOND));
        Assert.assertTrue("THIRD state should be injected", injector.hasMapping(ISignalState, THIRD));
    }

    [Test(expected="org.osflash.statemachine.errors.StateDecodeError")]
    public function initial_state_undefined_in_xml_currentState_is_null():void {
        setup(TESTING_UNDEFINED_INITIAL_VALUE_FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        Assert.assertNull( fsmController.currentStateName);
    }

    [Test(expected="org.osflash.statemachine.errors.StateDecodeError")]
    public function initial_state_refers_to_a_state_that_is_undefined():void {
        setup(TESTING_INITIAL_VALUE_IS_UNDEFINED_STATE_FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        Assert.assertNull( fsmController.currentStateName);
    }

    [Test]
    public function SECOND_state_should_lazily_instantiate_cancellation_signal():void {
        setup(FSM);
        var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
        Assert.assertFalse(state.hasCancelled);
        var signal:ISignal = state.cancelled;
        Assert.assertTrue(state.hasCancelled);
    }

    [Test]
    public function SECOND_state_should_lazily_instantiate_entered_signal():void {
        setup(FSM);
        var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
        Assert.assertFalse(state.hasEntered);
        var signal:ISignal = state.entered;
        Assert.assertTrue(state.hasEntered);
    }

    [Test]
    public function SECOND_state_should_lazily_instantiate_enteringGuard_signal():void {
        setup(FSM);
        var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
        Assert.assertFalse(state.hasEnteringGuard);
        var signal:ISignal = state.enteringGuard;
        Assert.assertTrue(state.hasEnteringGuard);
    }

    [Test]
    public function SECOND_state_should_lazily_instantiate_exitingGuard_signal():void {
        setup(FSM);
        var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
        Assert.assertFalse(state.hasExitingGuard);
        var signal:ISignal = state.exitingGuard;
        Assert.assertTrue(state.hasExitingGuard);
    }

    [Test]
    public function SECOND_state_should_lazily_instantiate_tearDown_signal():void {
        setup(FSM);
        var state:SignalState = injector.getInstance(ISignalState, SECOND) as SignalState;
        Assert.assertFalse(state.hasTearDown);
        var signal:ISignal = state.tearDown;
        Assert.assertTrue(state.hasTearDown);
    }


    [Test]
    public function advance_to_next_state():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        fsmController.action(NEXT);   // to SECOND
        Assert.assertEquals(SECOND, fsmController.currentStateName);
    }

    [Test]
    public function advance_to_SECOND_state_with_payload_testing_SECOND_onEntered_arguments():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var transitionPayload:Object = {};
        var wasOnEnteredCalled:Boolean;
        var onEntered:Function = function (payload:IPayload):void {
            Assert.assertStrictlyEquals(transitionPayload, payload.body);
            wasOnEnteredCalled = true;
        };
        state.entered.addOnce(onEntered);
        fsmController.action(NEXT, transitionPayload);     // to SECOND
        Assert.assertTrue(wasOnEnteredCalled);

    }

    [Test]
    public function advance_to_SECOND_state_with_payload_testing_SECOND_enteringGuard_arguments():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var transitionPayload:Object = {};
        var wasOnEnteringGuardCalled:Boolean;
        var onEnteringGuard:Function = function (payload:IPayload):void {
            Assert.assertStrictlyEquals(transitionPayload, payload.body);
            wasOnEnteringGuardCalled = true;
        };
        state.enteringGuard.addOnce(onEnteringGuard);

        fsmController.action(NEXT, transitionPayload);  // toSECOND

        Assert.assertTrue(wasOnEnteringGuardCalled);

    }

    [Test]
    public function advance_to_THIRD_state_with_payload_testing_SECOND_exitingGuard_arguments():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var transitionPayload:Object = {};
        var wasOnExitingGuardCalled:Boolean;
        var onEnteringGuard:Function = function (payload:Object):void {
            Assert.assertStrictlyEquals(transitionPayload, payload.body);
            wasOnExitingGuardCalled = true;
        };
        state.exitingGuard.addOnce(onEnteringGuard);

        fsmController.action(NEXT, transitionPayload); // to SECOND
        fsmController.action(NEXT, transitionPayload); // to THIRD

        Assert.assertTrue(wasOnExitingGuardCalled);

    }

    [Test]
    public function cancel_transition_from_SECOND_state_exitingGuard_testing_SECOND_cancellation_arguments():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var cancellationReason:String = "testingReason";
        var cancellationPayload:Object = {};
        var wasOnCancellationCalled:Boolean;

        var onExitingGuard:Function = function (payload:Object):void {
            fsmController.cancel(cancellationReason, cancellationPayload);
        };
        state.exitingGuard.addOnce(onExitingGuard);

        var onCancellation:Function = function (reason:String, payload:IPayload):void {
            Assert.assertEquals(cancellationReason, reason);
            Assert.assertStrictlyEquals(cancellationPayload, payload.body);
            wasOnCancellationCalled = true;
        };
        state.cancelled.addOnce(onCancellation);

        fsmController.action(NEXT);  // to SECOND
        fsmController.action(NEXT);  // to THIRD

        Assert.assertTrue(wasOnCancellationCalled);


    }

    [Test]
    public function cancel_transition_from_THIRD_state_enteringGuard_testing_SECOND_cancellation_arguments():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var secondState:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var thirdState:ISignalState = injector.getInstance(ISignalState, THIRD) as ISignalState;
        var cancellationReason:String = "testingReason";
        var cancellationPayload:Object = {};
        var wasOnCancellationCalled:Boolean;

        var onEnteringGuard:Function = function (payload:Object):void {
            fsmController.cancel(cancellationReason, cancellationPayload);
        };
        thirdState.enteringGuard.addOnce(onEnteringGuard);

        var onCancellation:Function = function (reason:String, payload:IPayload):void {
            Assert.assertEquals(cancellationReason, reason);
            Assert.assertStrictlyEquals(cancellationPayload, payload.body);
            wasOnCancellationCalled = true;
        };
        secondState.cancelled.addOnce(onCancellation);

        fsmController.action(NEXT);  // to SECOND
        fsmController.action(NEXT);  // to THIRD

        Assert.assertTrue(wasOnCancellationCalled);


    }


    [Test]
    public function advance_with_non_declared_transition():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        fsmController.action(NON_DECLARED_TRANSITION);
        Assert.assertEquals(STARTING, fsmController.currentStateName);
    }

    [Test(expected="org.osflash.statemachine.errors.StateTransitionError")]
    public function advance_to_non_declared_target_state():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        fsmController.action(TO_NON_DECLARED_TARGET);

    }

    [Test]
    public function cancel_transition_from_SECOND_state_exitingGuard():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var onExitingGuard:Function = function (payload:IPayload):void {
            fsmController.cancel("testing");
        };
        state.exitingGuard.addOnce(onExitingGuard);

        fsmController.action(NEXT);  // to SECOND
        fsmController.action(NEXT);  // to THIRD

        Assert.assertEquals(SECOND, fsmController.currentStateName);


    }

    [Test]
    public function cancel_transition_from_THIRD_state_enteringGuard():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, THIRD) as ISignalState;
        var onEnteringGuard:Function = function (payload:IPayload):void {
            fsmController.cancel("testing");
        };
        state.enteringGuard.addOnce(onEnteringGuard);

        fsmController.action(NEXT);  // to SECOND
        fsmController.action(NEXT);  // to THIRD

        Assert.assertEquals(SECOND, fsmController.currentStateName);

    }

    [Test(expected="org.osflash.statemachine.errors.StateTransitionError")]
    public function cancel_transition_from_SECOND_state_tearDown():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var onTearDown:Function = function ():void {
            fsmController.cancel("testing");
        };
        state.tearDown.addOnce(onTearDown);

        fsmController.action(NEXT);  // to SECOND
        fsmController.action(NEXT);  // to THIRD

    }

    [Test(expected="org.osflash.statemachine.errors.StateTransitionError")]
    public function cancel_transition_from_THIRD_state_entered():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, THIRD) as ISignalState;
        var onEntered:Function = function (payload:IPayload):void {
            fsmController.cancel("testing");
        };
        state.entered.addOnce(onEntered);

        fsmController.action(NEXT);  // to SECOND
        fsmController.action(NEXT);  // to THIRD

    }

    [Test(expected="org.osflash.statemachine.errors.StateTransitionError")]
    public function cancel_transition_from_SECOND_state_cancelled():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var onExitingGuard:Function = function (payload:Object):void {
            fsmController.cancel("testing");
        };
        var onCancelled:Function = function (reason:String, payload:IPayload):void {
            fsmController.cancel("testing");
        };
        state.exitingGuard.addOnce(onExitingGuard);
        state.cancelled.addOnce(onCancelled);

        fsmController.action(NEXT);  // to SECOND
        fsmController.action(NEXT);  // to THIRD

    }

    [Test]
    public function invoke_transition_from_SECOND_state_entered():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var onEntered:Function = function (payload:IPayload):void {
            fsmController.action(NEXT);    // to THIRD
        };
        state.entered.addOnce(onEntered);
        fsmController.action(NEXT);   // to SECOND

        Assert.assertEquals(THIRD, fsmController.currentStateName);
    }

    [Test(expected="org.osflash.statemachine.errors.StateTransitionError")]
    public function invoke_transition_from_SECOND_state_enteringGuard():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var onEnteringGuard:Function = function (payload:IPayload):void {
            fsmController.action(NEXT);     // to THIRD
        };
        state.enteringGuard.addOnce(onEnteringGuard);
        fsmController.action(NEXT);     // to SECOND

    }

    [Test(expected="org.osflash.statemachine.errors.StateTransitionError")]
    public function invoke_transition_from_SECOND_state_exitingGuard():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var onExitingGuard:Function = function (payload:IPayload):void {
            fsmController.action(NEXT);
        };
        state.enteringGuard.addOnce(onExitingGuard);
        fsmController.action(NEXT);    // to SECOND
        fsmController.action(NEXT);     // to THIRD

    }

    [Test(expected="org.osflash.statemachine.errors.StateTransitionError")]
    public function invoke_transition_from_SECOND_state_tearDown():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var onTearDown:Function = function ():void {
            fsmController.action(NEXT);
        };
        state.tearDown.addOnce(onTearDown);
        fsmController.action(NEXT);    // to SECOND
        fsmController.action(NEXT);    // to THIRD

    }

    [Test]
    public function invoke_transition_from_SECOND_state_cancelled():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var state:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;

        var onExitingGuard:Function = function (payload:IPayload):void {
            fsmController.cancel("testing");
        };
        state.exitingGuard.addOnce(onExitingGuard);

        var onCancelled:Function = function (reason:String, payload:IPayload):void {
            fsmController.action(NEXT); // to THIRD
        };
        state.cancelled.addOnce(onCancelled);

        fsmController.action(NEXT); // to SECOND
        fsmController.action(NEXT); // to THIRD (but cancelled)

        Assert.assertEquals(THIRD, fsmController.currentStateName);

    }

    [Test]
    public function generic_changed_phase_is_called_once_only():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var wasOnChangedCalled:Boolean;
        var onChanged:Function = function (stateName:String):void {
            wasOnChangedCalled = true;
        };
        fsmController.addChangedListenerOnce(onChanged);

        fsmController.action(NEXT); // to SECOND
        Assert.assertTrue(wasOnChangedCalled);
        wasOnChangedCalled = false;

        fsmController.action(NEXT); // to SECOND
        Assert.assertFalse(wasOnChangedCalled);
    }

    [Test]
    public function generic_changed_phase_is_called_multiple_times():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var wasOnChangedCalled:Boolean;

        var onChanged:Function = function (stateName:String):void {
            wasOnChangedCalled = true;
        };
        fsmController.addChangedListener(onChanged);

        fsmController.action(NEXT); // to SECOND
        Assert.assertTrue(wasOnChangedCalled);
        wasOnChangedCalled = false;

        fsmController.action(NEXT); // to THIRD
        Assert.assertTrue(wasOnChangedCalled);
    }

    [Test]
    public function generic_changed_phase_is_called_testing_argument():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var onChangedArgument:String;
        var onChanged:Function = function (stateName:String):void {
            onChangedArgument = stateName;
        };
        fsmController.addChangedListener(onChanged);

        fsmController.action(NEXT); // to SECOND
        Assert.assertEquals(SECOND, onChangedArgument);
        onChangedArgument = null;

        fsmController.action(NEXT); // to THIRD
        Assert.assertEquals(THIRD, onChangedArgument);
    }

    [Test(expected="org.osflash.statemachine.errors.StateTransitionError")]
    public function cancel_transition_from_generic_changed_phase():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var reason:String;
        var onChanged:Function = function (stateName:String):void {
            fsmController.cancel(reason);
        };
        fsmController.addChangedListenerOnce(onChanged);
        fsmController.action(NEXT); // to SECOND
    }

    [Test]
    public function invoke_transition_from_generic_changed_phase():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var onChange:Function = function (stateName:String):void {
            fsmController.action(NEXT); // to THIRD
        };
        fsmController.addChangedListenerOnce(onChange);

        fsmController.action(NEXT); // to SECOND
        Assert.assertEquals(THIRD, fsmController.currentStateName);
    }

    [Test]
    public function straight_transition_phases_fired_in_correct_order_and_none_calls_tested():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var secondState:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var thirdState:ISignalState = injector.getInstance(ISignalState, THIRD) as ISignalState;
        var expected:Array = [  TransitionPhase.GLOBAL_CHANGED, TransitionPhase.EXITING_GUARD ,
            TransitionPhase.ENTERING_GUARD, TransitionPhase.TEAR_DOWN,
            TransitionPhase.ENTERED, TransitionPhase.GLOBAL_CHANGED];
        var got:Array = [];

        var onExitingGuard:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.EXITING_GUARD);
        };
        secondState.exitingGuard.add(onExitingGuard);

        var onEnteringGuard:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.ENTERING_GUARD);
        };
        thirdState.enteringGuard.add(onEnteringGuard);

        var onCancellation:Function = function (reason:String, payload:IPayload):void {
            got.push(TransitionPhase.CANCELLED);
        };
        secondState.cancelled.add(onCancellation);

        var onTearDownGuard:Function = function ():void {
            got.push(TransitionPhase.TEAR_DOWN);
        };
        secondState.tearDown.add(onTearDownGuard);

        var onEntered:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.ENTERED);
        };
        thirdState.entered.add(onEntered);

        var onChanged:Function = function (stateName:String):void {
            got.push(TransitionPhase.GLOBAL_CHANGED)
        };
        fsmController.addChangedListener(onChanged);

        fsmController.action(NEXT); // to SECOND
        fsmController.action(NEXT); // to THIRD
        Assert.assertWithApply(assertArraysEqual, [expected, got]);
    }


    [Test]
    public function transition_cancelled_from_exitingGuard_phases_fired_in_correct_order_and_none_calls_tested():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var secondState:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var thirdState:ISignalState = injector.getInstance(ISignalState, THIRD) as ISignalState;
        var expected:Array = [  TransitionPhase.GLOBAL_CHANGED, TransitionPhase.EXITING_GUARD ,
            TransitionPhase.CANCELLED];
        var got:Array = [];

        var onExitingGuard:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.EXITING_GUARD);
            fsmController.cancel("cancellationReason")
        };
        secondState.exitingGuard.add(onExitingGuard);

        var onEnteringGuard:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.ENTERING_GUARD);
        };
        thirdState.enteringGuard.add(onEnteringGuard);

        var onCancellation:Function = function (reason:String, payload:IPayload):void {
            got.push(TransitionPhase.CANCELLED);
        };
        secondState.cancelled.add(onCancellation);

        var onTearDownGuard:Function = function ():void {
            got.push(TransitionPhase.TEAR_DOWN);
        };
        secondState.tearDown.add(onTearDownGuard);

        var onEntered:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.ENTERED);
        };
        thirdState.entered.add(onEntered);

        var onChanged:Function = function (stateName:String):void {
            got.push(TransitionPhase.GLOBAL_CHANGED)
        };
        fsmController.addChangedListener(onChanged);

        fsmController.action(NEXT); // to SECOND
        fsmController.action(NEXT); // to THIRD
        Assert.assertWithApply(assertArraysEqual, [expected, got]);
    }

    [Test]
    public function transition_cancelled_from_enteringGuard_phases_fired_in_correct_order_and_none_calls_tested():void {
        setup(FSM);
        var fsmController:IFSMController = injector.getInstance(IFSMController) as IFSMController;
        var secondState:ISignalState = injector.getInstance(ISignalState, SECOND) as ISignalState;
        var thirdState:ISignalState = injector.getInstance(ISignalState, THIRD) as ISignalState;
        var expected:Array = [  TransitionPhase.GLOBAL_CHANGED, TransitionPhase.EXITING_GUARD ,
            TransitionPhase.ENTERING_GUARD, TransitionPhase.CANCELLED];
        var got:Array = [];

        var onExitingGuard:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.EXITING_GUARD);
        };
        secondState.exitingGuard.add(onExitingGuard);

        var onEnteringGuard:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.ENTERING_GUARD);
            fsmController.cancel("cancellationReason")
        };
        thirdState.enteringGuard.add(onEnteringGuard);

        var onCancellation:Function = function (reason:String, payload:IPayload):void {
            got.push(TransitionPhase.CANCELLED);
        };
        secondState.cancelled.add(onCancellation);

        var onTearDownGuard:Function = function ():void {
            got.push(TransitionPhase.TEAR_DOWN);
        };
        secondState.tearDown.add(onTearDownGuard);

        var onEntered:Function = function (payload:IPayload):void {
            got.push(TransitionPhase.ENTERED);
        };
        thirdState.entered.add(onEntered);

        var onChanged:Function = function (stateName:String):void {
            got.push(TransitionPhase.GLOBAL_CHANGED)
        };
        fsmController.addChangedListener(onChanged);

        fsmController.action(NEXT); // to SECOND
        fsmController.action(NEXT); // to THIRD
        Assert.assertWithApply(assertArraysEqual, [expected, got]);
    }

    public function assertArraysEqual(expected:Array, got:Array):void {
        Assert.assertEquals(expected.length, got.length);
        if (expected.length != got.length)return;
        for (var i:int = 0; i < expected.length; i++) {
            Assert.assertStrictlyEquals(expected[i], got[i]);
        }
    }


    private static const STARTING:String = "starting";
    private static const SECOND:String = "second";
    private static const THIRD:String = "third";
    private static const NON_DECLARED_TARGET:String = "nonDeclaredTarget";

    private static const NEXT:String = "next";
    private static const NON_DECLARED_TRANSITION:String = "nonDeclaredTransition";
    private static const TO_NON_DECLARED_TARGET:String = "toNonDeclaredTarget";

    private var FSM:XML =
            <fsm initial={STARTING}>
                <state  name={STARTING}>
                    <transition action={NEXT} target={SECOND}/>
                    <transition action={TO_NON_DECLARED_TARGET} target={NON_DECLARED_TARGET}/>
                </state>

                <state name={SECOND} inject="true">
                    <transition action={NEXT} target={THIRD}/>
                </state>

                <state name={THIRD} inject="true">
                    <transition action={NEXT} target={THIRD}/>
                </state>

            </fsm>;

    private var TESTING_UNDEFINED_INITIAL_VALUE_FSM:XML =
            <fsm >
                <state  name={STARTING}>
                    <transition action={NEXT} target={SECOND}/>
                    <transition action={TO_NON_DECLARED_TARGET} target={NON_DECLARED_TARGET}/>
                </state>

            </fsm>;


    private var TESTING_INITIAL_VALUE_IS_UNDEFINED_STATE_FSM:XML =
            <fsm initial={SECOND}>
                <state  name={STARTING}>
                    <transition action={NEXT} target={SECOND}/>
                    <transition action={TO_NON_DECLARED_TARGET} target={NON_DECLARED_TARGET}/>
                </state>

            </fsm>;


}
}
