package org.osflash.statemachine.decoding {
import org.osflash.signals.ISignal;
import org.osflash.statemachine.base.BaseXMLStateDecoder;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.errors.StateDecodeError;
import org.osflash.statemachine.states.SignalState;
import org.osflash.statemachine.transitioning.TransitionPhase;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

/**
 * A StateDecoder is used by the FSMInjector to encapsulate the decoding of a
 * state declaration into a concrete IState instance.
 *
 * This implementation converts an XML declaration into an ISignalState, it also
 * is the point where the DI takes place, and thus where all the Robotleg
 * dependencies are encapsulated.
 *
 * @see org.osflash.statemachine.FSMInjector
 * @see org.osflash.statemachine.core.ISignalState
 * @see org.osflash.statemachine.states.SignalState
 */
public class SignalXMLStateDecoder extends BaseXMLStateDecoder {

    public static const COMMAND_CLASS_NOT_REGISTERED:String = "These commands need to be added to the StateDecoder: ";
    public static const COMMAND_CLASS_CAN_BE_MAPPED_ONCE_ONLY_TO_SAME_SIGNAL:String = "A command class can be mapped once only to the same signal: ";

    /**
     * @private
     */
    protected var classBagMap:Array;

    /**
     * @private
     */
    protected var injector:IInjector;

    /**
     * @private
     */
    protected var signalCommandMap:IGuardedSignalCommandMap;
    protected var errors:Array;

    /**
     * Creates an instance of a SignalXMLStateDecoder
     * @param fsm the state declaration
     * @param injector the injector for the current IContext
     * @param signalCommandMap the ISignalCommandMap for the current IContext
     */
    public function SignalXMLStateDecoder(fsm:XML, injector:IInjector, signalCommandMap:IGuardedSignalCommandMap):void {
        this.injector = injector;
        this.signalCommandMap = signalCommandMap;
        errors = [];
        super(fsm);
    }

    /**
     * @inheritDoc
     */
    override public final function decodeState(stateDef:Object):IState {
        // Create State object
        var state:ISignalState = getState(stateDef);
        decodeTransitions(state, stateDef);
        injectState(state, stateDef);
        mapSignals(state, stateDef);
        return state;
    }

    /**
     * @inheritDoc
     */
    override public function destroy():void {
        errors = null;
        injector = null;
        signalCommandMap = null;
        if (classBagMap != null) {
            for each (var cb:ClassBag in classBagMap)    cb.destroy();
        }
        classBagMap = null;
        super.destroy();
    }

    /**
     * Adds a command Class reference.
     *
     * Any command declared in the state declaration must be added here.
     * @param value the command class
     * @return whether the command class has been add successfully
     */
    public function addClass(value:Class):Boolean {
        if (classBagMap == null) classBagMap = [];
        if (hasClass(value)) return false;
        classBagMap.push(new ClassBag(value));
        return true;
    }

    /**
     * Test to determine whether a particular class has already been added
     * to the decoder
     * @param name this can either be the name, the fully qualified name or an instance of the Class
     * @return
     */
    public function hasClass(name:Object):Boolean {
        return ( getClass(name) != null );
    }

    /**
     * Retrieves a command class registered with the addCommandClass method
     * @param name this can either be the name, the fully qualified name or an instance of the Class
     * @return the class reference
     */
    public function getClass(name:Object):Class {
        for each (var cb:ClassBag in classBagMap) {
            if (cb.equals(name)) return cb.payload;
        }
        return null;
    }

    /**
     * Factory method for creating concrete ISignalState. Override this to allow for the
     * creation of custom states
     * @param stateDef the declaration for a single state
     * @return an instance of the state described in the data
     */
    protected function getState(stateDef:Object):ISignalState {
        return new SignalState(stateDef.@name.toString());
    }

    /**
     * Decodes the State's transitions from the state declaration
     * @param state the state into which to inject the transitions
     * @param stateDef the state's declaration
     */
    protected function decodeTransitions(state:IState, stateDef:Object):void {
        var transitions:XMLList = stateDef..transition as XMLList;
        for (var i:int; i < transitions.length(); i++) {
            var transDef:XML = transitions[i];
            state.defineTrans(String(transDef.@action), String(transDef.@target));
        }
    }

    /**
     * Injects a IState into the DI Container if it is marked for injection in its declaration
     * @param state the IState to be injected
     * @param stateDef the state's declaration
     */
    protected function injectState(state:IState, stateDef:Object):void {
        var inject:Boolean = ( stateDef.@inject.toString() == "true" );
        if (inject)
            injector.mapValue(ISignalState, state, state.name);

    }

    /**
     * Maps the commands referenced int he state declaration to their appropriate
     * state transition phases
     * @param signalState the state whose ISignal phases are to be mapped to
     * @param stateDef the state's declaration
     */
    protected function mapSignals(signalState:ISignalState, stateDef:Object):void {

        var entered:PhaseDecoder = new PhaseDecoder(TransitionPhase.ENTERED, stateDef.entered);
        var enteringGuard:PhaseDecoder = new PhaseDecoder(TransitionPhase.ENTERING_GUARD, stateDef.enteringGuard);
        var exitingGuard:PhaseDecoder = new PhaseDecoder(TransitionPhase.EXITING_GUARD, stateDef.exitingGuard);
        var tearDown:PhaseDecoder = new PhaseDecoder(TransitionPhase.TEAR_DOWN, stateDef.tearDown);
        var cancelled:PhaseDecoder = new PhaseDecoder(TransitionPhase.CANCELLED, stateDef.cancelled);

        if (!entered.isNull)
            mapSignalCommand(signalState.entered, entered);

        if (!enteringGuard.isNull)
            mapSignalCommand(signalState.enteringGuard, enteringGuard);

        if (!exitingGuard.isNull)
            mapSignalCommand(signalState.exitingGuard, exitingGuard);

        if (!tearDown.isNull)
            mapSignalCommand(signalState.tearDown, tearDown);

        if (!cancelled.isNull)
            mapSignalCommand(signalState.cancelled, cancelled);

        if (errors.length > 0)
            throw new StateDecodeError(COMMAND_CLASS_NOT_REGISTERED + errors.toString());
    }

    /**
     * @private
     */

    private function mapSignalCommand(signal:ISignal, phaseDecoder:PhaseDecoder):void {
        for each (var item:PhaseDecoderItem in phaseDecoder.decodedItems) {
            if (item.isError)
                throw new StateDecodeError(item.error);
            else if (item.guardCommandClassNames == null) {
                var commandClass:Class = getAndValidateClass(item.commandClassName);
                if (commandClass != null && doesNotHaveMapping(signal, commandClass))
                    signalCommandMap.mapSignal(signal, commandClass);
            } else {
                mapGuardedSignalCommand(signal, item)
            }

        }
    }

    private function mapGuardedSignalCommand(signal:ISignal, item:PhaseDecoderItem):void {
        var guardClasses:Array = [];
        var commandClass:Class = getAndValidateClass( item.commandClassName );
        var fallBackCommandClass:Class = ( item.hasFallback ) ? getAndValidateClass(item.fallbackCommandClassName) : null;

        for each (var guardClassName:String in item.guardCommandClassNames) {
            var g:Class = getAndValidateClass(guardClassName);
            if (g != null)guardClasses.push(g);
        }

        if (    guardClasses.length != item.guardCommandClassNames.length ||
                commandClass == null ||
                !doesNotHaveMapping(signal, commandClass)) return;

        if(fallBackCommandClass == null )
            signalCommandMap.mapGuardedSignal(signal, commandClass, guardClasses);
        else
            signalCommandMap.mapGuardedSignalWithFallback( signal, commandClass, fallBackCommandClass, guardClasses);
    }

    private function doesNotHaveMapping(signal:ISignal, commandClass:Class):Boolean {
        if (signalCommandMap.hasSignalCommand(signal, commandClass))
            throw new StateDecodeError(COMMAND_CLASS_CAN_BE_MAPPED_ONCE_ONLY_TO_SAME_SIGNAL);
        return true;
    }

    private function getAndValidateClass(name:Object):Class {
        var c:Class = getClass(name);
        if (c == null) errors.push(name.toString());
        return c;
    }


}
}

