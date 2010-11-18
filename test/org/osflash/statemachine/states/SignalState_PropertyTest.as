package org.osflash.statemachine.states {
	import org.flexunit.Assert;
	import org.osflash.signals.Signal;

	public class SignalState_PropertyTest extends SignalState {

	public function SignalState_PropertyTest(){
		super( "state/signalstate" );
	}

	[Test]
	public function testStateProperties():void{
		Assert.assertNull( "entered property should be null by default", _entered );
		Assert.assertNull( "enteringGuard property should be null by default", _enteringGuard );
		Assert.assertNull( "exitingGuard property should be null by default", _exitingGuard );
		Assert.assertNull( "tearDown property should be null by default", _tearDown  );
		Assert.assertNull( "cancelled property should be null by default", _cancelled  );

		Assert.assertNotNull( "entered property should be lazily instanciated", entered );
		Assert.assertNotNull( "enteringGuard property should be lazily instanciated", enteringGuard );
		Assert.assertNotNull( "exitingGuard property should be lazily instanciated", exitingGuard );
		Assert.assertNotNull( "tearDown property should be lazily instanciated", tearDown  );
		Assert.assertNotNull( "cancelled property should be lazily instanciated", cancelled  );

		Assert.assertTrue( "entered property should be a Signal", entered is Signal );
		Assert.assertTrue( "entered property should have 1 value class", entered.valueClasses.length == 1 );
		Assert.assertTrue( "entered property valueClass[0] should be an Object", entered.valueClasses[0] === Object );

		Assert.assertTrue( "enteringGuard property should be Signal", enteringGuard is Signal );
		Assert.assertTrue( "enteringGuard property should have 1 value class", enteringGuard.valueClasses.length == 1 );
		Assert.assertTrue( "enteringGuard property valueClass[0] should be an Object", enteringGuard.valueClasses[0] === Object );

		Assert.assertTrue( "exitingGuard property should be Signal", exitingGuard is Signal );
		Assert.assertTrue( "exitingGuard property should have 1 value class", exitingGuard.valueClasses.length == 1 );
		Assert.assertTrue( "exitingGuard property valueClass[0] should be an Object", exitingGuard.valueClasses[0] === Object );

		Assert.assertTrue( "tearDown property should be Signal", tearDown is Signal  );
		Assert.assertTrue( "tearDown property should have no value classes", tearDown.valueClasses.length == 0 );

		Assert.assertTrue( "cancelled property should be Signal", cancelled is Signal  );
		Assert.assertTrue( "cancelled property should have 2 value classes", cancelled.valueClasses.length == 2 );
		Assert.assertTrue( "cancelled property valueClass[0] should be a String", cancelled.valueClasses[0] === String );
		Assert.assertTrue( "cancelled property valueClass[1] should be an Object", cancelled.valueClasses[1] === Object );



		
	}
}
}