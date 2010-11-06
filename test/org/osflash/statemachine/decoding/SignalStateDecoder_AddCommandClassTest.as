package org.osflash.statemachine.decoding {
import org.flexunit.Assert;
import org.osflash.statemachine.supporting.cmds.SignalCommandOne;
import org.osflash.statemachine.supporting.cmds.SignalCommandThree;
import org.osflash.statemachine.supporting.cmds.SignalCommandTwo;

public class SignalStateDecoder_AddCommandClassTest extends SignalStateDecoder {

	public function SignalStateDecoder_AddCommandClassTest(){
		super( null, null, null );
	}

	[Test]
	public function test():void{

		Assert.assertNull( "The classBagMap property should be null by default", classBagMap );

		Assert.assertTrue( "Adding SignalCommandOne should succeed", addCommandClass( SignalCommandOne ) );
		Assert.assertTrue( "Adding SignalCommandTwo should succeed", addCommandClass( SignalCommandTwo ) );
		Assert.assertTrue( "Adding SignalCommandThree should succeed", addCommandClass( SignalCommandThree ) );

		Assert.assertFalse( "Adding SignalCommandOne again should fail", addCommandClass( SignalCommandOne ) );
		Assert.assertFalse( "Adding SignalCommandTwo again should fail", addCommandClass( SignalCommandTwo ) );
		Assert.assertFalse( "Adding SignalCommandThree again should fail", addCommandClass( SignalCommandThree ) );

		Assert.assertTrue( "Should have Class, testing with class referance", hasClass( SignalCommandOne ) );
		Assert.assertTrue( "Should have Class, testing with class name", hasClass( "SignalCommandTwo" ) );
		Assert.assertTrue( "Should have Class, testing with full class path", hasClass( "org.osflash.statemachine.supporting.cmds.SignalCommandThree" ) );
		Assert.assertTrue( "Should have Class, testing with fully qualified class name", hasClass( "org.osflash.statemachine.supporting.cmds::SignalCommandThree" ) );

		Assert.assertStrictlyEquals( "The class expected should be SignalCommandOne", SignalCommandOne, getClass( "SignalCommandOne" ) );
		Assert.assertStrictlyEquals( "The class expected should be SignalCommandTwo", SignalCommandTwo, getClass( "SignalCommandTwo" ) );
		Assert.assertStrictlyEquals( "The class expected should be SignalCommandThree", SignalCommandThree, getClass( "SignalCommandThree" ) );

	}

}
}