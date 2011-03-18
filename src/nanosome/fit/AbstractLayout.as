// @license
package nanosome.fit {
	
	import nanosome.notify.observe.ObservableSprite;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public class AbstractLayout extends ObservableSprite implements ILayout {
		
		private static var _stages: Dictionary = new Dictionary( true );
		
		private static function registerStage( stage: Stage ): void {
			if( !_stages[stage] ) {
				stage.addEventListener( Event.REMOVED, updateParent );
				_stages[stage] = true;
			}
		}
		
		private static function updateParent( event: Event ): void {
			var dO: DisplayObject = DisplayObject( event.target );
			if( dO is ILayoutable && dO.parent is AbstractLayout ) {
				var layout: AbstractLayout = AbstractLayout( dO.parent );
				if( layout.getChildIndex( dO ) != -1 )
				{
					layout.removeLayoutable( ILayoutable( dO ) );
				}
			}
		}
		
		protected var _width: Number = 0.0;
		protected var _height: Number = 0.0;
		
		protected const _size: Size = new Size();
		protected const _layoutChildren: LayoutList = new LayoutList();
		
		private var _renderOnUnlock : Boolean;
		private var _rendering : Boolean;
		
		public function AbstractLayout() {
			addEventListener( Event.ADDED_TO_STAGE, addedToStage, false, 0, true );
		}
		
		public function set children( children: Array ): void {
			if( children == null ){
				children = [];
			}
			var i: int;
			var waslocked: Boolean = locked;
			if( !waslocked ) {
 				lock();
 			}
			const l: int = children.length;
			for( i = 0; i < l ; ++i ) {
				addChildAt( children[i], i );
			}
			while( numChildren > l ) {
				removeChildAt( numChildren-1 );
			}
			if( !waslocked ){
				unlock();
			}
		}
		
		private function addedToStage( event: Event ) : void {
			registerStage( stage );
		}
		
		private function notifySizeChange(): void {
			if( parent is ILayout )
				ILayout( parent ).registerSizeChangeOfChild( this );
		}
		
		public function registerSizeChangeOfChild( child: ILayoutable ): Boolean {
			if( _rendering ) {
				return true;
			} else {
				if( child is ILayoutable ) {
					_layoutChildren.update( child );
					triggerRender();
				}
				return false;
			}
		}
		
		override public final function addChild(child : DisplayObject) : DisplayObject {
			return addChildAt( child, 0 );
		}
		
		protected function addLayoutable( child: ILayoutable, index: int = 0 ): void {
			_layoutChildren.addAt( child, index );
			triggerRender();
		}
		
		override public function addChildAt( child: DisplayObject, position: int): DisplayObject {
			if( child is ILayoutable ) {
				addLayoutable( ILayoutable( child ), position );
			}
			return super.addChildAt(child, position );
		}
		
		override public function removeChild(child : DisplayObject) : DisplayObject {
			if( child is ILayoutable ) {
				removeLayoutable( ILayoutable( child ) );
			}
			return super.removeChild(child);
		}
		
		protected function removeLayoutable( child: ILayoutable ): void {
			_layoutChildren.remove( child );
			triggerRender();
		}
		
		override public function removeChildAt( index: int ): DisplayObject {
			return removeChild( getChildAt(index));
		}

		public function resize( width: Number, height: Number ): void {
			if( width != _width || height != _height ) {
				_width = width;
				_height = height;
				triggerRender();
				notifySizeChange();
			}
		}
		
		public function measure( baseWidth: Number, baseHeight: Number, result: Size  ): void {
			result.width = _width;
			result.height = _height;
		}
		
		public function addChildren( children: Array ): ILayout {
			var l: int = children.length;
			for( var i: int = 0; i<l; ++i ) {
				addChild( children[i] );
			}
			return this;
		}
		
		override public function set locked( locked: Boolean ): void {
			if( this.locked != locked ) {
				super.locked = locked;
				if( !locked && _renderOnUnlock ) {
					_renderOnUnlock = false;
					if( !_rendering ) {
						_rendering = true;
						render();
						_rendering = false;
					}
				}
			}
		}
		
		protected function triggerRender(): void {
			if( locked ) {
				_renderOnUnlock = true;
			} else if( !_rendering ) {
				_rendering = true;
				render();
				_rendering = false;
			}
		}
		
		protected function render(): void {}
	}
}
