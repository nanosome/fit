// @license
package nanosome.fit {
	
	import flash.display.DisplayObjectContainer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * @author mh
	 */
	public class EventWrapper implements ILayoutable {
		
		private var _target : DisplayObject;
		
		public function EventWrapper() {}
		
		public function resize( width: Number, height: Number ): void {}
		
		public function measure( baseWidth: Number, baseHeight: Number, result: Size ): void {
			result.width = _target.width;
			result.height = _target.height;
		}
		
		public function get x(): Number {
			return _target.x;
		}
		
		public function get y(): Number {
			return _target.y;
		}
		
		public function get visible(): Boolean {
			return _target ? _target.visible : false;
		}
		
		public function set x(x : Number) : void {
			_target.x = x;
		}
		
		public function set y(y : Number) : void {
			_target.y = y;
		}
		
		public function get target(): DisplayObject {
			return _target;
		}
		
		public function set target( target: DisplayObject ): void {
			if( _target != target ) {
				if( _target ) {
					_target.removeEventListener( Event.RESIZE, onResize );
				}
				_target = target;
				if( _target ) {
					_target.addEventListener( Event.RESIZE, onResize );
				}
				notifyParentAboutSizeChange( this );
			}
		}
		
		public function get parent(): DisplayObjectContainer {
			return _target ? _target.parent : null;
		}
		
		private function onResize( event: Event ): void {
			notifyParentAboutSizeChange( this );
		}
	}
}
