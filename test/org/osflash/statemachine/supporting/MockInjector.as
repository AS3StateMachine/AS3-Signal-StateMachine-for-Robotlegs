package org.osflash.statemachine.supporting {
	import flash.system.ApplicationDomain;

	import org.osflash.statemachine.core.IState;
	import org.robotlegs.core.IInjector;

	public class MockInjector implements IInjector {

	public var stateMap:Object;

	public function MockInjector(){
		stateMap = {};
	}

	public function mapValue( whenAskedFor:Class, useValue:Object, named:String = "" ):*{
		return stateMap[IState( useValue ).name] = ( useValue );
	}

	// all other methods empty

	public function injectInto( target:Object ):void{
		// do nothing
	}

	public function createChild( applicationDomain:ApplicationDomain = null ):IInjector{
		return null;
	}

	public function hasMapping( clazz:Class, named:String = "" ):Boolean{
		return false;
	}

	public function getInstance( clazz:Class, named:String = "" ):*{
		return null;
	}

	public function unmap( clazz:Class, named:String = "" ):void{
		// do nothing
	}

	public function mapSingletonOf( whenAskedFor:Class, useSingletonOf:Class, named:String = "" ):*{
		// do nothing
		return null;
	}

	public function mapRule( whenAskedFor:Class, useRule:*, named:String = "" ):*{
		// do nothing
		return null;
	}

	public function instantiate( clazz:Class ):*{
		// do nothing
		return null;
	}

	public function mapClass( whenAskedFor:Class, instantiateClass:Class, named:String = "" ):*{
		// do nothing
		return null;
	}

	public function mapSingleton( whenAskedFor:Class, named:String = "" ):*{
		// do nothing
		return null;
	}

		public function get applicationDomain():ApplicationDomain{
			return null;
		}

		public function set applicationDomain( value:ApplicationDomain ):void{
		}
	}
}