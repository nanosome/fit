// @license
package nanosome.fit {
	import nanosome.util.IDisposable;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class LayoutListNode implements IDisposable {
		
		public function LayoutListNode() {}
		
		public var visibleNext: LayoutListNode;
		public var content: ILayoutable;
		internal var visiblePrev: LayoutListNode;
		internal var next: LayoutListNode;
		internal var prev: LayoutListNode;
		internal var isVisible : Boolean;
		
		public function dispose(): void {
			visibleNext = null;
			content = null;
			visiblePrev = null;
			next = null;
			prev = null;
			isVisible = false;
		}
	}
}