import flash.utils.describeType;

import org.osflash.statemachine.core.IClassBag;
import org.osflash.statemachine.core.ITransitionPhase;
import org.osflash.statemachine.transitioning.TransitionPhase;

/**
 * Wrapper class for a Class reference.
 */
internal class ClassBag implements IClassBag {

    private var _pkg:String;

    private var _name:String;

    private var _payload:Class;

    /**
     * Wraps and reflects a class reference instance )
     */
    public function ClassBag(c:Class):void {
        _payload = c;
        describeClass(c);
    }

    /**
     * @inheritDoc
     */
    public function get name():String {
        return _name;
    }

    /**
     * @inheritDoc
     */
    public function get payload():Class {
        return _payload;
    }

    /**
     * @inheritDoc
     */
    public function get pkg():String {
        return _pkg;
    }

    /**
     * @inheritDoc
     */
    public function toString():String {
        return _pkg + "." + _name;
    }

    /**
     * @inheritDoc
     */
    public function equals(value:Object):Boolean {
        return (( value.toString() == _pkg + "." + _name ) ||
                ( value.toString() == _pkg + "::" + _name ) ||
                ( value.toString() == _name ) ||
                ( value == _payload )                            );
    }

    /**
     * Destroys the ClassBag
     */
    public function destroy():void {
        _payload = null;
        _name = null;
        _pkg = null;
    }

