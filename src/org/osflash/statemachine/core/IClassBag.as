package org.osflash.statemachine.core {
	/**
	 * Contract for wrapping and reflecting class references
	 */
	public interface IClassBag {
		/**
		 * the name of the class
		 */
		function get name():String;

		/**
		 * the class reference being wrapped
		 */
		function get payload():Class;

		/**
		 * the pkg name (excluding name)
		 */
		function get pkg():String;

		/**
		 * Evaluates the equality of the value passed with the wrapped Class.
		 * can pass:
		 * <li>the full qualified class name ( my.full.package.Class or my.full.package::Class )</li>
		 * <li>just the name</li>
		 * <li>or an instance of the Class ref itself</li>
		 * @param value item to evaluate against
		 * @return the result of the comparison
		 */
		function equals( value:Object ):Boolean

		/**
		 * destroys the instance
		 */
		function destroy():void
	}
}