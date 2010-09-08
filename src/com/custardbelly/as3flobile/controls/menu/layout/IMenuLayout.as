/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IMenuLayout.as</p>
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
	import com.custardbelly.as3flobile.model.IDisposable;

	/**
	 * IMenuLayout is layout manager for items of a target menu display. 
	 * @author toddanderson
	 */
	public interface IMenuLayout extends IDisposable
	{
		/**
		 * Updates the layout of child items of the target menu display based on dimensions. 
		 * @param width int
		 * @param height int
		 */
		function updateDisplay( width:int, height:int ):void;
		
		/**
		 * Returns the space along the x-axis that the layout of child items resides in. 
		 * @return Number
		 */
		function getContentWidth():Number;
		/**
		 * Returns the space along the y-axis that the layout of child items resides in. 
		 * @return Number
		 */
		function getContentHeight():Number;
		
		/**
		 * Accessor/Modifier for the layout target from which to access display children required for layout. 
		 * @return IMenuLayoutTarget
		 */
		function get target():IMenuLayoutTarget;
		function set target( value:IMenuLayoutTarget ):void;
	}
}