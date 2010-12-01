package org.osflash.statemachine.transitioning {
	public class TransitionPhases {
		public static const NONE:String = "none";
		public static const EXITING_GUARD:String = "exitingGuard";
		public static const ENTERING_GUARD:String = "enteringGuard";
		public static const ENTERED:String = "entered";
		public static const TEAR_DOWN:String = "tearDown";
		public static const CANCELLED:String = "cancelled";
		public static const GLOBAL_CHANGED:String = "globalChanged";
	}
}