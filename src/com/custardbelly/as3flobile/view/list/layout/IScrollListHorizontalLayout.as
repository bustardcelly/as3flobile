/**
 * <p>Original Author: toddanderson</p>
 * <p>Class File: IScrollListHorizontalLayout.as</p>
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
	/**
	 * IScrollListHorizontalLayout is an extension of IScrollListLayout that exposes model properties to act on child content of a target IScrollListContainer. 
	 * @author toddanderson
	 */
	public interface IScrollListHorizontalLayout extends IScrollListLayout
	{
		/**
		 * Accessor/Modifier of the desired width dimension of all child content of target IScrollListContainer. 
		 * @return Number
		 */
		function get itemWidth():Number;
		function set itemWidth( value:Number ):void;
		
		/**
		 * Accessor/Modifier for flag to position child content of a IScrollListContainer based on their individual dimensions.
		 * If specified, IScrollListHorizontalLayout#itemWidth is ignored in positioning algorithm.
		 * @return Boolean
		 */
		function get useVariableWidth():Boolean;
		function set useVariableWidth( value:Boolean ):void;
	}
}