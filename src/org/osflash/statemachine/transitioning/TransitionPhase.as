package org.osflash.statemachine.transitioning {
import org.osflash.statemachine.core.ITransitionPhase;

public class TransitionPhase implements ITransitionPhase {

    public static const NONE:TransitionPhase = new TransitionPhase("none", 1);
    public static const EXITING_GUARD:TransitionPhase = new TransitionPhase("exitingGuard", 2);
    public static const ENTERING_GUARD:TransitionPhase = new TransitionPhase("enteringGuard", 4);
    public static const ENTERED:TransitionPhase = new TransitionPhase("entered", 8);
    public static const TEAR_DOWN:TransitionPhase = new TransitionPhase("tearDown", 16);
    public static const CANCELLED:TransitionPhase = new TransitionPhase("cancelled", 32);
    public static const GLOBAL_CHANGED:TransitionPhase = new TransitionPhase("globalChanged", 64);

    public function TransitionPhase(name:String, index:int) {
        _name = name;
        _index = index;
    }

    private var _name:String;

    public function get name():String {
        return _name;
    }

    private var _index:int;

    public function get index():int {
        return _index;
    }

    public function equals(value:Object):Boolean {
        return (value === this) || (value == name) || (value == index);
    }
}


}