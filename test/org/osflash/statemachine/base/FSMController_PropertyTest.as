package org.osflash.statemachine.base {
	import flexunit.framework.Assert;

	import org.osflash.signals.Signal;

	public class FSMController_PropertyTest extends FSMController {
	public function FSMController_PropertyTest(){
		super();
	}



	[Test]
	public function test():void{
		Assert.assertNotNull( _action );
		Assert.assertNotNull( _cancel );
		Assert.assertNotNull( _changed );

		Assert.assertTrue( _action is Signal);
		Assert.assertTrue( _cancel is Signal);
		Assert.assertTrue( _changed is Signal);
	}
}
}