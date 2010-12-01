package org.osflash.statemachine.supporting.mocks {

public class MockSignalListener{

	public var conclusion:Boolean;

	private var payload:Object;
	private var info:String;

	public function MockSignalListener( info:String, payload:Object ){
		this.payload = payload;
		this.info = info;
	}

	public function listenerOne( info:String, payload:Object ):void{
		conclusion = ( this.info == info && this.payload === payload )
	}

	public function listenerTwo( info:String ):void{
		conclusion = ( this.info == info )
	}

	public function reset():void{
		conclusion = false;
	}
}
}