// @license
package nanosome.fit {
	import flash.events.Event;

	/**
	 * @author mh
	 */
	public class FullScreenLayout extends AbstractLayout {
		
		private var _stageWidth: Number;
		private var _stageHeight: Number;
		
		public function FullScreenLayout() {
			onRemovedFromStage();
		}
		
		private function onAddedToStage( event: Event ): void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			stage.addEventListener( Event.RESIZE, onStageResize );
			onStageResize();
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
		}
		
		private function onStageResize( event: Event = null ) : void {
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
			triggerRender();
		}
		
		private function onRemovedFromStage( event: Event = null ): void {
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		override protected function render(): void {
			if( stage ) {
				var node: LayoutListNode = _layoutChildren.visibleFirst;
				while( node ) {
					_layoutChildren.visibleNext = node.visibleNext;
					node.content.measure( _stageWidth, _stageHeight, _size );
					node.content.resize( _size.width, _size.height );
					node = _layoutChildren.visibleNext;
				}
			}
		}
		
		override public function measure( baseWidth: Number, baseHeight: Number, result: Size ): void {
			baseWidth; baseHeight;
			result.width = stage.stageWidth;
			result.height = stage.stageHeight;
		}
	}
}
