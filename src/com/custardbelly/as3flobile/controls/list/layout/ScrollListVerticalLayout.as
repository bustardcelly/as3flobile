/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: ScrollListVerticalLayout.as</p>
 * <p>Version: 0.4</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */
package com.custardbelly.as3flobile.controls.list.layout
{
	import com.custardbelly.as3flobile.controls.list.IScrollListContainer;
	import com.custardbelly.as3flobile.controls.list.IScrollListLayoutTarget;
	import com.custardbelly.as3flobile.controls.list.renderer.IScrollListItemRenderer;
	import com.custardbelly.as3flobile.enum.OrientationEnum;
	import com.custardbelly.as3flobile.model.BoxPadding;
	import com.custardbelly.as3flobile.util.DisplayPositionSearch;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ScrollListVerticalLayout is an IScrollListVerticalLayout implementation to layout children of a target IScrollListContainer along the y axis. 
	 * @author toddanderson
	 */
	public class ScrollListVerticalLayout implements IScrollListVerticalLayout
	{
		protected var _target:IScrollListContainer;
		protected var _contentWidth:Number;
		protected var _contentHeight:Number;
		
		protected var _itemHeight:Number;
		protected var _padding:BoxPadding;
		protected var _useVariableHeight:Boolean;
		
		protected var _indexPositionCache:Point;
		
		/**
		 * @private
		 * 
		 * Cache of height of each child display item on IScrollListContainer display list. 
		 */
		protected var _heightCache:Vector.<int>;
		/**
		 * @private
		 * 
		 * Reference to the largest height of a child display item on IScrollListContainer display list to determine positioning within a variable layout. 
		 */
		protected var _tallestRowHeight:Number;
		
		/**
		 * Constructor.
		 */
		public function ScrollListVerticalLayout() 
		{
			_heightCache = new Vector.<int>();
			_padding = new BoxPadding();
			_indexPositionCache = new Point();
		}
		
		/**
		 * @private
		 *  
		 * Validates the box model padding between the list target edge and the renderers.
		 */
		protected function invalidatePadding():void
		{
			if( _target == null ) return;
			
			var renderers:Vector.<IScrollListItemRenderer> = _target.renderers;
			var rect:Rectangle = _target.scrollBounds;
			var i:int = 0;
			var length:int = renderers.length;
			var renderer:IScrollListItemRenderer;
			var ypos:int = 0;
			while( i < length )
			{
				renderer = renderers[i];
				renderer.lock();
				renderer.width = rect.width - _padding.left - _padding.right;
				if( !isNaN( _itemHeight ) ) renderer.height = _itemHeight;
				renderer.unlock();
				
				( renderer as DisplayObject ).y = ypos;
				( renderer as DisplayObject ).x = 0;
				ypos += renderer.height + _target.seperatorLength;
				i++;
			}
			
			// Cache the heights.
			cacheHeights( _target.renderers );
			// Update the determined width of the content.
			_contentWidth = rect.width;
			( _target as IScrollListLayoutTarget ).commitContentChange();
		}
		
		/**
		 * @private
		 * 
		 * Delegate function to determine if an item resides above or below the position. 
		 * @param item DisplayObject
		 * @param position Number
		 * @return Boolean
		 * @see #DisplayPositionSearch
		 */
		protected function compareItemPosition( item:DisplayObject, position:Number ):Boolean
		{
			return (item.y < position) && (item.y + item.height < position);
		}
		
		/**
		 * @private
		 * 
		 * Delegate function to determine if an item lies within the position on the display. 
		 * @param item DisplayObject
		 * @param position Number
		 * @return Boolean
		 * @see #DisplayPositionSearch
		 */
		protected function isWithinRange( item:DisplayObject, position:Number ):Boolean
		{
			return (item.y <= position) && (item.y + item.height >= position);
		}

		/**
		 * @private
		 * 
		 * Caches the height of each IScrollListItemRenderer instance for speed of use in determining layout. 
		 * @param cells Vector.<IScrollListItemRenderer> The list to traverse and cache widths from.
		 */
		protected function cacheHeights( cells:Vector.<IScrollListItemRenderer> ):void
		{	
			var i:int = cells.length;
			var h:Number;
			var seperator:int = _target.seperatorLength;
			_heightCache = new Vector.<int>( i );
			_contentHeight = 0;
			while( --i > -1 )
			{
				h = cells[i].height;
				_contentHeight += h;
				_heightCache[i] = h;
			}
			_contentHeight += ( ( _heightCache.length - 1 ) * seperator ) + ( _padding.top + _padding.bottom );
			_tallestRowHeight = ( _heightCache.length > 0 ) ? _heightCache.sort( Array.NUMERIC )[_heightCache.length - 1] : 0;
		}
		
		/**
		 * @private 
		 * 
		 * Empties cache of heights for IScrollListItemRenderer instances.
		 */
		protected function emptyHeightCache():void
		{
			while( _heightCache.length > 0 )
				_heightCache.shift();
		}
		
		/**
		 * @copy IScrollListLayout#updateDisplay()
		 */
		public function updateDisplay():void
		{
			var renderers:Vector.<IScrollListItemRenderer> = _target.renderers;
			var data:Array = _target.dataProvider;
			var rect:Rectangle = _target.scrollBounds;
			var i:int = 0;
			var length:int = renderers.length;
			var renderer:IScrollListItemRenderer;
			var ypos:int = _padding.top;
			while( i < length )
			{
				renderer = renderers[i];
				renderer.lock();
				renderer.orientation = OrientationEnum.VERTICAL;
				renderer.useVariableWidth = false;
				renderer.useVariableHeight = _useVariableHeight;
				renderer.width = rect.width - _padding.left - _padding.right;
				if( !isNaN( _itemHeight ) ) renderer.height = _itemHeight;
				renderer.data = data[i];
				renderer.unlock();
				( renderer as DisplayObject ).y = ypos;
				( renderer as DisplayObject ).x = 0;
				( _target as IScrollListLayoutTarget ).addRendererToDisplay( renderer );
				ypos += renderer.height + _target.seperatorLength;
				i++;
			}
			
			// Cache the heights.
			cacheHeights( _target.renderers );
			// Update the determined width of the content.
			_contentWidth = rect.width;
			// Notify of commit change.
			( _target as IScrollListLayoutTarget ).commitContentChange();
		}
		
		/**
		 * @copy IScrollListLayout#updateScrollPosition()
		 */
		public function updateScrollPosition():void
		{
			/*
			// 	[NOTE] 
			//	This has been deprecated to save rendering time.
			//	Previous implementation ensured only needed list items were on the display list.
			//	Unfortunately this was too expensive during runtime and affacted the rendering position of list items.
			//	Left in or histories sake, if we circle around and want to implement on-demand item rendering.
			//	[/NOTE]
			
			var currentScrollPosition:Number = _target.scrollPosition.y;
			var position:Number = ( currentScrollPosition > 0.0 ) ? currentScrollPosition : -currentScrollPosition;
			
			var cells:Vector.<IScrollListItemRenderer> = _target.renderers;
			var cellAmount:int = cells.length;
			var rect:Rectangle = _target.scrollBounds;
			var scrollAreaHeight:Number = rect.height - rect.y;
			var cellHeight:Number = _itemHeight + _target.seperatorLength;
			var startIndex:int;
			var endIndex:int;
			
			// If using variable height, determine visible content using the DisplayPositionSearch algorithm.
			if( _useVariableHeight )
			{
				startIndex = DisplayPositionSearch.findCellIndexInPosition( cells, position, compareItemPosition, isWithinRange );
				endIndex = DisplayPositionSearch.findCellIndexInPosition( cells, position + scrollAreaHeight + _tallestRowHeight, compareItemPosition, isWithinRange );	
				endIndex = ( endIndex == -1 && startIndex > -1 ) ? cellAmount : endIndex;
			}
			// Else determine visible content faster based on index values.
			else
			{
				var length:Number = ( scrollAreaHeight / cellHeight );
				startIndex = int( position / cellHeight );
				length = ( length % 1 ) ? int(length) + 1 : length;
				endIndex = startIndex + int(length) + 1;
			}
			
			// Use the start and end index to find visible content.
			var index:int = cellAmount;
			var cell:IScrollListItemRenderer;
			var listProvider:Array = _target.dataProvider;
			while( --index > -1 )
			{
				cell = cells[index];
				if( index >= startIndex && index < endIndex )
				{
					IScrollListItemRenderer(cell).data = listProvider[index];
					( _target as IScrollListLayoutTarget ).addRendererToDisplay( cell );
				}
				else
				{
					( _target as IScrollListLayoutTarget ).removeRendererFromDisplay( cell );
				}
			}
			*/
		}
		
		/**
		 * @copy IScrollListLayout#getPositionFromIndex()
		 */
		public function getPositionFromIndex( index:uint ):Point
		{
			// Find renderer y position based on index.
			// TODO: Shouldn't need to chek for null references here. This should not be called if that is the case.
			var cells:Vector.<IScrollListItemRenderer> = ( _target ) ? _target.renderers : null;
			if( cells == null ) return _indexPositionCache;
			
			// Update cache position based on index.
			if( index > cells.length - 1 )
			{
				_indexPositionCache.y = 0;
			}
			else
			{
				// Since we are scrolling content up, the value is always negative. Return it positive.
				_indexPositionCache.y = -( ( cells[index] as DisplayObject ).y - _padding.top ) - _target.padding.top;
			}
			_indexPositionCache.x = 0;
			return _indexPositionCache;
		}
		
		/**
		 * @copy IScrollListLayout#getChildIndexAtPosition()
		 */
		public function getChildIndexAtPosition( xposition:Number, yposition:Number ):int
		{
			var cells:Vector.<IScrollListItemRenderer> = _target.renderers;
			return DisplayPositionSearch.findCellIndexInPosition( cells, yposition, compareItemPosition, isWithinRange );
		}
		
		/**
		 * @copy IScrollListLayout#getContentWidth()
		 */
		public function getContentWidth():Number
		{
			return _contentWidth;
		}
		/**
		 * @copy IScrollListLayout#getContentHeight()
		 */
		public function getContentHeight():Number
		{
			return _contentHeight;
		}
		
		/**
		 * @copy IScrollListLayout#dispose()
		 */
		public function dispose():void
		{
			emptyHeightCache();
			_target = null;
		}
		
		/**
		 * @copy IScrollListLayout#padding 
		 */
		public function get padding():BoxPadding
		{
			return _padding;
		}
		public function set padding( value:BoxPadding ):void
		{
			if( BoxPadding.equals( _padding, value ) ) return;
			
			_padding = value;
			invalidatePadding();
		}
		
		/**
		 * @copy IScrollListLayout#target
		 */
		public function get target():IScrollListContainer
		{
			return _target;
		}
		public function set target( value:IScrollListContainer ):void
		{
			_target = value;
		}
		
		/**
		 * @copy IScrollListVerticalLayout#itemHeight
		 */
		public function get itemHeight():Number
		{
			return _itemHeight;
		}
		public function set itemHeight(value:Number):void
		{
			if( _itemHeight == value ) return;
			
			_itemHeight = value;
			if( _target != null ) updateDisplay();
		}
		
		/**
		 * @copy IScrollListVerticalLayout#useVariableHeight
		 */
		public function get useVariableHeight():Boolean
		{
			return _useVariableHeight;
		}
		public function set useVariableHeight(value:Boolean):void
		{
			if( _useVariableHeight == value ) return;
			
			_useVariableHeight = value;
			if( _target != null ) 
			{
				updateDisplay();
				updateScrollPosition();
			}
		}
	}
}