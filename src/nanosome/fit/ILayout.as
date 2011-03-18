// @license
package nanosome.fit {
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	/**
	 * @author mh
	 */
	public interface ILayout extends ILayoutable, IEventDispatcher
	{
		function registerSizeChangeOfChild( child: ILayoutable ): Boolean;
		
		function addChild( child: DisplayObject ): DisplayObject;
		function addChildAt( child: DisplayObject, index: int ): DisplayObject;
		
		function removeChild( child: DisplayObject ): DisplayObject;
		function removeChildAt( index: int ): DisplayObject;
	}
}
