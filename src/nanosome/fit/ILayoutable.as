// @license
package nanosome.fit {
	import flash.display.DisplayObjectContainer;

	/**
	 * @author mh
	 */
	public interface ILayoutable
	{
		function get x(): Number;
		function set x( x: Number ): void;
		function get y(): Number;
		function set y( y: Number ): void;
		function get visible(): Boolean;
		
		function resize( width: Number, height: Number ): void;
		function measure( baseWidth: Number, baseHeight: Number, result: Size ): void;
		
		function get parent(): DisplayObjectContainer;
	}
}
