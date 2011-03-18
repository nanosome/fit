// @license
package nanosome.fit {
	
	import nanosome.notify.observe.ObservableSprite;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public class Layoutable extends ObservableSprite implements ILayoutable {
		
		protected var _width: Number = NaN;
		protected var _height: Number = NaN;
		private var _sizeChanged : Boolean;
		
		public function Layoutable() {}
		
		protected function notifySizeChange(): void {
			if( !locked ) {
				if( notifyParentAboutSizeChange( this ) ) render();
			} else {
				_sizeChanged = true;
			}
		}
		
		
		override public function set locked( locked: Boolean ): void {
			if( this.locked != locked ) {
				super.locked = locked;
				if( !locked && _sizeChanged ) {
					_sizeChanged = false;
					notifySizeChange();
				}
			}
		}
		
		public function resize( width: Number, height: Number ): void {
			if( width != _width || height != _height ) {
				_height = height;
				_width = width;
				render();
				notifySizeChange();
			}
		}
		
		override public function set visible(value : Boolean) : void {
			if( value != super.visible )
			{
				super.visible = value;
				notifySizeChange();
			}
		}
		
		protected function render(): void {
		}
		
		public function measure(baseWidth : Number, baseHeight : Number, result : Size) : void {
			result.width = isNaN( _width ) ? 0.0 : _width;
			result.height = isNaN( _height ) ? 0.0 : _height;
		}
	}
}
