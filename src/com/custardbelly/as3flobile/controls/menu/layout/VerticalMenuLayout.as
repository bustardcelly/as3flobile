/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: VerticalMenuLayout.as</p>
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

	/**
	 * VerticalMenuLayout is a layout manager to display items of a traget menu display along the y-axis. 
	 * @author toddanderson
	 */
	public class VerticalMenuLayout extends BaseMenuLayout
	{
		protected var _itemHeight:int;
		
		/**
		 * Constructor.
		 */
		public function VerticalMenuLayout()
		{
			super();
			_itemHeight = 50;
		}
		
		/**
		 * @inherit
		 */
		override public function updateDisplay( width:int, height:int ):void
		{
			var items:Vector.<IMenuItemRenderer> = _target.items;
			if( items == null || items.length == 0 ) return;
			
			var i:int;
			var length:int = items.length;
			var xpos:int = _target.padding.left;
			var ypos:int = _target.padding.top;
			var item:IMenuItemRenderer;
			var horizPadding:int = _target.padding.left + _target.padding.right;
			var availableWidth:int = width - horizPadding;
			for( i = 0; i < length; i++ )
			{
				item = items[i];
				item.width = availableWidth;
				item.height = _itemHeight;
				item.x = xpos;
				item.y = ypos;
				ypos += _itemHeight;
			}
			_contentWidth = availableWidth;
			_contentHeight = ypos;
		}

		/**
		 * Accessor/Modifier for the unified item height of each item in the layout.
		 * @return int
		 */
		public function get itemHeight():int
		{
			return _itemHeight;
		}
		public function set itemHeight(value:int):void
		{
			_itemHeight = value;
		}
	}
}