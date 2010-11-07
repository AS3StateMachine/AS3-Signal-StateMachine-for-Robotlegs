package org.osflash.statemachine.supporting {
public class StateDefinitions {
	public function StateDefinitions(){
	}

	////////
	// State Machine Constants and Vars
	///////
	public static const STARTING:String = "state/starting";
	public static const STARTED:String = "action/completed/start";
	public static const START_FAILED:String = "action/start/failed";

	public static const CONSTRUCTING:String = "state/constructing";
	public static const CONSTRUCT:String = "event/construct";

	public static const CONSTRUCT_ENTERING:String = "action/construct/entering";
	public static const CONSTRUCTED:String = "action/completed/construction";
	public static const CONSTRUCTION_EXIT:String = "event/construction/exit";
	public static const CONSTRUCTION_FAILED:String = "action/contruction/failed";

	public static const NAVIGATING:String = "state/navigating";

	public static const FAILING:String = "state/failing";

	public function get data():XML{
		return _state.copy();
	}

	private var _state:XML = <fsm initial={STARTING}>

		<!-- THE INITIAL STATE -->

		<state
		name={STARTING}
		inject="true"
		enteringGuard="SignalCommandOne"
		entered="SignalCommandTwo"
		exitingGuard="SignalCommandThree"
		teardown="SignalCommandFour"
		cancelled="SignalCommandFive">

			<transition action={STARTED}
			target={CONSTRUCTING}/>

			<transition action={START_FAILED}
			target={FAILING}/>

		</state>

		<!-- DOING SOME WORK -->
		<state
		name={CONSTRUCTING}
		inject="false"
		enteringGuard="SignalCommandOne"
		entered="SignalCommandTwo"
		exitingGuard="SignalCommandThree"
		teardown="SignalCommandFour"
		cancelled="SignalCommandFive">

			<transition action={CONSTRUCTION_FAILED}
			target={FAILING}/>

			<transition action={CONSTRUCTED}
			target={NAVIGATING}/>

		</state>

		<!-- READY TO ACCEPT BROWSER OR USER NAVIGATION -->
		<state
		name={NAVIGATING}
		enteringGuard="UnregisteredCommand"/>

		<!-- REPORT FAILURE FROM ANY STATE -->
		<state name={FAILING}/>

	</fsm>;
}
}