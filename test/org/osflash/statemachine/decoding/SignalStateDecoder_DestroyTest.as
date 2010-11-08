package org.osflash.statemachine.decoding {
import org.flexunit.Assert;
	import org.osflash.statemachine.core.IClassBag;
	import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.states.SignalState;
import org.osflash.statemachine.supporting.MockInjector;
import org.osflash.statemachine.supporting.MockSignalCommandMap;
import org.osflash.statemachine.supporting.StateDefinitions;
	import org.osflash.statemachine.supporting.cmds.SignalCommandOne;
	import org.osflash.statemachine.supporting.cmds.SignalCommandThree;
	import org.osflash.statemachine.supporting.cmds.SignalCommandTwo;

	public class SignalStateDecoder_DestroyTest extends SignalStateDecoder {

	public function SignalStateDecoder_DestroyTest(){
		super( new StateDefinitions().data, new MockInjector(), new MockSignalCommandMap() );
	}

	[Test]
	public function test():void{
		// map classBagMap locally, so we can test it has been destroyed
		var cmap:Array = classBagMap;

		// add some commands to it
		addCommandClass( SignalCommandOne );
		addCommandClass( SignalCommandTwo );
		addCommandClass( SignalCommandThree );

		destroy();

		// these properties should be nulled by the SignalStateDecoder
		Assert.assertNull("signalCommandMap should be null", signalCommandMap);
		Assert.assertNull("injector should be null", injector );
		Assert.assertNull("classBagMap should be null", classBagMap );

		// this will test if the super destroy has been called
		Assert.assertNull("fsm data should be null", getData());

		// test that each ClassBag has been destroyed
		for each ( var cb:IClassBag in cmap ){
			Assert.assertNull("payload should be null", cb.payload );
			Assert.assertNull("name should be null", cb.name );
			Assert.assertNull("pkg should be null", cb.pkg );
		}

	}
}
}