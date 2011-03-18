// @license
package nanosome.fit {
	
	import nanosome.util.pool.returnInstance;
	import nanosome.util.pool.poolInstance;
	import flash.utils.Dictionary;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class LayoutList {
		
		public var visibleFirst: LayoutListNode;
		public var visibleNext: LayoutListNode;
		
		internal var visibleLast: LayoutListNode;
		internal var first: LayoutListNode;
		internal var next: LayoutListNode;
		internal var last: LayoutListNode;
		internal var size: int = 0;
		
		private const _registry : Dictionary = new Dictionary();
		
		public function LayoutList() {}
		
		public function update( content: ILayoutable ): void {
			updateVisibility( content,  LayoutListNode( _registry[ content ] ) );
		}
		
		private function updateVisibility( content: ILayoutable, node: LayoutListNode ): void
		{
			if( content.visible != node.isVisible )
			{
				node.isVisible = content.visible;
				if( content.visible )
				{
					if( !visibleFirst )
					{
						visibleFirst = node;
						visibleLast = node;
						return;
					}
					var current: LayoutListNode = node.prev;
					while( current )
					{
						if( current.isVisible )
						{
							node.visiblePrev = current;
							current.visibleNext = node;
							
							if( ( node.visibleNext = current.visibleNext ) )
								node.visibleNext.visiblePrev = node;
							else
								visibleLast = node;
							
							return;
						}
						current = current.prev;
					}
					current = node.next;
					while( current )
					{
						if( current.isVisible )
						{
							// Means that there is no former visible node found!
							node.visibleNext = current;
							current.visiblePrev = node;
							
							visibleFirst = node;
							
							return;
						}
						current = current.next;
					}
				} else {
					if( node.visibleNext )
						node.visibleNext.visiblePrev = node.visiblePrev;
						
					if( node.visiblePrev )
						node.visiblePrev.visibleNext = node.visibleNext;
					
					node.visibleNext = null;
					node.visiblePrev = null;
				}
			}
		}
		
		public function add( content: ILayoutable ): void
		{
			var node: LayoutListNode = _registry[ content ];
			if( node )
			{
				if( node == last ) {
					return;
				}
				
				if( node == first )
					first = node.next;
				else
					node.prev.next = node.next;
				
				if( node == visibleFirst )
					visibleFirst = node.visibleNext;
				else
					node.visiblePrev.visibleNext = node.visibleNext;
				
				node.next.prev = node.prev;
				
				if( content.visible && node.visibleNext )
					node.visibleNext.visiblePrev = node.visiblePrev;
				
				node.visibleNext = null;
				node.next = null;
				
				++size; 
			}
			else
			{
				node = poolInstance( LayoutListNode );
				
				if( !first ) first = node;
				
				if( !next ) next = node;
				
				if( content.visible )
				{
					if( !visibleNext ) visibleNext = node;
					
					if( !visibleFirst ) visibleFirst = node;
				}
				updateVisibility( content, node );
			}
			
			if( last )
			{
				last.next = node;
				node.prev = last;
			}
			last = node;
			
			if( content.visible )
			{
				if( visibleLast )
				{
					visibleLast.next = node;
					node.visiblePrev = visibleLast;
				}
				visibleLast = node;
			}
			
			node.content = content;
			node.isVisible = content.visible;
			_registry[ content ] = node;
		}

		public function contains( node: ILayoutable ): Boolean
		{
			return _registry[ node ] != null;
		}
		
		public function remove( content: ILayoutable ): void
		{
			var node: LayoutListNode = _registry[ content ];
			if( node ) {
 				clearNode( node );
				returnInstance( node );
				--size;
			}
		}
		
		private function clearNode( node: LayoutListNode ): void {
			delete _registry[node.content];
			
			if( node == last ) last = node.prev;
			else node.next.prev = node.prev;
			
			if( node == first ) first = node.next;
			else node.prev.next = node.next;
			
			if( node.isVisible )
			{
				if( node == visibleLast ) visibleLast = node.visiblePrev;
				else node.visibleNext.visiblePrev = node.visiblePrev;
				
				if( node == visibleFirst ) visibleFirst = node.visibleNext;
				else node.visiblePrev.visibleNext = node.visibleNext;
			}
		}

		public function addAt( content: ILayoutable, position : int ): void {
			if( position >= size ) {
				add( content );
			} else {
				var node: LayoutListNode = _registry[ content ];
				if( node ) {
					node = poolInstance( LayoutListNode );
				} else {
					clearNode( node );
				}
				node.content = content;
				node.isVisible = content.visible;
				
				if( position == 0 ) {
					node.next = first;
					first.prev = node;
					first = node;
					
					if( content.visible ) {
						if( visibleFirst ) {
							node.visibleNext = visibleFirst;
							visibleFirst.visiblePrev = node;
						}
						visibleFirst = node;
					}
				} else {
					var i: int = 0;
					var next: LayoutListNode = first;
					var visiblePrev: LayoutListNode = null;
					
					while( i < position ) {
						if( next.isVisible ) {
							visiblePrev = next;
						}
						next = next.next;
						++i;
					}
					
					if( visiblePrev ) {
						
						node.visiblePrev = visiblePrev;
						
						if( (node.visibleNext = visiblePrev.visibleNext) ) {
							node.visibleNext.visiblePrev = node;
						} else {
							visibleLast = node;
						}
						
						visiblePrev.visibleNext = node;
					} else {
						node.visibleNext = visibleFirst;
						
						if( visibleFirst ) {
							visibleFirst.visiblePrev = node;
						}
						
						visibleFirst = node;
					}
					node.prev = next.prev;
					node.next = next;
					next.prev = node;
				}
				++size;
				_registry[ content ] = node;
			}
		}
	}
}
