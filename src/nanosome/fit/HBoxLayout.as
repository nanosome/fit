// @license
package nanosome.fit {

	/**
	 * @author mh
	 */
	public class HBoxLayout extends AbstractLayout {
		
		private var _totalWidth: Number = .0;
		private var _maxHeight: Number = .0;
		private var _valign: VAlign;
		
		public function HBoxLayout( valign: VAlign = null ) {
			_valign = valign || VAlign.TOP;
		}
		
		override protected function render() : void {
			var node: LayoutListNode = _layoutChildren.visibleFirst;
			var x: Number = .0;
			var h: Number = .0;
			
			while( node ) {
				_layoutChildren.visibleNext = node.visibleNext;
				node.content.measure( _width, _height, _size );
				node.content.resize( _size.width, _size.height );
				node.content.x = x;
				node.content.y = 0;
				x += _size.width;
				if( _size.height > h ) {
					h = _size.height;
				}
				node = _layoutChildren.visibleNext;
			}
			
			if( _valign == VAlign.MIDDLE )
			{
				node = _layoutChildren.visibleFirst;
				while( node ) {
					_layoutChildren.visibleNext = node.visibleNext;
					node.content.measure( _width, _height, _size );
					node.content.y = (h-_size.height)/2;
					node = _layoutChildren.visibleNext;
				}
			}
			else
			if( _valign == VAlign.BOTTOM )
			{
				node = _layoutChildren.visibleFirst;
				while( node ) {
					_layoutChildren.visibleNext = node.visibleNext;
					node.content.measure( _width, _height, _size );
					node.content.y = (h-_size.height);
					node = _layoutChildren.visibleNext;
				}
			}
			if( _totalWidth != x || _maxHeight != h )
			{
				_totalWidth = x;
				_maxHeight = h;
				notifyParentAboutSizeChange( this );
			}
		}
		
		override public function measure(baseWidth : Number, baseHeight : Number, result : Size) : void {
			baseWidth; baseHeight;
			result.width = _totalWidth;
			result.height = _maxHeight;
		}
		
		[Observable]
		public function set valign( valign: VAlign ) : void {
			if( _valign != valign ) {
				notifyPropertyChange( "valign", _valign, _valign = valign );
				triggerRender();
			}
		}
	}
}
