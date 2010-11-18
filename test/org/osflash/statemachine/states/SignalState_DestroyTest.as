package org.osflash.statemachine.states {
	import org.flexunit.Assert;

	public class SignalState_DestroyTest extends SignalState {

	public function SignalState_DestroyTest(){
		super( "state/signalstate" );
	}

	[Test]
	public function test():void{
		Assert.assertNull( "Initial value of _entered should be null", _entered );
		Assert.assertNull( "Initial value of _enteringGuard should be null", _enteringGuard );
		Assert.assertNull( "Initial value of _exitingGuard should be null", _exitingGuard );
		Assert.assertNull( "Initial value of _tearDown should be null", _tearDown );
		Assert.assertNull( "Initial value of _cancelled should be null", _cancelled );

		// use getter to lazily instantiate signals
		entered;
		enteringGuard;
		exitingGuard;
		tearDown;
		cancelled;

		// define a transition
		Assert.assertTrue( "Transition should be defined successfully", defineTrans("action/test", "state/test") );

		Assert.assertNotNull( "_entered should have been instantiated", _entered );
		Assert.assertNotNull( "_enteringGuard should have been instantiated", _enteringGuard );
		Assert.assertNotNull( "_exitingGuard should have been instantiated", _exitingGuard );
		Assert.assertNotNull( "_tearDown should have been instantiated", _tearDown );
		Assert.assertNotNull( "_cancelled should have been instantiated", _cancelled );

		// test that the transitions have been defined properly
		Assert.assertNotNull( "_transitions should have been instantiated",_transitions );
		Assert.assertTrue( "Test transition should be defined", hasTrans( "action/test"));

		destroy();

		Assert.assertNull( "_entered should be null", _entered );
		Assert.assertNull( "_enteringGuard should be null", _enteringGuard );
		Assert.assertNull( "_exitingGuard should be null", _exitingGuard );
		Assert.assertNull( "_tearDown should be null", _tearDown );
		Assert.assertNull( "_cancelled should be null", _cancelled );

		// test that the super.destroy() has been called
		Assert.assertNull( "_transitions should be null", _transitions );



	}
}
}