    /**
     * @private
     */
    private function describeClass(c:Class):void {
        var description:XML = describeType(c);
        var split:Array = description.@name.toString().split("::");
        _pkg = String(split[0]);
        _name = String(split[1]);
    }
}

internal class PhaseDecoder {

    internal var decodedItems:Array;
    private var _phase:ITransitionPhase;

    public function PhaseDecoder(phase:ITransitionPhase, phaseDef:XMLList):void {
        _phase = phase;
        decode(phaseDef);
    }

    public function get isNull():Boolean {
        return (decodedItems == null || decodedItems.length == 0);
    }

    private function decode(phaseDef:XMLList):void {
        if (phaseDef.length() == 0)return;
        decodedItems = [];
        var list:XMLList = phaseDef.commandClass;
        for each (var xml:XML in list) {
            var item:PhaseDecoderItem = new PhaseDecoderItem();
            item.phase = _phase;
            item.commandClassName = xml.@classPath.toString();
            item.fallbackCommandClassName = xml.@fallback.toString();
            item.guardCommandClassNames = decodeGuards(xml.guardClass.@classPath);
            decodedItems.push(item);
        }
    }


    private function decodeGuards(list:XMLList):Array {
        if (list.length() == 0)return null;
        var a:Array = [];
        for each (var xml:XML in list) {
            a.push(xml.toString());
        }
        return a;
    }
}

internal class PhaseDecoderItem {

    private static const ILLEGAL_FALLBACK_COMMAND_DECLARATION:String = "Fallback commands can not be declared for this transition phase: ";
    internal var commandClassName:String;
    internal var fallbackCommandClassName:String;
    internal var guardCommandClassNames:Array;
    internal var phase:ITransitionPhase;
    internal var error:String;

    public function get isError():Boolean {
        if( TransitionPhase.ENTERED.equals(phase) || TransitionPhase.TEAR_DOWN.equals(phase) || TransitionPhase.CANCELLED.equals(phase) ) return false;
        if( hasFallback ) error = ILLEGAL_FALLBACK_COMMAND_DECLARATION;
        return hasFallback;
    }

    public function get hasFallback():Boolean {
        return ( fallbackCommandClassName != null ) && ( fallbackCommandClassName != "" );
    }
}
