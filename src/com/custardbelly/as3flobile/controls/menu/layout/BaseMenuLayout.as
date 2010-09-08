/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: BaseMenuLayout.as</p>
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
	import com.custardbelly.as3flobile.enum.DimensionEnum;
	
	/**
	 * BaseMenuLayout is a base class for layouts of menu panels in a Menu control. 
	 * @author toddanderson
	 */
	public class BaseMenuLayout implements IMenuLayout
	{
		protected var _contentWidth:Number;
		protected var _contentHeight:Number;
		protected var _target:IMenuLayoutTarget;
		
		/**
		 * Constructor.
		 */
		public function BaseMenuLayout() 
		{
			_contentWidth = DimensionEnum.UNDEFINED;
			_contentHeight = DimensionEnum.UNDEFINED;
		}
		
		/**
		 * Updates the layout based on dimensions. Marked for override. 
		 * @param width int
		 * @param height int
		 */
		public function updateDisplay( width:int, height:int ):void
		{
			// abstract. Marked for override.
		}
		
		/**
		 * Returns the width of the content within the layout. 
		 * @return Number
		 */
		public function getContentWidth():Number
		{
			return _contentWidth;
		}
		/**
		 * Returns the height of the content within the layout. 
		 * @return Number
		 */
		public function getContentHeight():Number
		{
			return _contentHeight;
		}
		
		/**
		 * @copy IMenuLayout#target
		 */
		public function get target():IMenuLayoutTarget
		{
			return _target;
		}
		public function set target( value:IMenuLayoutTarget ):void
		{
			_target = value;
		}
		
		/**
		 * @copy IDisposable#dispose()
		 */
		public function dispose():void
		{
			_target = null;
		}
	}
}