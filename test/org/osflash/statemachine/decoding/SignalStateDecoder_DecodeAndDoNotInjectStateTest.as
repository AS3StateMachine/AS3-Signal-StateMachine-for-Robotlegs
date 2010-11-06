package org.osflash.statemachine.decoding {

import org.flexunit.Assert;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.supporting.MockInjector;
import org.osflash.statemachine.supporting.MockSignalCommandMap;
import org.osflash.statemachine.supporting.StateDefinitions;
import org.osflash.statemachine.supporting.cmds.SignalCommandFive;
import org.osflash.statemachine.supporting.cmds.SignalCommandFour;
import org.osflash.statemachine.supporting.cmds.SignalCommandOne;
import org.osflash.statemachine.supporting.cmds.SignalCommandThree;
import org.osflash.statemachine.supporting.cmds.SignalCommandTwo;

public class SignalStateDecoder_DecodeAndDoNotInjectStateTest extends SignalStateDecoder {

	public function SignalStateDecoder_DecodeAndDoNotInjectStateTest(){
		super( null, new MockInjector(), new MockSignalCommandMap() );
		addCommandClass( SignalCommandOne );
		addCommandClass( SignalCommandTwo );
		addCommandClass( SignalCommandThree );
		addCommandClass( SignalCommandFour );
		addCommandClass( SignalCommandFive );
	}

	[Test]
	public function test():void{
		var stateData:XML = new StateDefinitions().data.elements()[1];
		var signalState:ISignalState = decodeState( stateData ) as ISignalState;
		var inj:MockInjector = MockInjector( injector );
		var scm:MockSignalCommandMap = MockSignalCommandMap( signalCommandMap );

		// test state name and type
		Assert.assertNotNull( "The State should be an ISignalState", signalState );
		Assert.assertEquals( "State name should be correct", StateDefinitions.CONSTRUCTING, signalState.name );

		// test state transitions
		Assert.assertEquals( "Transition StateDefinitions.CONSTRUCTING should have been defined", StateDefinitions.NAVIGATING, signalState.getTarget( StateDefinitions.CONSTRUCTED ) );
		Assert.assertEquals( "Transition StateDefinitions.START_FAILED should have been defined", StateDefinitions.FAILING, signalState.getTarget( StateDefinitions.CONSTRUCTION_FAILED ) );

		// test state mapping
		Assert.assertNull( "State should not be mapped by injector", inj.stateMap[ signalState.name ] );

		// test command mapping
		Assert.assertStrictlyEquals( "EnteringGuard should be mapped by signalCommandMap", signalState.enteringGuard, scm.testMap[ SignalCommandOne ] );
		Assert.assertStrictlyEquals( "Entered should be mapped by signalCommandMap", signalState.entered, scm.testMap[ SignalCommandTwo ] );
		Assert.assertStrictlyEquals( "ExitingGuard should be mapped by signalCommandMap", signalState.exitingGuard, scm.testMap[ SignalCommandThree ] );
		Assert.assertStrictlyEquals( "Teardown should be mapped by signalCommandMap", signalState.tearDown, scm.testMap[ SignalCommandFour ] );
		Assert.assertStrictlyEquals( "Cancelled should be mapped by signalCommandMap", signalState.cancelled, scm.testMap[ SignalCommandFive ] );

	}

}
}