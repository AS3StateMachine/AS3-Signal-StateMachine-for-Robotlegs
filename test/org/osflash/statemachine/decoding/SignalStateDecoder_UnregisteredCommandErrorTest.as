package org.osflash.statemachine.decoding {
	import org.flexunit.Assert;
	import org.osflash.statemachine.core.ISignalState;
	import org.osflash.statemachine.states.SignalState;
	import org.osflash.statemachine.supporting.MockInjector;
	import org.osflash.statemachine.supporting.MockSignalCommandMap;
	import org.osflash.statemachine.supporting.StateDefinitions;

	public class SignalStateDecoder_UnregisteredCommandErrorTest extends SignalXMLStateDecoder {

	public function SignalStateDecoder_UnregisteredCommandErrorTest(){
		super( null, new MockInjector(), new MockSignalCommandMap() );
	}

	[Test(expects="org.osflash.statemachine.errors.UnregisteredSignalCommandError")]
	public function test():void{
		var stateData:XML = new StateDefinitions().data.elements()[2];
		var signalState:ISignalState = decodeState( stateData ) as ISignalState;

		// test state name and type
		Assert.assertTrue( "State type should be correct", signalState is SignalState );
		Assert.assertEquals( "State name should be correct", StateDefinitions.NAVIGATING, signalState.name );

	}
}
}