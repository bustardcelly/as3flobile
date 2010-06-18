/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IScrollListLayout.as</p>
 * <p>Version: 0.1</p>
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
package com.custardbelly.as3flobile.view.list.layout
{
	import com.custardbelly.as3flobile.view.list.IScrollListContainer;

	/**
	 * IScrollListLayout is the layout manager that handles positioning display content for the target IScrollListContainer implementation. 
	 * @author toddanderson
	 */
	public interface IScrollListLayout
	{
		/**
		 * Update request on the display of child content for the target IScrollListContainer.
		 */
		function updateDisplay():void;
		/**
		 * Update request on the display of content for the target IScrollListContainer based on change to scroll position.
		 */
		function updateScrollPosition():void;
		
		/**
		 * Returns the index position of a child element on the target IScrollListContainer. 
		 * @param xposition Number The position along the x axis.
		 * @param yposition Number The position along the y axis.
		 * @return int
		 */
		function getChildIndexAtPosition( xposition:Number, yposition:Number ):int;
		
		/**
		 * Returns the determined content width of a IScrollListContainer based on its layout of child content. 
		 * @return Number
		 */
		function getContentWidth():Number;
		/**
		 * Returns the determined content height of a IScrollListContainer based on its layout of child content. 
		 * @return Number
		 */
		function getContentHeight():Number;
		
		/**
		 * Performs any necessary clean up.
		 */
		function dispose():void;
		
		/**
		 * Accessor/Modifier of the target IScrollListContainer instance. 
		 * @return IScrollListContainer
		 */
		function get target():IScrollListContainer;
		function set target( value:IScrollListContainer ):void;
	}
}