/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: GridMenuLayout.as</p>
 * <p>Version: 0.2</p>
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
package com.custardbelly.as3flobile.controls.menu.layout
{
	import com.custardbelly.as3flobile.controls.menu.renderer.IMenuItemRenderer;
	import com.custardbelly.as3flobile.controls.shape.Divider;

	/**
	 * GridMenuLayout positions menu item views within a grid based on amount of available space and the maximum display amount of the target menu display. 
	 * @author toddanderson
	 */
	public class GridMenuLayout extends BaseMenuLayout
	{
		protected var _widthCache:Vector.<Number>;
		protected var _rowLengthCache:Vector.<int>;
		
		protected var _columnLength:int;
		
		/**
		 * Constructor.
		 */
		public function GridMenuLayout() 
		{ 
			super();
			_itemHeight = 50;
			_columnLength = 3;
			_widthCache = new Vector.<Number>();
			_rowLengthCache = new Vector.<int>();
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			var items:Vector.<IMenuItemRenderer> = _target.items;
			if( items == null || items.length == 0 ) return;
			
			const dividerWidth:int = 2;
			var i:int;
			var length:int;
			var xpos:int = _target.padding.left;
			var ypos:int = _target.padding.top;
			var item:IMenuItemRenderer;
			var horizPadding:int = _target.padding.left + _target.padding.right;
			var availableWidth:int = width - horizPadding;
			var divider:Divider;
			// If the amount of items is less that the column count, we can save processing by working in a small subset of length.
			if( items.length <= _columnLength )
			{
				var percentWidth:int = availableWidth / items.length;
				length = items.length;
				for( i = 0; i < length; i++ )
				{
					item = items[i];
					item.width = percentWidth;
					item.height = _itemHeight;
					item.x = xpos;
					item.y = ypos;
					xpos += percentWidth;
					
					if( i < length - 1 )
					{
						divider = _target.addDivider();
						divider.width = dividerWidth;
						divider.height = _itemHeight;
						divider.x = xpos - ( dividerWidth * 0.5 );
						divider.y = ypos;
					}
				}
			}
			// Else we will cycle through and assemble the rows based on column count and maximum display amount of the target menu display.
			else 
			{
				// Empty cache to fill again with new values.
				while( _widthCache.length > 0 )
					_widthCache.shift();
				
				while( _rowLengthCache.length > 0 )
					_rowLengthCache.shift();
				
				// Initial partial length determines the amount of items in the top row.
				var partialLength:int = items.length * ( _columnLength / _target.maximumItemDisplayAmount );
				var total:int = 0;
				var increment:int;
				// Cycle through each row, and create new as needed.
				while( partialLength > 0 )
				{
					_rowLengthCache[_rowLengthCache.length] = partialLength;
					for( i = 0; i < partialLength; i++ )
					{
						_widthCache[total++] = availableWidth / partialLength;
					}
					increment = items.length - total;
					partialLength = ( increment > _columnLength ) ? _columnLength : increment;
				}
				
				// With values set for width and row length, start positioning the items held on the target.
				length = items.length;
				var lengthIndex:int;
				var rowIndex:int;
				for( i = 0; i < length; i++ )
				{
					item = items[i];
					item.width = _widthCache[i];
					item.height = _itemHeight;
					item.x = xpos;
					item.y = ypos;
					xpos += _widthCache[i];
					lengthIndex++;
					
					if( i < length - 1 && _rowLengthCache[rowIndex] != lengthIndex )
					{
						divider = _target.addDivider();
						divider.width = dividerWidth;
						divider.height = _itemHeight;
						divider.x = xpos - ( dividerWidth * 0.5 );
						divider.y = ypos;
					}
					else if( _rowLengthCache[rowIndex] == lengthIndex ) 
					{
						ypos += _itemHeight;
						xpos = _target.padding.left;
						rowIndex++;
						lengthIndex = 0;
						
						if( i < length - 1 )
						{
							divider = _target.addDivider();
							divider.width = availableWidth;
							divider.height = dividerWidth;
							divider.y = ypos - ( dividerWidth * 0.5 );
							divider.x = xpos;
						}
					}
				}
			}
			item = items[items.length -1];
			// Update the visible dimensions of child items on the target.
			_contentWidth = availableWidth;
			_contentHeight = item.y + item.height;
		}

		/**
		 * @inherit
		 */
		override public function dispose():void
		{
			super.dispose();
			_widthCache = null;
			_rowLengthCache = null;
		}

		/**
		 * Accessor/Modifier for the column count of each row within the grid. Default is 3. 
		 * @return int
		 */
		public function get columnLength():int
		{
			return _columnLength;
		}
		public function set columnLength(value:int):void
		{
			_columnLength = value;
		}
	}
}