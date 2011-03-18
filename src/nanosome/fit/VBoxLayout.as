// @license
package nanosome.fit {

	/**
	 * @author mh
	 */
	public class VBoxLayout extends AbstractLayout {
		
		private var _totalHeight: Number = .0;
		private var _maxWidth: Number = .0;
		private var _halign : HAlign;
		
		public function VBoxLayout( align: HAlign = null ) {
			_halign = align || HAlign.LEFT;
		}
		
		override protected function render(): void {
			var node: LayoutListNode = _layoutChildren.visibleFirst;
			var y: Number = .0;
			var w: Number = .0;
			
			while( node ) {
				_layoutChildren.visibleNext = node.visibleNext;
				node.content.measure( _width, _height, _size);
				node.content.resize( _size.width, _size.height );
				node.content.x = 0;
				node.content.y = y;
				y += _size.height;
				if( _size.width > w ) {
					_maxWidth = _size.width;
				}
				node = _layoutChildren.visibleNext;
			}
			
			if( _halign == HAlign.CENTER )
			{
				node = _layoutChildren.visibleFirst;
				while( node ) {
					_layoutChildren.visibleNext = node.visibleNext;
					node.content.measure( _width, _height, _size );
					node.content.x = (w-_size.width)/2;
					node = _layoutChildren.visibleNext;
				}
			}
			else
			if( _halign == HAlign.RIGHT )
			{
				node = _layoutChildren.visibleFirst;
				while( node ) {
					_layoutChildren.visibleNext = node.visibleNext;
					node.content.measure( _width, _height, _size );
					node.content.x = (w-_size.width);
					node = _layoutChildren.visibleNext;
				}
			}
			if( x != _totalHeight || w != _maxWidth )
			{
				_totalHeight = x;
				_maxWidth = w;
				notifyParentAboutSizeChange( this );
			}
		}
		
		override public function measure(baseWidth : Number, baseHeight : Number, result : Size) : void {
			baseWidth; baseHeight;
			result.width = _maxWidth;
			result.height = _totalHeight;
		}
		
		[Observable]
		public function set halign( halign: HAlign ) : void {
			if( _halign != halign ) {
				notifyPropertyChange( "halign", _halign, _halign = halign );
				triggerRender();
			}
		}
	}
}
